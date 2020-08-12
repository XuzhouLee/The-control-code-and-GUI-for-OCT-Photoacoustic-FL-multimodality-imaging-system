function acquisitor(handles)

clc
clear all
close all


if ~libisloaded('signalib')
    loadlibrary('PX4_64.dll', @LibPrototype, 'alias', 'signalib');
end

%% general initialization and constants
handles = [];
setappdata(0,'DataBuffSz', 7*8); % size of data structure to be transferred
setappdata(0, 'serverIP', '10.17.20.48'); % localhost
setappdata(0, 'serverPort', 55000);


setappdata(0, 'RAMChunk', 16384); %Max Sample Numb Modulo

setappdata(0, 'datadir', 'D:\PAMData');
setappdata(0, 'ImgNameRoot', 'PAM_Rabbit');


%% Acquisition variables
setappdata(0, 'PreTrigSampl', -0.5); %trigger delay in usec
%setappdata(0, 'PostTrigDelaySampl', 16*0); %delay in 
setappdata(0, 'AtrigLevel', 160);
setappdata(0, 'SamplingRateMHz', 1e3); %sampling rate in MHz (here 1GHz)
setappdata(0, 'AcqLengthMicroSec', 4); % length of acquisition. Here 2 microsecond per trigger
setappdata(0, 'ActivChNum', 2); % 2 active channels
setappdata(0, 'OffsetCH1', 200); % DC offset for CH1
setappdata(0, 'OffsetCH2', 2048); % DC offset for CH2
setappdata(0, 'OffsetCH3', 2048); % DC offset for CH3
setappdata(0, 'OffsetCH4', 2048); % DC offset for CH4
setappdata(0, 'Channeloption', 3); % Channel Options: select "3" for channels 1-3; select "0" for QUAD

%% initialize Signatec
handles.phBrd = initSignatec();



%% TCPIP init
handles.tcpipClient = tcpip(getappdata(0, 'serverIP'),getappdata(0, 'serverPort'),'NetworkRole','Client');
set(handles.tcpipClient,'InputBufferSize', getappdata(0,'DataBuffSz'));
set(handles.tcpipClient,'Timeout',.5);
setappdata(0, 'tcpipClient', handles.tcpipClient);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main Window and controls%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles.hfigM=figure('MenuBar','none',...
            'Name','Acquisitor',...
            'Units','normalized',...
            'Position',[.8,.6,.18,.36],...
            'Resize','on',...
            'Visible','on',...
            'CloseRequestFcn',{@Main_closereq, handles});


GUIDesign;

setappdata(0, 'isRunning', 1);

end
                  

function updateServerIP_Callback(src, event, handles)
    IP = get(src, 'String'); 
    if ~validate_ipaddress(IP) & ~strcmp(IP, 'localhost')
        errordlg('Invalid IP Address. Try again')
        set(src, 'String', getappdata(0, 'serverIP'));
    else
        setappdata(0, 'serverIP', IP);
    end
end


function updateServerPort_Callback(src, event, handles)
    port = get(src, 'String');
    port = uint32(str2num(port));
    if port <0 | port > 65536
        errordlg('Invalid port number. Try again')
        set(src, 'String', getappdata(0, 'serverPort'));
    else
        setappdata(0, 'serverPort', port);
    end
end

function connect2Server_Callback(src, event, handles)
    
    tcpipClient = getappdata(0, 'tcpipClient');
    if strcmp(tcpipClient.Status, 'open')
        disp('Previous session still open. Closing...')
        fclose(tcpipClient)
    end

    disp('Opening...');

    try 
        fopen(getappdata(0, 'tcpipClient'))
    catch Ex
        disp('Could not connect to server. Refresh server then try again...')
        %connect2Server_Callback(src, event, handles);
        return;
    end
    disp('Connection open');
    %set(handles.hFetchImgDataBtn, 'Value', 1);
    
    FetchImgData_Callback(src, event, handles);    
end



function FetchImgData_Callback(src, event, handles)
    state = get(src, 'Value');
    if state == 1
        %% acquire data
        disp('starting the acquisition...')
        %daquirefromPX4Stack(handles);
        daquirefromPX4(handles);
     else
       try 
           setappdata(0, 'isRunning', 0)
           return
        catch Ex
            disp('not care');
       end
    end
    
end

function updateImgRoot_Callback(src, event, handles)
    name = get(src, 'String');
    if isempty(regexp(name, '[/\*:?"<>|0-9]', 'once'))
        setappdata(0, 'ImgNameRoot', name);
    else
        errordlg('Invalid file name. Try again.');
        set(src, 'String', getappdata(0, 'ImgNameRoot'));
    end
    
end

