function res = armSignaTrig(phBrd)

PX4TRIGSRC_INT_CH1 = 0;
PX4TRIGSRC_INT_CH3 = 2;
PX4TRIGSRC_EXT = 4;


%TODO: SetActiveMemoryRegionPX4

% Set trigger source:
try
    %res = calllib('signalib', 'SetTriggerSourcePX4', phBrd, PX4TRIGSRC_INT_CH1); %triggering on CH1
    res = calllib('signalib', 'SetTriggerSourcePX4', phBrd, PX4TRIGSRC_EXT); %triggering on EXT
catch
    disp('Could not SetTriggerSourcePX4. Exiting.');
    return
end


% % set A trigger lev
% try
%     SetTriggerLevelAPX4res = calllib('signalib', 'SetTriggerLevelAPX4', phBrd, getappdata(0, 'AtrigLevel'))
% catch
%     disp('Could not SetTriggerLevelAPX4. Exiting.');
%     return
% end
% % disbale B Trig
% try
%     SetTriggerLevelBPX4res = calllib('signalib', 'SetTriggerLevelBPX4', phBrd, 0)
% catch
%     disp('Could not SetTriggerLevelAPX4. Exiting.');
%     return
% end
% 
% try
%     res2 = calllib('signalib', 'SetTriggerDirectionExtPX4', phBrd, 1); %0: for POS, 1: for NEG
% catch
%     disp('Could not SetTriggerDirectionExtPX4. Exiting.');
%     return
% end

% Set trigger mode to segmented
try
    SetTriggerModePX4res = calllib('signalib', 'SetTriggerModePX4', phBrd, 1); %0: Single Acq; 1: Segmented
catch
    disp('Could not SetTriggerModePX4. Exiting.');
    return
end

% set pretrigger sample to capture leading edge of pulse
try
    SetPreTriggerSamplesPX4res = calllib('signalib', 'SetPreTriggerSamplesPX4', phBrd, getappdata(0,'ActivChNum')*getappdata(0,'PreTrigSampl'));
catch
    disp('Could not SetPreTriggerSamplesPX4. Exiting.');
    return
end

end