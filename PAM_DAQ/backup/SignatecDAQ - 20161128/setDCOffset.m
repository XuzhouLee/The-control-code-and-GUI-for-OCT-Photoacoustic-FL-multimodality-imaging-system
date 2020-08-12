function res = setDCOffset(phBrd, CH, offset);

possibleCH = [1,2,3,4];

if (offset <0 | offset > 4095)
    errordlg('Invalid offset setting. Must be an integer between 0 and 4095')
    res = -1000;
    return
end
    

if ~ismember(CH, possibleCH)
    res = -1000;
    errordlg('Invalid Channel. Channel must be an integer between 1 and 4');
    return
end

OffsetFunc = ['SetDcOffsetCh', num2str(CH), 'PX4'];

try
    res = calllib('signalib', OffsetFunc, phBrd, offset);
catch
    errordlg(['Could not set offset for channel ', num2str(CH)])
end
    