function [OPOStatus, error] = getShutterStatus(handles)

OPOStatus = getappdata(0, 'OPOStatus');

try
    %digital input from shutter controller PULSE OUTPUT.
    %This output is connected to a sensor that checks the shutter status
    %regarless of the PULSE INPUT signal.
    % this is to protect against faulty shutter, or when the shutter
    % controller is set to manual and cannot be operated from the computer
    % Digital inout 0 is shutter sensor detects close; 1 is for shutter sensor detecting shutter open; 
    status = inputSingleScan(handles.daqSessionRead); 
    err = 0;
catch
    disp('could not read status. Check is NI card is connected');
    status = 0;
    err = -1;
end

OPOStatus.Shutter = status; % update status

if isfield(handles, 'indicator')
    if OPOStatus.Shutter % check shutter status
        set(handles.indicator.ShutterStatus, 'String', 'Shutter ON', 'Backgroundcolor', [.1, 1, .1]);
    else
        set(handles.indicator.ShutterStatus, 'String', 'Shutter OFF', 'Backgroundcolor', [.9, .1, .1]);
    end
end

setappdata(0, 'OPOStatus', OPOStatus);

if nargout > 1
    error =err;
end

