function [connectstatus, eksplaerror] = connectEkspla(handles)

OPOStatus = getappdata(0, 'OPOStatus');

disp('Connecting to Ekspla laser ...');
try
    error = calllib('ekslib', 'rcConnect', 0, 0);
catch
    disp('Could not connect to the laser')
    error = -1;
    connectstatus = 0;
end


% error list is in C:\Instruments\Ekspla\Control panel
% application\src\REMOTECONTROL.H
if error == 0
    disp('Connection to Ekspla laser successful.')
    connectstatus = 1;
elseif error == 17 
    disp('Laser is already connected');
    connectstatus = 1;
else
    % continue or abort?
    dlgprmt = ['Could not connect to laser. Error: ', num2str(error), '. Would you like to abort and try again or continue with no laser controls?'];
    option = questdlg(dlgprmt, ...
                        'Laser connection error', ...
                        'Continue (no laser)','Abort','Continue (no laser)');
    % Handle response
    switch option
        case 'Continue (no laser)'
            connectstatus = 0;
            disp('Continuing without laser controls ...')
        case 'Abort'
            Main_closereq(0,0, handles)
            return
    end
end

setappdata(0, 'OPOStatus', OPOStatus);

if nargout > 1
    eksplaerror = error;
end

