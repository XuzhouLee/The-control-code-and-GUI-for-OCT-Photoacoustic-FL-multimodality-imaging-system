function acquisitor(handles)

clc
clear all
close all
  

if ~libisloaded('signalib')
    loadlibrary('PX4_64.dll', @LibPrototype, 'alias', 'signalib');
end

%% general initialization and constants
handles = [];
setappdata(0,'DataBuffSz', 26*8); % size of data structure to be transferred
setappdata(0, 'serverIP', '10.17.21.25'); % localhost
setappdata(0, 'serverPort', 55000);


setappdata(0, 'RAMChunk', 16384); %Max Sample Numb Modulo

setappdata(0, 'datadir', 'D:\PAMData');
setappdata(0, 'ImgNameRoot', 'PAM_Rabbit');


%% Acquisition variables
setappdata(0, 'PreTrigSampl', 5.5); %trigger delay in usec
%setappdata(0, 'PostTrigDelaySampl', 16*0); %delay in 
setappdata(0, 'AtrigLevel', 160);
setappdata(0, 'SamplingRateMHz', 200); %sampling rate in MHz (here 1GHz)
setappdata(0, 'AcqLengthPoint', 1024); % length of acquisition. Here 2 microsecond per trigger
setappdata(0, 'ActivChNum', 1); % 2 active channels
setappdata(0, 'OffsetCH1', 200); % DC offset for CH1
setappdata(0, 'OffsetCH2', 1680); % DC offset for CH2
setappdata(0, 'OffsetCH3', 1680); % DC offset for CH3
setappdata(0, 'OffsetCH4', 1680); % DC offset for CH4
setappdata(0, 'Channeloption', 7); % Channel Options: select "3" for channels 1-3; select "0" for QUAD;select "7" for Channel_3;

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
            'Position',[.4,.3,.18,.36],...
            'Resize','on',...
            'Visible','on',...
            'CloseRequestFcn',{@Main_closereq, handles});


GUIDesign;

setappdata(0, 'isRunning', 1);

end
                  

