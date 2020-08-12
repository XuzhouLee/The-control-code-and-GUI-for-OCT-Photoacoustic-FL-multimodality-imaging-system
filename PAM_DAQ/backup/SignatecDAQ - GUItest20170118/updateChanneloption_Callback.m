%setting channel option; 
% channeloptionnum equal to 1 means dual channel 1_3; channeloptionnum equal to 2 means quad channel 1_2_3_4
function updateChanneloption_Callback(src, event, handles)
    channeloptionnum = get(src, 'value');
    
    samplingRate = getappdata(0,'SamplingRateMHz');
    
    if (channeloptionnum == 2 && samplingRate > 500) %make sure that DAQ card will not be out of memory
        errordlg('Sampling rate is too high for this channel count. Update sampling rate first. Quad mode has max sampling rate = 500MHz.');
        set(src, 'value', 1);
    end
    
    if channeloptionnum == 1
        setappdata(0, 'ActivChNum', 2);
        setappdata(0, 'Channeloption',3);
    else
        setappdata(0, 'ActivChNum', 4);
        setappdata(0, 'Channeloption',0);
    end

end