function SetLsrTransWP_00(wvplt, E_Frac)

%% sets the waveplate for a desired laser energy frac
% wvplt is a field of handles i.e., handles.wvplt
% simply implementing the law of transmission through waveplate depending
% on polarization angle: T_out /T_in = sin^2(2*theta), where Theta is the
% angle between laser polarization and waveplate axis

%% Waveplate angles for Laser Transmission Max and Min

LsrIMax =  getappdata(0, 'WvPltMaxTransAngle');
LsrIMin =  getappdata(0, 'WvPltMinTransAngle');

FracAngle = LsrIMin - asin(sqrt(E_Frac))/2*180/pi; %angle in deg from T = sin^2(2 theta)

% move to angle corresponding to desired energy fracion
TDC001MoveAbsolute_00(wvplt, FracAngle);