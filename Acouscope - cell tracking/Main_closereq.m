function Main_closereq(src,evnt, handles)


OPOStatus = getappdata(0, 'OPOStatus');
octStatus = getappdata(0, 'octStatus');

disp('Program is shutting down ...');
%% close NI DAQ
if isfield(handles, 'daqSessionWrite')
    closeLaserShutter(handles, OPOStatus);
    clear handles.daqSessionWrite handles.daqSessionRead;
end



%% unloading OCT libraries
if libisloaded('octlib')
    octStatus = getappdata(0, 'octStatus');
    
    if ~isempty(octStatus.Probe)
        disp('Closing probe ...')
        calllib('octlib', 'closeProbe', octStatus.Probe);
    end
    if ~isempty(octStatus.Device)
        disp('Closing device ...')
        calllib('octlib', 'closeDevice', octStatus.Device);
    end
    clear octStatus.Device octStatus.Probe
end

%% close serial port for APT waveplate
fclose(handles.wvplt)
delete(handles.wvplt)
clear handles.wvplt

close all force
%delete(instrfindall) % delete the arduino object
end
