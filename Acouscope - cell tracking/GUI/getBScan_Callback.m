%% COT probe getBScan_Callback
function getBScan_Callback(src, event, handles)
    
    %check if scanner in free scan mode:
    if getappdata(0, 'ContinuousScan') == 1
        errordlg('Scanner in free scan mode. Stop Free Sacn before acquiring an image.');
        return
    end

    pause(1)
    % setting up tcpip server for comunication with DAQ computer
    tcpipServer = getappdata(0, 'tcpipServer');
    Scanline = getappdata(0,'Scanline');
    
    %% check if connection open
    if ~strcmp(tcpipServer.Status, 'open')
        errordlg('TCP/IP connection status is closed. Refresh connection for both server and client and try again');
        return
    end 
    
    ScanType = getappdata(0,'ScanType');
    

        
    flyback_overhead = 11; % Number of triggers needed for scanning one line (pixels + overhead)
    octStatus = getappdata(0, 'octStatus');
    
    if isempty(octStatus.Device) 
        errordlg('OCT is not initialized. Initialize before acquiring image.')
        return
    end
    
    
    
    
    range = getappdata(0, 'ScanRange');
    points = getappdata(0, 'ScanPoints');
    Hrange = getappdata(0, 'HScanRange');
    rows = getappdata(0, 'ScanRows');
    
    PosYa = getappdata(0,'PosYa');
    PosYb = getappdata(0,'PosYb');
    PosXa = getappdata(0,'PosXa');
    PosXb = getappdata(0,'PosXb');
    
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
      
    
    %% define pattern: Bscan (One file image per row; better alignment) vs Volume (one file for whole image; faster)
    patternType = getappdata(0, 'patternType')
    patternType
    
    
    % check the free position select
    if isempty(getappdata(0,'PosYb')) == 1 & ScanType == 1 & patternType ~= 1
            errordlg('Please select the scan position in video camera image');
            return
    end
       
       
    if patternType == 1 %Point scan
        flyback_overhead = 0;
        CNT = (points+flyback_overhead);
        iRows = 1;

    elseif patternType == 2 %Line scan
