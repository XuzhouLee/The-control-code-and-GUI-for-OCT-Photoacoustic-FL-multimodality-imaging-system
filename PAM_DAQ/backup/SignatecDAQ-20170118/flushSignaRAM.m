function flushSignaRAM(phBrd, params)




RAMChunk = getappdata(0, 'RAMChunk');
ActivChNum = getappdata(0, 'ActivChNum');
AcqLengthMicroSec = getappdata(0, 'AcqLengthMicroSec');
SamplingRateMHz = getappdata(0, 'SamplingRateMHz');
PixNum = params(1)+params(3); %number of triggers per line = number per pixels per line + flyback triggers
RowNum = params(2);


ACQUISITION_TIMEOUT = PixNum * RowNum* 1.25;

TrigNum = getappdata(0, 'actMemSize');

armSignaTrig(phBrd);

disp('Flushing board RAM')

AcquireToBoardRamPX4res = calllib('signalib', 'AcquireToBoardRamPX4', phBrd, 0, TrigNum, ACQUISITION_TIMEOUT, 1);
calllib('signalib', 'IssueSoftwareTriggerPX4', phBrd); 

disp('RAM flushed! ready for next acquisition')


