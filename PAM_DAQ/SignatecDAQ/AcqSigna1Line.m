function AcqSigna1Line(phBrd, params)

ACQUISITION_TIMEOUT = 10000;
ACQUISITION_SYNC = 0;

RAMChunk = getappdata(0, 'RAMChunk');
ActivChNum = getappdata(0, 'ActivChNum');
AcqLengthPoint = getappdata(0, 'AcqLengthPoint');
SamplingRateMHz = getappdata(0, 'SamplingRateMHz');
PixNum = params(1)+params(3); %number of triggers per line = number per pixels per line + flyback triggers


try 
%     disp('Acquiring to board RAM')
    AcquireToBoardRamPX4res = calllib('signalib', 'AcquireToBoardRamPX4', phBrd, 0,...
                getappdata(0, 'actMemSize'),... %RAMChunk * ceil(ActivChNum * AcqLengthMicroSec * SamplingRateMHz * PixNum / RAMChunk),...
                ACQUISITION_TIMEOUT, ACQUISITION_SYNC);
            
    if AcquireToBoardRamPX4res ~= 0
        disp(['Acquisition returned with error ', num2str(res)]);
    end
catch
    disp('Could not AcquireToBoardRamPX4')
    return
end