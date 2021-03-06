function setAcqMemStack(handles, params)

% function to set Signatec acquisition memory

phBrd = handles.phBrd;

RAMChunk = getappdata(0, 'RAMChunk');
ActivChNum = getappdata(0, 'ActivChNum');
AcqLengthMicroSec = getappdata(0, 'AcqLengthMicroSec');
SamplingRateMHz = getappdata(0, 'SamplingRateMHz');
PixNum = params(1)+params(3); %number of triggers per line = number per pixels per line + flyback triggers
RowNum = params(2);

disp('setting segment size')
% Set segment size
reqSegSize = ActivChNum * AcqLengthMicroSec * SamplingRateMHz;
res= calllib('signalib', 'SetSegmentSizePX4', phBrd, reqSegSize);
%query segment size
[actSegSize, a] = calllib('signalib', 'GetSegmentSizePX4', phBrd, 1);
%update app data and GUI
setappdata(0, 'AcqLengthMicroSec', actSegSize/ActivChNum/SamplingRateMHz);
%set(handles.hRcrLenFld, 'String', num2str(actSegSize/ActivChNum/SamplingRateMHz, '%3.2f'));


% Set requested memory
reqMemSize = actSegSize * PixNum * RowNum;
res = calllib('signalib', 'SetActiveMemoryRegionPX4', phBrd,reqMemSize, 0);
% query reserved memory
MemSize = libpointer('uint32Ptr', 0);
MemStrt = libpointer('uint32Ptr', 0);
res = calllib('signalib', 'GetActiveMemoryRegionPX4', phBrd, MemSize, MemStrt, 1);
actMemSize = MemSize.Value;
setappdata(0, 'actMemSize', actMemSize); 


