

function [x,max_intensity] = call_spectrumeter(coordinates,exposure_time)
import('com.oceanoptics.omnidriver.api.wrapper.Wrapper');
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
wrapper = Wrapper();
NoOfDevices = wrapper.openAllSpectrometers();

%% Some settings for device 0
wrapper.setIntegrationTime(0,exposure_time); %1000 = 1ms
wrapper.setScansToAverage(0,3);

%% Get a spectrum from device 0 and plot it
wvl = wrapper.getWavelengths(0);
spectrum = wrapper.getSpectrum(0);
max_intensity=max(spectrum)
plot(spectrum)
csvwrite(['[',int2str(coordinates(1)),',',int2str(coordinates(2)),'].csv'],spectrum)

%% Clean up
wrapper.closeAllSpectrometers();
x=1
end

