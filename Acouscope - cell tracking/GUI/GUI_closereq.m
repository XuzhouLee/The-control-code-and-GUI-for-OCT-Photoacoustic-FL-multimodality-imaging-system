function GUI_closereq(src,evnt, handles)
% User-defined close request function 

% de-highlight the Modules buttons in Main Fig
uu = ['handles.', get(gcf, 'Tag')];
set(eval(uu), 'Value', 0);

% deleting the figure handle
varname = ['tab', get(gcf, 'Tag'), 'Hdl'];
setappdata(0, varname, []);

%delete figure handle
delete(gcf);

octStatus = getappdata(0, 'octStatus');

% Switch SLD OFF if ON
if calllib('octlib', 'isSLDAvailable', octStatus.Device) == 1
    calllib('octlib', 'setSLD', octStatus.Device, false);
    set(handles.indicator.OCTStatus, 'String', 'SLD ON', 'Backgroundcolor', [.5, .5, .5]);
end

end