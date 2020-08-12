function daquirefromPX4Stack(handles)

handles.tcpipClient = getappdata(0, 'tcpipClient');

while getappdata(0, 'isRunning') == 1 
    while (handles.tcpipClient.BytesAvailable > 0)
        
        disp('reading')
        try
            params = fread(handles.tcpipClient,getappdata(0,'DataBuffSz')/8,'int16');
            disp('DAQ parameters read');
            
            % params = [number of pixel to acquire per line, number of rows; number of extra triggers for flyback; line averaging;...
            %            ranhe along the width direction; range along the height direction]
        catch Ex
            disp('could not fetch data acquisition parameters from host');
            return
        end
        
                
        % update GUI
        updateGUI(handles, params);
        
        tStamp = clock;
        name_suffix = [num2str(tStamp(1)), num2str(tStamp(2), '%02d'), num2str(tStamp(3), '%02d'), '-', num2str(tStamp(4),'%02d'),num2str(tStamp(5),'%02d')];
        ImgName = [getappdata(0, 'ImgNameRoot'), '-', name_suffix];
        mkdir(getappdata(0, 'datadir'), ImgName);
        
        % set Signatec parameters
        setAcqMemStack(handles, params);
         
        %% Notify server that acquisition is ready for triggers
        % send the server a flag that params has been received.FLAG: 7 params
        % received and trigger armed
        disp('sending ready signal...')
        fwrite(handles.tcpipClient, 7, 'uint16');

        %% arm Signatec trigger
        armSignaTrig(handles.phBrd);

        %% setup acquisition sychronously
        disp('Acquiring Stack ...');
        AcqSignaStack(handles.phBrd, params);
        SaveStack2File(handles, params, ImgName);
        

        
        %% writing metadata file file (context of acquisition)
        writeMetaData;
        
        
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
    
    %% update acquisition status
    set(handles.hAcqStatsFld, 'String', 'Waiting for trigger');
end         