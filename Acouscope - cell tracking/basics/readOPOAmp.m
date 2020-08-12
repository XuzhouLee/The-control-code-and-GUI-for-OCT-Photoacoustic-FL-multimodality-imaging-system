function OPOStatus = readOPOAmp(handles)
% function to read the status of the OPO amp


OPOStatus = getappdata(0, 'OPOStatus');

% STATUS can be ON or OFF
timestmp = libpointer('int32Ptr', 0);
value = libpointer('cstring','OFF');

%OPOStatus.AmpON = 0;

if OPOStatus.Connection == 1
    %rcSetRegFromString("M_CPU800:17", "Power",  "ON"); Check in:
    % C:\Instruments\Ekspla\Control panel application\src
    [err, dev, reg, STATUS, dc]  = calllib('ekslib', 'rcGetRegAsString', 'M_CPU800:17', 'Power', value, 3, 4, timestmp); 
    if err ==0
        disp('Amp status read successfully');
        switch STATUS
            case 'ON'
                OPOStatus.AmpON = 1;
            case 'OFF'
                OPOStatus.AmpON = 0;
        end
    else
        errordlg('Could not read laser amp status');
    end
else
    disp('Laser not connected. Cannot read amplifier status.')
end

setappdata(0, 'OPOStatus', OPOStatus);

if isfield(handles, 'indicator')
    switch OPOStatus.AmpON
        case 1
            set(handles.indicator.LaserStatus, 'String', 'ON');
            set(handles.indicator.LaserStatus, 'Backgroundcolor', [.9, .1, .1]);
        case 0
            set(handles.indicator.LaserStatus, 'String', 'OFF');
            set(handles.indicator.LaserStatus, 'Backgroundcolor', [.4, .4, .4]);
    end
end