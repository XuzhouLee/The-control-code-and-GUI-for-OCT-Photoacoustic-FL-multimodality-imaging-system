function Main_closereq(source, event, handles)

%% disconnect from Signatec board
% 	DisconnectFromDevicePX4(hBrd);
handles.tcpipClient = getappdata(0, 'tcpipClient');

disp('closing down');

%% closing tcpipconnection
if (isfield(handles.tcpipClient, 'Status') & handles.tcpipClient.Status == 'open') 
    disp('closing connection...')
    fclose(handles.tcpipClient)
end

%% break the loop
setappdata(0, 'isRunning', 0);


close all force