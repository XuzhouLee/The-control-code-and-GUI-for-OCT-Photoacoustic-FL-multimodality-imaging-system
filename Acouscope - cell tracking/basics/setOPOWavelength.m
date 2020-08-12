function [OPOStatus, eksplaerror] = setOPOWavelength(handles, wavelength)
% function to change the wavelength of OPO and display an error if the OPO
% controller did not change the wavelength


OPOStatus = getappdata(0, 'OPOStatus');

% connect
[connectstatus, eksplaerror] = connectEkspla(handles);

if connectstatus == 1 
    % Issue command to change wavelength. From example in
    % C:\Instruments\Ekspla\Control panel application\src
    err = calllib('ekslib', 'rcSetRegFromDouble', 'MaxiOPG:39', 'WaveLength', wavelength);
    
    % read current wavelength from controller to check if wavelength has been changed
    OPOStatus = getOPOWavelength(handles);
    newwavelength = OPOStatus.Wavelength;

    % check if set wavelength is within 0.1nm of desired wavelength
    if abs(newwavelength - wavelength) < 0.1
        disp(['Wavelength changed to: ', num2str(newwavelength)])
    else
        errordlg('Error. Wavelength was not changed.');
    end
else
    disp('Laser not connected. Cannot set wavelength')
end

setappdata(0, 'OPOStatus', OPOStatus);

if nargout > 1
    eksplaerror = err;
end
