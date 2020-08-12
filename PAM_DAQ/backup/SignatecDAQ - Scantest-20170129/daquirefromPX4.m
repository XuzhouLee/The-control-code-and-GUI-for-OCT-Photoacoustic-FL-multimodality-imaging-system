function daquirefromPX4(handles)

handles.tcpipClient = getappdata(0, 'tcpipClient');

while getappdata(0, 'isRunning') == 1 
    while (handles.tcpipClient.BytesAvailable > 0)
        
        disp('reading')
        try
            params = fread(handles.tcpipClient,getappdata(0,'DataBuffSz')/8,'int16');
            disp('DAQ parameters read');
            % params = [number of pixel to acquire per line, number of rows; number of extra triggers for flyback; patternType; line averaging;...
            %            range along the width direction in microns; range along the height direction in microns]
        catch Ex
            disp('could not fetch data acquisition parameters from host');
            return
        end
        
        %% pattern type: 0 for bscans and iterate over rows; 1 for volume scan for a single file per image
        params
        patternType = params(4)
        UpdateParams(handles,params);
        % update GUI
        updateGUI(handles, params);
        
        tStamp = clock;
        name_suffix = [num2str(tStamp(1)), num2str(tStamp(2), '%02d'), num2str(tStamp(3), '%02d'), '-', num2str(tStamp(4),'%02d'),num2str(tStamp(5),'%02d')];
        ImgName = [getappdata(0, 'ImgNameRoot'), '-', name_suffix]
        
        mkdir(getappdata(0, 'datadir'), ImgName);
        
        
        if patternType == 2
        
            
            % set Signatec parameters
            setAcqMem(handles, params);

            for i=1:params(2) %loop over line number
                
                %% Notify server that acquisition is ready for triggers
                % send the server a flag that params has been received.FLAG: 7 params
                % received and trigger armed
                disp('sending ready signal...')
                fwrite(handles.tcpipClient, 7, 'uint16');
                % arm Signatec trigger
                armSignaTrig(handles.phBrd);
                disp('trigger armed')
                %% setup acquisition sychronously
                disp(['Acquiring line ', num2str(i)]);
                AcqSigna1Line(handles.phBrd, params);
                SaveLine2File(handles, params, ImgName, i);
                
            end
            
        elseif patternType == 3
            
            %% Notify server that acquisition is ready for triggers
            % send the server a flag that params has been received.FLAG: 7 params
            % received and trigger armed
            
            %check if 2GB Signatec onboard memory is sufficient for this acquisition
            MemNeeded = params(2)*(params(1)+params(3))*getappdata(0, 'ActivChNum')*getappdata(0, 'SamplingRateMHz')*getappdata(0, 'AcqLengthMicroSec');
            if MemNeeded > 2e9
                fwrite(handles.tcpipClient, 9, 'uint16');  % FLAG =9 should signal to Server that acquisition is not possible. Should stop aquisition.
            else
            
                disp('sending ready signal...')
                fwrite(handles.tcpipClient, 7, 'uint16');
 
                % set Signatec parameters
                setAcqMemStack(handles, params);
                %% arm Signatec trigger
                armSignaTrig(handles.phBrd);

                %% setup acquisition sychronously
                disp('Acquiring Stack ...');
                AcqSignaStack(handles.phBrd, params);
                SaveStack2File(handles, params, ImgName);
            end
        elseif patternType == 1
           
            setAcqMem(handles, params);

            for i=1:params(2) %loop over line number
                
                %% Notify server that acquisition is ready for triggers
                % send the server a flag that params has been received.FLAG: 7 params
                % received and trigger armed
                disp('sending ready signal...')
                fwrite(handles.tcpipClient, 7, 'uint16');
                % arm Signatec trigger
                armSignaTrig(handles.phBrd);
                disp('trigger armed')
                %% setup acquisition sychronously
                disp(['Acquiring point ', num2str(i)]);
                AcqSigna1Line(handles.phBrd, params);
                SaveLine2File(handles, params, ImgName, i);
                
            end
        end
        %% writing metadata file file (context of acquisition)
        writeMetaData; 
        %% flushing the Signatec memory with random data to prevent mis-interpretation of data when acquisition fails
        flushSignaRAM(handles.phBrd, params);

    end
    
    pause(1);
    
end

end

function updateGUI(handles, params)
    
    %% update connection status
    set(handles.hCnctStatsFld, 'String', 'Connected to host')
    
    %% update image parameters
    set(handles.hHrzPixFld, 'String', num2str(params(1)));
    set(handles.hVertLineFld, 'String', num2str(params(2)));
    set(handles.hFlybkFld, 'String', num2str(params(3)));
    set(handles.hLineAvrgFld, 'String', num2str(params(4)));
    set(handles.hSmplRtFld,'string',getappdata(0, 'SamplingRateMHz'));
    %% update acquisition status
%     set(handles.hAcqStatsFld, 'String', 'Waiting for trigger');

    set(handles.hCh1OffstFld,'string',getappdata(0, 'OffsetCH1'));
    set(handles.hCh2OffstFld,'string',getappdata(0, 'OffsetCH2'));
    set(handles.hCh3OffstFld,'string',getappdata(0, 'OffsetCH3'));
    set(handles.hCh4OffstFld,'string',getappdata(0, 'OffsetCH4'));
    set(handles.hPreTrigFld,'string',getappdata(0, 'PreTrigSampl'));
    set(handles.hTrigLvlFld,'string',getappdata(0, 'AtrigLevel'));
    set(handles.hRcrLenFld,'string',getappdata(0, 'AcqLengthMicroSec'));
    pulldownValue = getappdata(0, 'Channeloption'); %read the channel option from appdata
    % select the pulldown index based on channeloption value
    if pulldownValue == 7
       pulldownValue = 1;
    elseif pulldownValue == 3
       pulldownValue = 2;
    elseif pulldownValue == 0
       pulldownValue = 3;
    end
    set(handles.hChOptFld, 'value',double(pulldownValue));
    
end         