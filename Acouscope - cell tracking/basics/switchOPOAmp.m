function [OPOStatus, eksplaerror] = switchOPOAmp(handles, STATUS)
% STATUS can be ON or OFF

OPOStatus = getappdata(0, 'OPOStatus');



if OPOStatus.Connection == 1
    %rcSetRegFromString("M_CPU800:17", "Power",  "ON"); from example in C:\Instruments\Ekspla\Control panel application
    err = calllib('ekslib', 'rcSetRegFromString', 'M_CPU800:17', 'Power', STATUS); 
    if err ==0
        disp(['laser amps switched ', STATUS])
        switch STATUS
            case 'ON'
                OPOStatus.AmpON = 1;
            case 'OFF'
                OPOStatus.AmpON = 0;
        end
    else
        errordlg(['Could not switch laser amp ', STATUS]);
    end
else
    disp('Laser not connected. Cannot switch amplifier')
end
 
if isfield(handles.indicator, 'LaserStatus')
    switch OPOStatus.AmpON
        case 1
            set(handles.indicator.LaserStatus, 'String', 'Laser is ON');
            set(handles.indicator.LaserStatus, 'Backgroundcolor', [.9, .1, .1]);
        case 0
            set(handles.indicator.LaserStatus, 'String', 'Laser is OFF');
            set(handles.indicator.LaserStatus, 'Backgroundcolor', [.4, .4, .4]);
    end
end

setappdata(0, 'OPOStatus', OPOStatus);

if nargout > 1
    eksplaerror = err;
end

            





