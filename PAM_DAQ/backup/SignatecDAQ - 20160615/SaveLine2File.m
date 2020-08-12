function SaveLine2File(handles, params, ImgName, i)


RAMChunk = getappdata(0, 'RAMChunk');
ActivChNum = getappdata(0, 'ActivChNum');
AcqLengthMicroSec = getappdata(0, 'AcqLengthMicroSec');
SamplingRateMHz = getappdata(0, 'SamplingRateMHz');

PixNum = params(1)+params(3); %number of triggers per line = number per pixels per line + flyback triggers

fwp = libpointer('s_PX4S_FILE_WRITE_PARAMS_tagPtr');

temp1 = fwp.Value;
temp2 = whos('temp1');
struct_size_bytes = temp2.bytes;

fwp.Value.struct_size = struct_size_bytes;

%destination file pathname
fwp.Value.pathname = [getappdata(0, 'datadir'), '\', ImgName, '\', ImgName, '_Row', num2str(i, '%04d'), '.rd8'];
        
disp('Saving acquisition data to file...\n');


ReadSampleRamFileBufPX4res = calllib('signalib', 'ReadSampleRamFileBufPX4', handles.phBrd, 0,...
    RAMChunk * ceil(ActivChNum * AcqLengthMicroSec * SamplingRateMHz * PixNum / RAMChunk), fwp.Value)
