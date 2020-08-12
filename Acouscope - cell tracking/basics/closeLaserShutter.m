function OPOStatus = closeLaserShutter(handles)

% this is to control the external shutter using NI USB-6001

OPOStatus = getappdata(0, 'OPOStatus');

if isfield(handles, 'daqSessionMstrTrig')
    outputSingleScan(handles.daqSessionMstrTrig, [0,0]); % outputing 2 Digital output, only first one is used. Ignore the second
    OPOStatus = getShutterStatus(handles); % update shutter status
    if OPOStatus.Shutter == 0
        set(handles.hShtrBtn, 'String', 'Open Laser Shutter', 'Background', [.8,0.8,0.8], 'Fontweight', 'normal');
        return
    else
        errordlg('Error! Shutter did not close!');
        set(handles.hShtrBtn, 'Value', 1);
    end
else
    OPOStatus.Shutter=0;
end

setappdata(0, 'OPOStatus', OPOStatus);
