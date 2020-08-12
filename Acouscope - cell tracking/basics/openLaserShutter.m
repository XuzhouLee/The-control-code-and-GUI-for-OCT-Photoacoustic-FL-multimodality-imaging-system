function OPOStatus  = openLaserShutter(handles)

% this is to control the external shutter using NI USB-6353
% shutter drive is at Port0 Line 1

OPOStatus = getappdata(0, 'OPOStatus');

if isfield(handles, 'daqSessionMstrTrig')
    outputSingleScan(handles.daqSessionMstrTrig, [1,0]);  %Line 0 is shutter drive, Line 1 is not used
    
    OPOStatus = getShutterStatus(handles);
    
    if OPOStatus.Shutter == 1
        set(handles.hShtrBtn, 'String', 'Click to Close', 'Background', [1,0,0], 'Fontweight', 'bold');
        return
    else
        % check if shutter opened
        errordlg('Error! Shutter did not open!');
        outputSingleScan(handles.daqSessionMstrTrig, [0,0]);
        set(handles.hShtrBtn, 'Value', 0);
    end
else
    OPOStatus.Shutter=0;
end

setappdata(0, 'OPOStatus', OPOStatus);