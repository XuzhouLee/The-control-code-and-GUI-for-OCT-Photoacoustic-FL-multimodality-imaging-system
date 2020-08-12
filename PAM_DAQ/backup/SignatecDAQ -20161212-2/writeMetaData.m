%% image geometry
acq.ColNum = params(1);
acq.RowNum = params(2);
acq.FlyBk = params(3);
acq.patternType = params(4);
acq.Avrg = params(5);
acq.WRange = params(6);
acq.HRange = params(7);

%% Signatec config
acq.PreTrigSampl = getappdata(0, 'PreTrigSampl'); %number of pretrigger samples per channel to capture. Multiple of 16; Set to 0 for delay mode
acq.PostTrigDelaySampl = getappdata(0, 'PostTrigDelaySampl'); %number of post trigger delay clock cycles. Multiple to 16. Set to 0 for pre trig samples
acq.AtrigLevel = getappdata(0, 'AtrigLevel');
acq.SamplingRateMHz = getappdata(0, 'SamplingRateMHz'); %sampling rate in MHz (here 1GHz)
acq.AcqLengthMicroSec = getappdata(0, 'AcqLengthMicroSec'); % length of acquisition. Here 2 microsecond per trigger
acq.ActivChNum = getappdata(0, 'ActivChNum'); % 2 active channels

acq.datadir = getappdata(0, 'datadir');
acq.ImgName = ImgName;


save([getappdata(0, 'datadir'), '\', ImgName, '\metadata.mat' ], 'acq'); 
