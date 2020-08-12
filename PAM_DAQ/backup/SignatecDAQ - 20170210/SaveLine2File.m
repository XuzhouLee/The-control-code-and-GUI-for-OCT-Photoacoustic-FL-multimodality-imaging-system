function SaveLine2File(handles, params, ImgName, i)


RAMChunk = getappdata(0, 'RAMChunk');
ActivChNum = getappdata(0, 'ActivChNum');
AcqLengthPoint = getappdata(0, 'AcqLengthPoint');
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
    RAMChunk * ceil(ActivChNum * AcqLengthPoint * PixNum / RAMChunk), fwp.Value)


%OpenSrdcFilePX4 (HPX4 hBrd, HPX4SRDC* handlep, const TCHAR* pathnamep, unsigned flags)

handlep = libpointer('s_px4srdchs_PtrPtr');
srdcflnm = libpointer('cstring', [getappdata(0, 'datadir'), '\', ImgName, '\', ImgName, '_Row', num2str(i, '%04d'), '.srdc']);
OpenSrdcFilePX4_Res = calllib('signalib', 'OpenSrdcFileAPX4', handles.phBrd, handlep, srdcflnm, uint32(1)); 