%         flyback_overhead = 0;
        CNT = (points+flyback_overhead); % triggers needed per row(including overhead for initial positioning) when acquiring B-Scans;
        iRows = rows;
    elseif patternType == 3 % Volume Scan or 2D scan
        
        if ScanType == 1
            range = abs(PosXa-PosXb);
            Hrange = abs(PosYa-PosYb);
            rows = floor(Hrange*points/range);
            Pattern = calllib('octlib', 'createVolumePattern', octStatus.Probe, abs(PosXa-PosXb), points, abs(PosYa-PosYb), rows);
            calllib('octlib', 'shiftScanPattern', Pattern, CenterX, CenterY);
        else
            Pattern = calllib('octlib', 'createVolumePattern', octStatus.Probe, range, points, Hrange, rows);
            calllib('octlib', 'shiftScanPattern', Pattern, CenterX, CenterY);
            calllib('octlib', 'rotateScanPattern', Pattern, getappdata(0, 'ScanAngle')*pi/180);
        end
        CNT = (points+flyback_overhead)*rows; %total triggers needed (including overhead for initial positioning
        iRows = 1;
    end
    
    calllib('octlib', 'setProbeParameterInt', octStatus.Probe, 'Probe_ApodizationCycles', 0);

    
  disp('test1');  
    
    
    if calllib('octlib', 'isSLDAvailable', octStatus.Device) == 1
        
        %% session for clock select - not synched
        % switching the clock to the laser clock
        ClockSelect(1);
        
        %% session for synching gate with laser clock trigger
        SyncShutterGateSession = daq.createSession('ni');
        addAnalogInputChannel(SyncShutterGateSession,'Dev3',0,'Voltage'); %needed to clock the Digital output
        addDigitalChannel(SyncShutterGateSession, 'Dev3',  'Port0/Line0', 'OutputOnly'); % synched gate (also used to open the shutter)
        addTriggerConnection(SyncShutterGateSession,'external','Dev3/PFI0','StartTrigger'); %trigger: accepts input for laser clock


        SyncShutterGateSession.Rate = 5e4; %make the session clock 10x the laser clock (10kHz)
        SyncShutterGateSession.TriggersPerRun = 1;
        %s.IsContinuous = true;
        
        ClkRate = 5e3; %laser clock rate
        gateDelay = .1; %delay for gate to switch on after trigger in units of the laser clock period
        
        %Delayed gate
        outvec = [zeros(1, SyncShutterGateSession.Rate/ClkRate*gateDelay), ones(1,SyncShutterGateSession.Rate/ClkRate*CNT), 0]';        
       
        %% send image information via tcpip to DAQ computer
        % params = [B-Scan width in pixels, row number, flyback trigger
        % count, patternType, averages, WRange in microns, HRange in microns]
        if patternType == 1 %Point scan
           points = 1;
           rows = 1;
        
        end
        disp('writing params');
        params = [points, rows, flyback_overhead, patternType, 1, range*1000, Hrange*1000,getappdata(0, 'OffsetCH1'),...
        getappdata(0, 'OffsetCH2'),getappdata(0, 'OffsetCH3'),getappdata(0, 'OffsetCH4'),(100+getappdata(0, 'PreTrigSampl'))*10,...
        getappdata(0, 'AtrigLevel'),getappdata(0, 'SamplingRateMHz'),getappdata(0, 'AcqLengthPoint'),...
        getappdata(0, 'ActivChNum'),getappdata(0, 'Channeloption'),ScanType,fix((PosXa+4.3)*100),((PosXa+4.3)*100-fix((PosXa+4.3)*100))*100,...
        fix((PosYa+5)*100),((PosYa+5)*100-fix((PosYa+5)*100))*100,fix((PosXb+4.3)*100),((PosXb+4.3)*100-fix((PosXb+4.3)*100))*100,...
        fix((PosYb+5)*100),((PosYb+5)*100-fix((PosYb+5)*100))*100];  %,ScanType,PosXa*1000,PosYa*1000,PosXb*1000,PosYb*1000
        fwrite(tcpipServer,params,'uint16');
        
            %% loop over rows
            FLAG = 0;
            for i =1:iRows
                %% check that the DAQ card is armed and ready
                timerStartTime = datenum(clock);
                while datenum(clock) < (timerStartTime + 10/24/3600)  % check fot current time less than timerStartTime + 10 seconds
                    %disp('waiting for flag...')
                    if tcpipServer.BytesAvailable > 0
                        disp('reading flag')
                        FLAG = fread(tcpipServer, 1, 'uint16')

                        if FLAG == 9   %FLAG that ot enough memory
                            disp('Not enough memory for this acquisition. Change image and or acquisition parameters.')
                            return
                        elseif FLAG == 7
                            disp('DAQ card ready for acquisition');
                            break
                        end
                    end
                end
                
                if FLAG == 0
                    disp('Could not reach client. Maybe disconnected or busy with acquisition. Make sure client program is running and refresh the DAQ Server.');
                    return
                end
                    
                
                if patternType == 2  
                    if ScanType == 0
                        if rows ==1
                            HPos = 0;
                        else
                            HPos = -Hrange + 2* (i-1)*Hrange/(rows-1);
                        end
                        Pattern = calllib('octlib', 'createBScanPatternManual', octStatus.Probe, -range/2, HPos/2, range/2, HPos/2, points, 0);
                        calllib('octlib', 'shiftScanPattern', Pattern, CenterX, CenterY);
                        calllib('octlib', 'rotateScanPattern', Pattern, getappdata(0, 'ScanAngle')*pi/180);
                        
                    elseif ScanType == 1
%                         Pattern = calllib('octlib', 'createBScanPatternManual', octStatus.Probe, PosXa, PosYa, PosXb, PosYb, points, 0)
                          Pattern = calllib('octlib', 'createBScanPatternManual', octStatus.Probe, getappdata(0,'PosXa'), getappdata(0,'PosYa'), getappdata(0,'PosXb'), getappdata(0,'PosYb'), points, 0)
                    end
                    
                elseif patternType == 1
%                     HPos = 0;
%                     range = 0;
                    % Line scan pattern with rotation
%                     Pattern = calllib('octlib', 'createNoScanPattern', octStatus.Probe, 1, 1);
%                     calllib('octlib', 'rotateScanPattern', Pattern, getappdata(0, 'ScanAngle')*pi/180);
                center_finder;

%                 calllib('octlib', 'moveScanner', octStatus.Device, octStatus.Probe, ScanAxis, CenterX);
%                 calllib('octlib', 'moveScanner', octStatus.Device, octStatus.Probe, HScanAxis, CenterY);
                end
                

                    disp('setting up measurement')
               if patternType == 1
                   
                   
                xtrack = getappdata(0,'xtrack');
                ytrack = getappdata(0,'ytrack');
                tnumber = getappdata(0,'tnumber');
%                 outvec = [zeros(1, SyncShutterGateSession.Rate/ClkRate*gateDelay), ones(1,SyncShutterGateSession.Rate/ClkRate*tnumber*11000), 0]';  
                  
                for track_number = 1 : tnumber
                    X_track = xtrack(track_number);
                    Y_track = ytrack(track_number);
                    track_number
                calllib('octlib', 'moveScanner', octStatus.Device, octStatus.Probe, ScanAxis, X_track);
                calllib('octlib', 'moveScanner', octStatus.Device, octStatus.Probe, HScanAxis, Y_track);
                 queueOutputData(SyncShutterGateSession,outvec);
                 startForeground(SyncShutterGateSession);
                 queueOutputData(SyncShutterGateSession,outvec);
                startForeground(SyncShutterGateSession);
                % add spectrumetor
                count = 0;
%                 fraction = getappdata(0,'FractionValue');
                SetLsrTransWP_00(handles.wvplt, 0.1);
                fraction = 0.1;
                figure
                while 1
                    count = count + 1;
                [x,max_intensity]=call_spectrumeter([track_number,count],500*1000);
                
                if max_intensity>14000
                  fraction = fraction*0.25
                  SetLsrTransWP_00(handles.wvplt, fraction); 
                elseif max_intensity<5000
                  fraction = fraction*3
                   
                  if fraction >= 1
                      break
                  end
                  SetLsrTransWP_00(handles.wvplt, fraction);
                else
                    break
                end
                
                if count>=2
                break
                end                
%                   pause(30)
                end
%                 calllib('octlib', 'moveScanner', octStatus.Device, octStatus.Probe, ScanAxis, 0);
%                 calllib('octlib', 'moveScanner', octStatus.Device, octStatus.Probe, HScanAxis, 0);
%                  queueOutputData(SyncShutterGateSession,outvec);
%                  startForeground(SyncShutterGateSession);
%                  queueOutputData(SyncShutterGateSession,outvec);
%                 startForeground(SyncShutterGateSession);
%                 pause(3)
                end
               queueOutputData(SyncShutterGateSession,outvec);
               startForeground(SyncShutterGateSession); 
               else
               calllib('octlib', 'startMeasurement', octStatus.Device, Pattern, 'Acquisition_AsyncFinite')%Finite

               queueOutputData(SyncShutterGateSession,outvec);
               startForeground(SyncShutterGateSession);   
                    
%                     wait for done signal
%                     
%                     stop measurement
               calllib('octlib', 'stopMeasurement', octStatus.Device);
               end
            end
                
        
        pause(5)
        
            
        %% delete session    
%         release(SyncShutterGateSession);
%         delete(SyncShutterGateSession);
        
        
        disp('returning scanners to start position');
        calllib('octlib', 'moveScanner', octStatus.Device, octStatus.Probe, ScanAxis, 0);
        calllib('octlib', 'moveScanner', octStatus.Device, octStatus.Probe, HScanAxis, 0);
%         queueOutputData(SyncShutterGateSession,outvec);
%         startForeground(SyncShutterGateSession); 
        release(SyncShutterGateSession);
        delete(SyncShutterGateSession);
        %% reset clock select to OCT
        ClockSelect(0);
        
    end
   
    
end