function updateSamplingRateMHz_Callback(src, event, handles)
    rate = get(src, 'String');
    rate = str2num(rate);
    channeloption = getappdata(0, 'Channeloption');
    if (channeloption == 3 && rate > 1500 || rate < 200)
        errordlg('Invalid sampling rate. For Dual channels enter a rate between 200 and 1500 MHz.');
        set(src, 'String', num2str(getappdata(0,'SamplingRateMHz')));
    elseif (channeloption == 0 && rate > 500 || rate < 200)
        errordlg('Invalid sampling rate. For Quad channels enter a rate between 200 and 500 MHz.')
        set(src, 'String', num2str(getappdata(0,'SamplingRateMHz')));
    else
       setappdata(0,'SamplingRateMHz', rate);
    end
end

function updateAcqLengthMicroSec_Callback(src, event, handles)
    len = get(src, 'String');
    len = str2num(len);
    if (len < 0.1 || len > 100)
        errordlg('Invalid record length. Must be between 0.1 and 100 uSec');
        set(src, 'String', num2str(getappdata(0, 'AcqLengthMicroSec')));
    else
        setappdata(0, 'AcqLengthMicroSec', len);
    end
end


function updateAtrigLevel_Callback(src, event, handles)
    levl = get(src, 'String');
    levl = uint16(str2num(levl));
    if (levl < 0 || levl > 255)
        errordlg('Invalid record length. Must be between 0 and 255');
        set(src, 'String', num2str(getappdata(0, 'AtrigLevel')));
    else
        setappdata(0, 'AtrigLevel', levl);
    end
end

function updatePreTrigSampl_Callback(src, event, handles)
    pretrig = get(src, 'String');
    pretrig = str2num(pretrig);
    if (pretrig < -10 || pretrig > 30 || isempty(pretrig))
        errordlg('Invalid tigger delay. Must be between -10 usec and 30 usec');
        set(src, 'String', num2str(getappdata(0, 'PreTrigSampl')));
    
    else
        % convert pretrig in usec to sample count
        setappdata(0, 'PreTrigSampl', pretrig);
    end
end

function OpenImageFolder_Callback(src, event, handles)
    folder_name = uigetdir(getappdata(0, 'datadir'));
    set(src, 'String', strrep(folder_name, [getappdata(0, 'datadir'),'\'], ''));
    setappdata(0, 'Display_Image', folder_name);
    makeImgFromData(folder_name);
end

%% setting DC offset
function updateOffsetCH1_Callback(src, event, handles)
    offsettxt = get(src, 'String');
    offset = round(str2num(offsettxt));
    if (offset < 0 | offset > 4095)
        errordlg('Invalid offset value. Must be an integer between 0 and 4095');
        set(src, 'String', num2str(getappdata(0, 'OffsetCH1')));
    end
    setDCOffset(handles.phBrd, 1, offset); %% setting offset for CH1
    setappdata(0, 'OffsetCH1', offset);
end

function updateOffsetCH2_Callback(src, event, handles)
    offsettxt = get(src, 'String');
    offset = round(str2num(offsettxt));
    if (offset < 0 | offset > 4095)
        errordlg('Invalid offset value. Must be an integer between 0 and 4095');
        set(src, 'String', num2str(getappdata(0, 'OffsetCH2')));
    end
    setDCOffset(handles.phBrd, 2, offset); %% setting offset for CH2
    setappdata(0, 'OffsetCH2', offset);
end

function updateOffsetCH3_Callback(src, event, handles)
    offsettxt = get(src, 'String');
    offset = round(str2num(offsettxt));
    if (offset < 0 | offset > 4095)
        errordlg('Invalid offset value. Must be an integer between 0 and 4095');
        set(src, 'String', num2str(getappdata(0, 'OffsetCH3')));
    end
    setDCOffset(handles.phBrd, 3, offset); %% setting offset for CH3
    setappdata(0, 'OffsetCH3', offset);
end

function updateOffsetCH4_Callback(src, event, handles)
    offsettxt = get(src, 'String');
    offset = round(str2num(offsettxt));
    if (offset < 0 | offset > 4095)
        errordlg('Invalid offset value. Must be an integer between 0 and 4095');
        set(src, 'String', num2str(getappdata(0, 'OffsetCH4')));
    end
    setDCOffset(handles.phBrd, 4, offset); %% setting offset for CH4
    setappdata(0, 'OffsetCH4', offset);
end

%setting channel option; 
% channeloptionnum equal to 1 means dual channel 1_3; channeloptionnum equal to 2 means quad channel 1_2_3_4
function updateChanneloption_Callback(src, event, handles)
    channeloptionnum = get(src, 'value');
    
    samplingRate = getappdata(0,'SamplingRateMHz');
    
    if (channeloptionnum == 2 && samplingRate > 500) %make sure that DAQ card will not be out of memory
        errordlg('Sampling rate is too high for this channel count. Update sampling rate first. Quad mode has max sampling rate = 500MHz.');
        set(src, 'value', 1);
    end
    
    if channeloptionnum == 1
        setappdata(0, 'ActivChNum', 2);
        setappdata(0, 'Channeloption',3);
    else
        setappdata(0, 'ActivChNum', 4);
        setappdata(0, 'Channeloption',0);
    end
    
    
end