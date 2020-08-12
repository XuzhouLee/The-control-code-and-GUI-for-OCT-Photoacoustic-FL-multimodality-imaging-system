%% script to write all metadat for acquisition 

%% image geometry
acq = [];

acq.ColNum = params(1);
acq.RowNum = params(2);
acq.FlyBk = params(3);
acq.patternType = params(4);
acq.Avrg = params(5);
acq.scanType = params(18);

acq.WRange = params(6)/1000;
acq.HRange = params(7)/1000;


if getappdata(0, 'ScanType') == 1
    
    acq.PosXa = params(19)/100+params(20)/10000-4.3;
    acq.PosYa = params(21)/100+params(22)/10000-5;
    acq.PosXb = params(23)/100+params(24)/10000-4.3;
    acq.PosYb = params(25)/100+params(26)/10000-5;
    
end

%% Signatec config
acq.PreTrigSampl = getappdata(0, 'PreTrigSampl'); %number of pretrigger samples per channel to capture. Multiple of 16; Set to 0 for delay mode
acq.PostTrigDelaySampl = getappdata(0, 'PostTrigDelaySampl'); %number of post trigger delay clock cycles. Multiple to 16. Set to 0 for pre trig samples
acq.AtrigLevel = getappdata(0, 'AtrigLevel');
acq.SamplingRateMHz = getappdata(0, 'SamplingRateMHz'); %sampling rate in MHz (here 1GHz)
acq.AcqLengthPoint = getappdata(0, 'AcqLengthPoint'); % length of acquisition. Here 2 microsecond per trigger
acq.ActivChNum = getappdata(0, 'ActivChNum'); % 2 active channels

acq.datadir = getappdata(0, 'datadir');
acq.ImgName = ImgName;


save([getappdata(0, 'datadir'), '\', ImgName, '\metadata.mat' ], 'acq'); 
