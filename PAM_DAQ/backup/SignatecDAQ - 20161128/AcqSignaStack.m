function AcqSignaStack(phBrd, params)




RAMChunk = getappdata(0, 'RAMChunk');
ActivChNum = getappdata(0, 'ActivChNum');
AcqLengthMicroSec = getappdata(0, 'AcqLengthMicroSec');
SamplingRateMHz = getappdata(0, 'SamplingRateMHz');
PixNum = params(1)+params(3); %number of triggers per line = number per pixels per line + flyback triggers
RowNum = params(2);

ACQUISITION_SYNC = 0;
ACQUISITION_TIMEOUT = PixNum * RowNum* 1.25;

TrigNum = getappdata(0, 'actMemSize');

try 
    disp('Acquiring to board RAM')
    AcquireToBoardRamPX4res = calllib('signalib', 'AcquireToBoardRamPX4', phBrd, 0,...
                TrigNum, ACQUISITION_TIMEOUT, ACQUISITION_SYNC)
            
    if AcquireToBoardRamPX4res ~= 0
        disp(['Acquisition returned with error ', num2str(res)]);
    end
catch
    disp('Could not AcquireToBoardRamPX4')
    return
end