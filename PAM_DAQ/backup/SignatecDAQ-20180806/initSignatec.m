function phBrd = initSignatec()


%% Signatec object handle type definition (from C lib)
phBrd = libpointer('s_px4hs_Ptr');
serial = libpointer('uint32Ptr', 0);
try
    [err, phBrdPtr] = calllib('signalib', 'ConnectToDevicePX4', phBrd, 1);
catch
    disp('Could not connect to device. Exiting.');
    return
end

disp('Initializing PX1500 hardware...');

try
    err = calllib('signalib', 'GetSerialNumberPX4', phBrd, serial);
catch
    disp('Could not fetch serial number. Exiting.');
    return
end

disp(['Connected to PX4 device with serial #: ', num2str(serial.Value)]);


try
    res = calllib('signalib', 'SetPowerupDefaultsPX4', phBrd);
catch
    disp('Could not SetPowerupDefaultsPX4. Exiting.');
    return
end

%% this section is to set up the acquisition parameters
% set active channels dual 1_3 or quad 1_2_3_4 (1 for laser pulse)
try
    res = calllib('signalib', 'SetActiveChannelsPX4', phBrd, getappdata(0, 'Channeloption'));
catch
    disp('Could not SetActiveChannelsPX4. Exiting.');
    return
end

%% set DC offset for CH1, CH2, CH3, CH4
setDCOffset(phBrd, 1, getappdata(0, 'OffsetCH1')); %% setting offset for CH1
setDCOffset(phBrd, 2, getappdata(0, 'OffsetCH2')); %% setting offset for CH2
setDCOffset(phBrd, 3, getappdata(0, 'OffsetCH3')); %% setting offset for CH3
setDCOffset(phBrd, 4, getappdata(0, 'OffsetCH4')); %% setting offset for CH4
    


% sed ADC clock source and rate
try
    res = calllib('signalib', 'SetAdcClockSourcePX4', phBrd, 0); %0: for internal 1.5GHz clock; 1: for EXT.
catch
    disp('Could notSetAdcClockSourcePX4. Exiting.');
    return
end



try
    res = calllib('signalib', 'SetInternalAdcClockRatePX4', phBrd, getappdata(0,'SamplingRateMHz'));

catch
    disp('Could not SetInternalAdcClockRatePX4. Exiting.');
    return
end


end
