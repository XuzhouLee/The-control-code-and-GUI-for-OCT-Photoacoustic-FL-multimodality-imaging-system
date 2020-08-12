function ClockSelect(clockSource)
% function to switch the clock from the 36kHz OCT clock to the 1kHz laser
% clock.
% clockSource = 0 for OCT and = 1 for Laser

%% session for clock select - not synched
ClkSelectSession = daq.createSession('ni');
addDigitalChannel(ClkSelectSession, 'Dev3',  'Port0/Line2', 'OutputOnly'); %to switch between OCT frame grabber 36kHz clock (0) and laser 1kHz clock (1)
outputSingleScan(ClkSelectSession, clockSource); % set high for laser clock select
release(ClkSelectSession);
delete(ClkSelectSession);