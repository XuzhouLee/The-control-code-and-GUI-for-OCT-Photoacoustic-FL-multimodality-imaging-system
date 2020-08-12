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
% Fc = 1e8;                                   % cut-off frequency in Hz
% Fnorm = Fc/(SamplingRate/2);                  % Normalized frequency
% % filter design, low pass
% df = designfilt('lowpassfir','FilterOrder',70,'CutoffFrequency',Fnorm);
% [num, denum] = tf(df);
% %  Delay = mean(grpdelay(df));  % group delay (constant) introduced by
% %  filter. ignore since not relevant
% filterShift = 40; %edge effect due to filtering on the filtered data.

%% reshaping 1D raw data into Chanels, rows and columns
SegmentSampleNum = acq.SamplingRateMHz*acq.AcqLengthMicroSec*acq.ActivChNum;

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

CHN1 = [];
CHN3 = [];
CHN2 = [];
CHN4 = [];

CH1max = [];
CH2max = [];
CH3max = [];
CH4max = [];



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
    % check if necessary
    disp('Truncating ...');
    fullData = fullData(1:usefulData);
    
    
    disp('Reshaping data ....');
    %% reshape as a matrix with each interleved row as segment
    Segment = reshape(fullData, reshapeSize);

    %% separate PD FS and US signals
    disp('Deinterlacing data ...');
    
    if acq.ActivChNum == 2
        CHN1 = Segment(1:acq.ActivChNum:end,:,:);     %seperate each channel, the data acquisition order is channel 1, channel 2, channel 1, channel 2...
        CHN3 = Segment(2:acq.ActivChNum:end,:,:);
    elseif acq.ActivChNum == 4
        CHN1 = Segment(1:acq.ActivChNum:end,:,:);     %seperate each channel, the data acquisition order is channel 1, channel 2, channel 3, channel 4, channel 1 ......
        CHN2 = Segment(2:acq.ActivChNum:end,:,:);
        CHN3 = Segment(3:acq.ActivChNum:end,:,:);
        CHN4 = Segment(4:acq.ActivChNum:end,:,:);
    end
    
    
    disp('Data processing ... ')
    %disp('Filtering ultrasound data ...');
    %ultraSound_f = filter(num, denum, double(ultraSound));
    %ultraSound_f = ultraSound_f(filterShift+1:end,:,:);  %getting rid of the edge effect on the filtered data. Not doing this will mess up the peak-to-peak result
    
    
    

    CH1 = squeeze(peak2peak(CHN1, 1));
    CH2 = squeeze(peak2peak(CHN2, 1));
    CH3 = squeeze(peak2peak(CHN3, 1));
    CH4 = squeeze(peak2peak(CHN4, 1));
        
    CH1max = [CH1max; CH1];      % add data of each row in CH1max, only works in pattern 0
    CH2max = [CH2max; CH2];
    CH3max = [CH3max; CH3];
    CH4max = [CH4max; CH4];       
        
    
end



% USNORM = max(max(CHN1))*CHN3./CHN1;

if patternType ==1
    CH1max = CH1max';
    CH3max = CH3max';
    CH2max = CH2max';
    CH4max = CH4max';
end


    
save([directory, '\CHN1_', file_name, '.mat'], 'CHN1');
save([directory, '\CHN3_', file_name, '.mat'], 'CHN3');

imwrite(uint8(CH1max), [directory, '\CH1_', file_name, '.png']);
imwrite(uint8(CH3max), [directory, '\CH3_', file_name, '.png']);


figure(121); imagesc(uint8(CH1max));
figure(123); imagesc(uint8(CH3max));


if acq.ActivChNum == 4
    save([directory, '\CHN2_', file_name, '.mat'], 'CHN2');
    save([directory, '\CHN4_', file_name, '.mat'], 'CHN4');
    imwrite(uint8(CH2max), [directory, '\CH2_', file_name, '.png']);
    imwrite(uint8(CH4max), [directory, '\CH4_', file_name, '.png']);

    figure(122); imagesc(uint8(CH2max));
    figure(124); imagesc(uint8(CH4max));
    
end

disp('I am done!');
