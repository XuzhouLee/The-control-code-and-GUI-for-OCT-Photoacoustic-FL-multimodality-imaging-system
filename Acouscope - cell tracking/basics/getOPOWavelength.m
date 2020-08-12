function [OPOStatus, eksplaerror] = getOPOWavelength(handles)

OPOStatus = getappdata(0, 'OPOStatus');

wavelength = libpointer('doublePtr',0); %Pointer to double, needed by rcRegAsDouble (check h-file from Ekspla library)
timestmp = libpointer('int32Ptr', 0);


[connectstatus, eksplaerror] = connectEkspla(handles);
OPOStatus.Connection = connectstatus;

pause(.1)

if connectstatus == 1 
    % from ekspla example under C:\Instruments\Ekspla\Control panel
    % application\src example function to set wavelength
    err = calllib('ekslib', 'rcGetRegAsDouble', 'MaxiOPG:39', 'WaveLength', wavelength, 5, timestmp);
    OPOStatus.Wavelength = wavelength.Value;
    if isfield(handles, 'indicator')
        set(handles.indicator.LaserWavelength, 'String', [num2str(OPOStatus.Wavelength), ' nm'],...
        'Backgroundcolor', Wavelength_to_RGB(OPOStatus.Wavelength));
    end
else
    disp('Cannot get wavelength. Laser not connected.')
end

setappdata(0, 'OPOStatus', OPOStatus);

if nargout > 1
    eksplaerror = err;
end

    
    