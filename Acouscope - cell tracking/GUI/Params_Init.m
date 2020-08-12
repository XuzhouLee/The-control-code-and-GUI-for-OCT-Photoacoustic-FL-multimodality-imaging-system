%% default scan parameters:
setappdata(0, 'ScanAngle', 0); %default scan angle is 0
setappdata(0, 'ScanRange', 2); %default scan range is 1
setappdata(0, 'ScanPoints', 128); %default scan resolution is 256 points
setappdata(0, 'HScanRange', 2); %default scan range is 1
setappdata(0, 'ScanRows', 1); %default scan resolution is 256 points
setappdata(0, 'minTotalPixCnt', 200); %Min number of pixel in image (WxH)that is needs to be acquired for the buffer not to be partially empty. 
setappdata(0, 'patternType', 2); %default to b-scan mode (scan one line then write file to drive)
setappdata(0, 'ScanType', 0); %default to center scan
setappdata(0, 'ContinuousScan', 0); % default for non-continuous scans
setappdata(0, 'ringLightIntensity', 0); % default illumination using right light.

setappdata(0, 'PositionXa', 0); %set x axis position of free position scan
setappdata(0, 'PositionXa', 0); %set x axis position of free position scan
setappdata(0, 'PositionYb', 0); %set Y axis position of free position scan
setappdata(0, 'PositionYb', 0); %set Y axis position of free position scan

setappdata(0, 'centerX', 0); %default scan center is 0
setappdata(0, 'centerY', 0); %default scan center is 0

%% waveplate
MinAngle = 256;  % this is the angle for minimum transmission through the waveplate. It is determined by running Calibrate Energy in LaserOPO Menu
setappdata(0, 'MinAngle', MinAngle);
setappdata(0, 'WvPltMaxTransAngle', MinAngle-45); % Max angle = 45 degrees off of Min Angle
setappdata(0, 'WvPltMinTransAngle', MinAngle);
setappdata(0, 'StartEnrgFraction', 0.005); % default start value for energy

%% Acquisition variables
setappdata(0, 'PreTrigSampl', 5.5); %trigger delay in usec
setappdata(0, 'ImgNameRoot', 'PAM_Rabbit');
setappdata(0, 'AtrigLevel', 160);
setappdata(0, 'SamplingRateMHz', 200); %sampling rate in MHz (here 1GHz)
setappdata(0, 'AcqLengthPoint', 1024); % length of acquisition. Here 2 microsecond per trigger
setappdata(0, 'ActivChNum', 1); % 2 active channels
setappdata(0, 'OffsetCH1', 200); % DC offset for CH1
setappdata(0, 'OffsetCH2', 1680); % DC offset for CH2
setappdata(0, 'OffsetCH3', 1680); % DC offset for CH3
setappdata(0, 'OffsetCH4', 1680); % DC offset for CH4
setappdata(0, 'Channeloption', 7); % Channel Options: select "3" for channels 1-3; select "0" for QUAD