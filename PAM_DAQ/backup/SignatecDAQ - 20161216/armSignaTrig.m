function res = armSignaTrig(phBrd)

PX4TRIGSRC_INT_CH1 = 0;
PX4TRIGSRC_INT_CH2 = 1;
PX4TRIGSRC_INT_CH3 = 2;
PX4TRIGSRC_INT_CH4 = 3;
PX4TRIGSRC_EXT = 4;


%TODO: SetActiveMemoryRegionPX4

%% this section is to set up the acquisition parameters

try
    res = calllib('signalib', 'SetActiveChannelsPX4', phBrd, getappdata(0, 'Channeloption'));
catch
    disp('Could not SetActiveChannelsPX4. Exiting.');
    return
end

%% set DC offset for CH1 and CH3
setDCOffset(phBrd, 1, getappdata(0, 'OffsetCH1')); %% setting offset for CH1
setDCOffset(phBrd, 2, getappdata(0, 'OffsetCH2')); %% setting offset for CH2
setDCOffset(phBrd, 3, getappdata(0, 'OffsetCH3')); %% setting offset for CH3
setDCOffset(phBrd, 4, getappdata(0, 'OffsetCH4')); %% setting offset for CH4


%% update the internal clock rate
try
    res = calllib('signalib', 'SetInternalAdcClockRatePX4', phBrd, getappdata(0,'SamplingRateMHz'));

catch
    disp('Could not SetInternalAdcClockRatePX4. Exiting.');
    return
end


% Set trigger source:
try
    %res = calllib('signalib', 'SetTriggerSourcePX4', phBrd, PX4TRIGSRC_INT_CH1); %triggering on CH1
    res = calllib('signalib', 'SetTriggerSourcePX4', phBrd, PX4TRIGSRC_EXT); %triggering on EXT
catch
    disp('Could not SetTriggerSourcePX4. Exiting.');
    return
end


% Set trigger mode to segmented
try
    SetTriggerModePX4res = calllib('signalib', 'SetTriggerModePX4', phBrd, 1); %0: Single Acq; 1: Segmented
catch
    disp('Could not SetTriggerModePX4. Exiting.');
    return
end

% set pretrigger sample to capture leading edge of pulse
trigDelay = getappdata(0,'PreTrigSampl');
% trigDelay in samples
trigDelaySampl = trigDelay*getappdata(0, 'SamplingRateMHz');
% Convert to multiple of 16, per DAQ board requirements
trigDelaySamplMult16 = floor(trigDelaySampl/16)*16;


if trigDelaySamplMult16 < 0 
    
    % pretrig
    try
        SetTriggerDelaySamplesPX4res = calllib('signalib', 'SetTriggerDelaySamplesPX4', phBrd, 0);
        SetPreTriggerSamplesPX4res = calllib('signalib', 'SetPreTriggerSamplesPX4', phBrd, abs(trigDelaySamplMult16));
        disp('Armed with pretrig.');
    catch
        disp('Could not SetPreTriggerSamplesPX4. Exiting.');
        return
    end
    
elseif trigDelaySamplMult16 >= 0
    try
        SetPreTriggerSamplesPX4res = calllib('signalib', 'SetPreTriggerSamplesPX4', phBrd, 0);
        SetTriggerDelaySamplesPX4res = calllib('signalib', 'SetTriggerDelaySamplesPX4', phBrd, trigDelaySamplMult16);
        disp('Armed with trigger delay.');
    catch
        disp('Could not SetPreTriggerSamplesPX4. Exiting.');
        return
    end
end