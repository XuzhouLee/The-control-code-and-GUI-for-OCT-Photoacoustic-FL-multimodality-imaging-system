%% COT probe getBScan_Callback
function freeScan_Callback(src, event, handles)
  
      
    flyback_overhead = 11;
    octStatus = getappdata(0, 'octStatus');
    
    if isempty(octStatus.Device) 
        errordlg('OCT is not initialized. Initialize before opening camera.')
        set(src, 'Value', 0);
        return
    end
    

    if isempty(getappdata(0,'PosYb')) == 1 & getappdata(0,'ScanType') == 1
            errordlg('Please select the scan position in video camera image');
            return
    end
    
    range = getappdata(0, 'ScanRange');
    Hrange = getappdata(0, 'HScanRange');
    points = getappdata(0, 'ScanPoints');
    angle = getappdata(0, 'ScanAngle')*pi/180;
    ScanType = getappdata(0,'ScanType');
    
    PosYa = getappdata(0,'PosYa');
    PosYb = getappdata(0,'PosYb');
    PosXa = getappdata(0,'PosXa');
    PosXb = getappdata(0,'PosXb');
    
    PosX1 = libpointer('doublePtr', 0);
    PosY1 = libpointer('doublePtr', 0);
    
    if ScanType == 1
        CenterX = roundn((PosXa+PosXb)./2,-4);
        CenterY = roundn((PosYa+PosYb)./2,-4);
        
        setappdata(0, 'centerX', CenterX); %default scan center is 0
        setappdata(0, 'centerY', CenterY); %default scan center is 0
        set(handles.PAM.CenterXEdt,'string',num2str(CenterX));
        set(handles.PAM.CenterYEdt,'string',num2str(CenterY));
    else
        CenterX = getappdata(0,'centerX');
        CenterY = getappdata(0,'centerY');
        if abs(CenterX-range./2)>8.5/2 || abs(CenterX+range./2)>8.5/2 || abs(CenterY+Hrange./2)>10/2 || abs(CenterY-Hrange./2)>10/2 ||...
            abs(CenterX-Hrange./2)>8.5/2 || abs(CenterX+Hrange./2)>8.5/2 || abs(CenterY+range./2)>10/2 || abs(CenterY-range./2)>10/2
            errordlg('Out of scan size,Please select a smaller scan area !');
            return
        end
    end
    
    
    
    
    ScanAxis = 'ScanAxis_X';
    HScanAxis = 'ScanAxis_Y' ;
    
    CNT = (points+flyback_overhead); % Number of triggers needed for scanning one line (pixels + overhead)
    
    
    %% define pattern: always Bscan
    
    calllib('octlib', 'setProbeParameterInt', octStatus.Probe, 'Probe_ApodizationCycles', 0);

     if calllib('octlib', 'isSLDAvailable', octStatus.Device) == 1 %use SLDAvailable to check if the OCT controller is connected and ON
         
        if get(src, 'Value') == 1
        set(handles.PAM.getBScanBtn,'enable','off');
        set(handles.PAM.HScanRangeEdt,'enable','off');
        set(handles.PAM.HScanPtsEdt,'enable','off');
        set(handles.PAM.WScanPtsEdt,'enable','off');
        set(handles.PAM.WScanRangeEdt,'enable','off');
        set(handles.PAM.ScanAxisEdt,'enable','off');
%         set(handles.PAM.setScanTypeBtn,'enable','off');
        end
        
        % switching the clock to the laser clock
        
        ClockSelect(1);

        %% session for synching gate with laser clock trigger
        SyncShutterGateSession = daq.createSession('ni');
        addAnalogInputChannel(SyncShutterGateSession,'Dev3',0,'Voltage'); %needed to clock the Digital output
        addDigitalChannel(SyncShutterGateSession, 'Dev3',  'Port0/Line0', 'OutputOnly'); % synched gate (also used to open the shutter)
        addTriggerConnection(SyncShutterGateSession,'external','Dev3/PFI0','StartTrigger'); %trigger: accepts input for laser clock


        SyncShutterGateSession.Rate = 1e4; %make the session clock 10x the laser clock (10kHz)
        SyncShutterGateSession.TriggersPerRun = 1;
        %s.IsContinuous = true;
        
        ClkRate = 1e3; %laser clock rate
        gateDelay = .1; %delay for gate to switch on after trigger in units of the laser clock period
        
        %Delayed gate
        outvec = [zeros(1, SyncShutterGateSession.Rate/ClkRate*gateDelay), ones(1,SyncShutterGateSession.Rate/ClkRate*CNT), 0]';
        disp('3')
        %% loop while "Scan Mirror" is ON (true)
        while get(src, 'Value') == 1
            
            setappdata(0, 'ContinuousScan', 1); % flag to disable acquisition when Free Scan is ON
            
            if getappdata(0,'ScanType') == 0
               % Unrotated scan pattern
               Pattern = calllib('octlib', 'createBScanPatternManual', octStatus.Probe, -range/2, 0, range/2, 0, points, 0);
               calllib('octlib', 'shiftScanPattern', Pattern, CenterX, CenterY);
               % rotate pattern to desired angle
               calllib('octlib', 'rotateScanPattern', Pattern, angle);
            elseif getappdata(0,'ScanType') == 1
               
               Pattern = calllib('octlib', 'createBScanPatternManual', octStatus.Probe, getappdata(0,'PosXa'), getappdata(0,'PosYa'), getappdata(0,'PosXb'), getappdata(0,'PosYb'), points, 0);
               
            end
            setappdata(0,'Pattern',Pattern)

            disp('setting up measurement');
            calllib('octlib', 'startMeasurement', octStatus.Device, Pattern, 'Acquisition_AsyncFinite')%Finite
            
            % send signal to NI card to release triggers to start scanning
            queueOutputData(SyncShutterGateSession,outvec);
%             disp('starting NI DAQ foreground');
            startForeground(SyncShutterGateSession); %measurement in Forefground so Matlab is not doing anything until measurement is finished.
 
            % stop measurement
            disp('stopping measurement ...');
            calllib('octlib', 'stopMeasurement', octStatus.Device);
            disp('Measurement stoped');
        end

        setappdata(0, 'ContinuousScan', 0);    
        
        %% delete session    
        release(SyncShutterGateSession);
        delete(SyncShutterGateSession);
        
        
        disp('returning scanners to start position');
        calllib('octlib', 'moveScanner', octStatus.Device, octStatus.Probe, ScanAxis, 0);
        calllib('octlib', 'moveScanner', octStatus.Device, octStatus.Probe, HScanAxis, 0);
        
        
        %% reset clock select to OCT
        ClockSelect(0);
        if get(src, 'Value') ~= 1
        set(handles.PAM.getBScanBtn,'enable','on');
        patternType = getappdata(0, 'patternType');
        if patternType ~= 2
        set(handles.PAM.HScanRangeEdt,'enable','on');
        set(handles.PAM.HScanPtsEdt,'enable','on');
        end
        set(handles.PAM.WScanPtsEdt,'enable','on');
        set(handles.PAM.WScanRangeEdt,'enable','on');
        set(handles.PAM.ScanAxisEdt,'enable','on');
%         set(handles.PAM.setScanTypeBtn,'enable','on');
        end
    end
   
    
 end