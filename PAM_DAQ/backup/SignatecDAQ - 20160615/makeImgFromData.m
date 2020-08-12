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
    
    rd8Data = fopen(file_name_temp);
    fullData = fread(rd8Data);
    fclose(rd8Data);
    
    %% truncate extra data from memory
    fullData(usefulData+1:end) = [];
    
    %% reshape as a matrix with each interleved row as segment
    Segment = reshape(fullData, reshapeSize);

    %% separate PD and US signals
    photoDiode = Segment(1:2:end,:,:);
    ultraSound = Segment(2:2:end,:,:);
    
    
    PDmax = squeeze(peak2peak(photoDiode, 1));
    USmax = squeeze(peak2peak(ultraSound, 1));
    PDIM = [PDIM; PDmax];
    USIM = [USIM; USmax];
end

USNORM = max(max(PDIM))*USIM./PDIM;

if patternType ==1
    PDIM = PDIM';
    USIM = USIM';
    USNORM = USNORM';
end


save([directory, '\PD_', file_name, '.mat'], 'PDIM');
save([directory, '\US_', file_name, '.mat'], 'USIM');

imwrite(uint8(PDIM), [directory, '\PD_', file_name, '.png']);
imwrite(uint8(USIM), [directory, '\US_', file_name, '.png']);
imwrite(uint8(USNORM), [directory, '\USNORM_', file_name, '.png']);

figure(123); imagesc(uint8(PDIM));
figure(124); imagesc(uint8(USIM));
figure(126); imagesc(uint8(USNORM));


% figure(125); 
% subplot(3,1,1)
% hold on;
% for i=1:2:pixelNum
%     plot(photoDiode(i,:));
% end
% hold off
% 
% subplot(3,1,2)
% plot(PDmax)
% 
% subplot(3,1,3)
% plot(USmax)


