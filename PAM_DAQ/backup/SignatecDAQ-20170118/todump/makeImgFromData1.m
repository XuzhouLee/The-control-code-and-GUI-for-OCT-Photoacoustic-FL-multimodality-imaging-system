function makeImgFromData(folder_name)

%% .rd8 reshape
% Method to reshape .rd8 data from data acquisition board into matrix
% representative of the real image

addpath(folder_name);
file_name = strsplit(folder_name, '\');
file_name = char(file_name(end));


directory = folder_name;

%% Read in data from DAQ
load([directory,'\metadata.mat']);
%% Reshape DAQ data
pixelNum = acq.ColNum;
rowNum = acq.RowNum;
flybkPixels = acq.FlyBk;
patternType = acq.patternType;
SamplingRate = acq.SamplingRateMHz*1e6;     % sampling rate in Hz


%% ultrasound filtering
Fc = 1e8;                                   % cut-off frequency in Hz
Fnorm = Fc/(SamplingRate/2);                  % Normalized frequency
% filter design, low pass
df = designfilt('lowpassfir','FilterOrder',70,'CutoffFrequency',Fnorm);
[num, denum] = tf(df);
%  Delay = mean(grpdelay(df));  % group delay (constant) introduced by
%  filter. ignore since not relevant
filterShift = 40; %edge effect due to filtering on the filtered data.

%% de-interlacing
SegmentSampleNum = acq.SamplingRateMHz*acq.AcqLengthMicroSec*acq.ActivChNum;

PDIM = zeros(rowNum, pixelNum);
USIM = zeros(rowNum, pixelNum);

if patternType == 0
    iRows = rowNum;
    usefulData = SegmentSampleNum * (pixelNum+flybkPixels);
    reshapeSize = [SegmentSampleNum, (pixelNum+flybkPixels), 1];
elseif patternType == 1
    iRows = 1;
    usefulData = SegmentSampleNum * (pixelNum+flybkPixels) * rowNum;
    reshapeSize = [SegmentSampleNum, (pixelNum+flybkPixels), rowNum];
    file_name_temp = strcat(file_name, '.rd8');
    file_name_temp = char(file_name_temp);
end

PDIM = [];
USIM = [];

for i=1:iRows
    
    if patternType == 0
        file_name_temp = strcat(file_name,'_Row', num2str(i, '%04u'), '.rd8');
        file_name_temp = char(file_name_temp);
    end
    Info = dir(file_name_temp);
    
    disp('Reading data ...');
    rd8Data = fopen(file_name_temp, 'r');
    fullData = fread(rd8Data, '*uint8'); %[1, Info.bytes], 
    fclose(rd8Data);
        
    %% truncate extra data from memory
    disp('Truncating ...');
    fullData = fullData(1:usefulData);
    
    
    disp('Reshaping data ....');
    %% reshape as a matrix with each interleved row as segment
    Segment = reshape(fullData, reshapeSize);

    %% separate PD and US signals
    disp('Deinterlacing data ...');
    photoDiode = Segment(1:2:end,:,:);
    ultraSound = Segment(2:2:end,:,:);
    
    disp('Filtering ultrasound data ...');
    %ultraSound_f = filter(num, denum, double(ultraSound));
    %ultraSound_f = ultraSound_f(filterShift+1:end,:,:);  %getting rid of the edge effect on the filtered data. Not doing this will mess up the peak-to-peak result
    
    
    PDmax = squeeze(peak2peak(photoDiode, 1));
    USmax = squeeze(peak2peak(ultraSound, 1));
    
    PDIM = [PDIM; PDmax];
    USIM = [USIM; USmax];
end



% USNORM = max(max(PDIM))*USIM./PDIM;

if patternType ==1
    PDIM = PDIM';
    USIM = USIM';
%     USNORM = USNORM';
end


save([directory, '\PDIM_', file_name, '.mat'], 'PDIM');
save([directory, '\USIM_', file_name, '.mat'], 'USIM');


save([directory, '\PDRaw_', file_name, '.mat'], 'photoDiode');
save([directory, '\USRaw_', file_name, '.mat'], 'ultraSound');

imwrite(uint8(PDIM), [directory, '\PD_', file_name, '.png']);
imwrite(uint8(USIM), [directory, '\US_', file_name, '.png']);
% imwrite(uint8(USNORM), [directory, '\USNORM_', file_name, '.png']);



figure(123); imagesc(uint8(PDIM));
figure(124); imagesc(uint8(USIM));

