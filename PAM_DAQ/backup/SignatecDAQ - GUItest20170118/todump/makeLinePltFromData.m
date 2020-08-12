function makeLinePltFromData(params)

%% .rd8 reshape
% Method to reshape .rd8 data from data acquisition board into matrix
% representative of the real image

ImgName = [getappdata(0, 'datadir'), '\LinePlotTemp\temp.rd8'];

% params = [number of pixel to acquire per line, number of rows; number of extra triggers for flyback; patternType; line averaging;...
            %            range along the width direction in microns; range along the height direction in microns]

%% Reshape DAQ data
pixelNum = params(1);
rowNum = params(2);
flybkPixels = params(3);
SamplingRate = getappdata(0, 'SamplingRateMHz');     % sampling rate in Hz


%% ultrasound filtering
Fc = 1e2;                                   % cut-off frequency in Hz
Fnorm = Fc/(SamplingRate/2);                 % Normalized frequency
% filter design, low pass
df = designfilt('lowpassfir','FilterOrder',70,'CutoffFrequency',Fnorm);
[num, denum] = tf(df);
%  Delay = mean(grpdelay(df));  % group delay (constant) introduced by
%  filter. ignore since not relevant
filterShift = 40; %edge effect due to filtering on the filtered data.

%% de-interlacing
SegmentSampleNum = getappdata(0, 'SamplingRateMHz')*getappdata(0, 'AcqLengthMicroSec')*getappdata(0, 'ActivChNum');

PDIM = zeros(rowNum, pixelNum);
USIM = zeros(rowNum, pixelNum);


iRows = rowNum;
usefulData = SegmentSampleNum * (pixelNum+flybkPixels);
reshapeSize = [SegmentSampleNum, (pixelNum+flybkPixels)];


PDIM = [];
USIM = [];


    
%%disp('Reading data ...');
rd8Data = fopen(ImgName, 'r');
fullData = fread(rd8Data, '*uint8'); %[1, Info.bytes], 
fclose(rd8Data);


%% truncate extra data from memory
%%disp('Truncating ...');
fullData = fullData(1:usefulData);


%%disp('Reshaping data ....');
%% reshape as a matrix with each interleved row as segment
Segment = reshape(fullData, reshapeSize);

%% separate PD and US signals

%%disp('Deinterlacing data ...');
photoDiode = Segment(1:2:end,:);
ultraSound = Segment(2:2:end,:);


%%disp('Filtering ultrasound data ...');
ultraSound_f = filter(num, denum, double(ultraSound));
ultraSound_f = ultraSound_f(filterShift+1:end,:);  %getting rid of the edge effect on the filtered data. Not doing this will mess up the peak-to-peak result


%PDmax = squeeze(peak2peak(photoDiode, 1));
USmax = squeeze(peak2peak(ultraSound_f, 1));

% USNORM = max(max(PDIM))*USIM./PDIM;


figure(123); plot(USmax);
axis([flybkPixels+1, flybkPixels+ pixelNum, 0, 255]);


