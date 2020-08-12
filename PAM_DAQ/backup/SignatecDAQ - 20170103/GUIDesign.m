% script with the GUI design

%% connection pannel
handles.hCnctPnl = uipanel('Parent', handles.hfigM,...
                        'Title', 'Connection',...
                        'Fontweight', 'bold',...
                        'Units', 'normalized',...
                        'Position', [.05 .9 .9 .08]);
                    
handles.hCnctStatsLbl = uicontrol('Parent', handles.hCnctPnl,...
                         'String','Status :',...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'right',...
                         'Position',[.05, 0, .2, 1],...
                         'Style','text');
                     
handles.hCnctStatsFld = uicontrol('Parent', handles.hCnctPnl,...
                         'String','Disconnected. Ready to connect...',...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'bold',...
                         'HorizontalAlignment', 'left',...
                         'Position',[.3, .0, .7, 1],...
                         'Style','text'); 
                    
%% Image params pannel
handles.hImgParamPnl = uipanel('Parent', handles.hfigM,...
                        'Title', 'Image Parameters',...
                        'Fontweight', 'bold',...
                        'Units', 'normalized',...
                        'Position', [.05 .7 .9 .18]);
                    
handles.hHrzPixLbl =  uicontrol('Parent', handles.hImgParamPnl,...
                         'String','Horiz. Pixels:',...
                         'Units','normalized',...
                         'Fontsize',10,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'right',...
                         'Position',[.05, .7, .3, .25],...
                         'Style','text');
                     
handles.hHrzPixFld =  uicontrol('Parent', handles.hImgParamPnl,...
                         'String','---',...
                         'Units','normalized',...
                         'Fontsize',10,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'left',...
                         'Position',[.36, .7, .14, .25],...
                         'Style','text');
                     
handles.hVertLineLbl =  uicontrol('Parent', handles.hImgParamPnl,...
                         'String','Vert. Lines:',...
                         'Units','normalized',...
                         'Fontsize',10,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'right',...
                         'Position',[.525, .7, .3, .25],...
                         'Style','text');
                     
handles.hVertLineFld =  uicontrol('Parent', handles.hImgParamPnl,...
                         'String','---',...
                         'Units','normalized',...
                         'Fontsize',10,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'left',...
                         'Position',[.84, .7, .14, .25],...
                         'Style','text');
                     
                     
handles.hFlybkLbl =  uicontrol('Parent', handles.hImgParamPnl,...
                         'String','Flyback Pix:',...
                         'Units','normalized',...
                         'Fontsize',10,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'right',...
                         'Position',[.05, .45, .3, .25],...
                         'Style','text');
                     
handles.hFlybkFld =  uicontrol('Parent', handles.hImgParamPnl,...
                         'String','---',...
                         'Units','normalized',...
                         'Fontsize',10,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'left',...
                         'Position',[.36, .45, .14, .25],...
                         'Style','text'); 
                     
 
handles.hLineAvrgLbl =  uicontrol('Parent', handles.hImgParamPnl,...
                         'String','Line Averg:',...
                         'Units','normalized',...
                         'Fontsize',10,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'right',...
                         'Position',[.525, .45, .3, .25],...
                         'Style','text');
                     
handles.hLineAvrgFld =  uicontrol('Parent', handles.hImgParamPnl,...
                         'String','---',...
                         'Units','normalized',...
                         'Fontsize',10,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'left',...
                         'Position',[.84, .45, .14, .25],...
                         'Style','text');
                     
                     
                    
%% Acquisition status
handles.hAcqStatsPnl = uipanel('Parent', handles.hfigM,...
                        'Title', 'acquisition status',...
                        'Fontweight', 'bold',...
                        'Units', 'normalized',...
                        'Position', [.05 .6 .9 .08]);
                    
handles.hAcqStatsLbl = uicontrol('Parent', handles.hAcqStatsPnl,...
                         'String','Status :',...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'bold',...
                         'HorizontalAlignment', 'right',...
                         'Position',[.05, .00, .2, 1],...
                         'Style','text');
                     
handles.hAcqStatsFld = uicontrol('Parent', handles.hAcqStatsPnl,...
                         'String','Waiting for connection...',...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'bold',...
                         'HorizontalAlignment', 'left',...
                         'Position',[.3, .00, .7, 1],...
                         'Style','text'); 
                    
%% Display
handles.hDispPnl = uipanel('Parent', handles.hfigM,...
                        'Title', 'image display',...
                        'Fontweight', 'bold',...
                        'Units', 'normalized',...
                        'Position', [.05 .4 .9 .18]);
handles.hImgSlctLbl = uicontrol('Parent', handles.hDispPnl,...
                         'String','Open Image:',...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'left',...
                         'Position',[.05, .65, .25, .35],...
                         'Style','text');
                     
handles.hImgSlctFld = uicontrol('Parent', handles.hDispPnl,...
                         'String','Select image folder',...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'right',...
                         'Position',[.3, .65, .65, .35],...
                         'Style','togglebutton',...
                         'Callback',{@OpenImageFolder_Callback, handles});
                    
                    
                    
%% DAQ card setup
handles.hDaqSetupPnl = uipanel('Parent', handles.hfigM,...
                        'Title', 'Acquisition setup',...
                        'Fontweight', 'bold',...
                        'Units', 'normalized',...
                        'Position', [.05 .05 .9 .34]);
                    
                    
handles.hServerIPLbl = uicontrol('Parent', handles.hDaqSetupPnl,...
                         'String','Server IP/Port:',...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'left',...
                         'Position',[.05, .85, .35, .15],...
                         'Style','text');
                     
handles.hServerIPFld = uicontrol('Parent', handles.hDaqSetupPnl,...
                         'String',getappdata(0, 'serverIP'),...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'right',...
                         'Position',[.31, .85, .27, .15],...
                         'Style','edit',...
                         'Callback',{@updateServerIP_Callback, handles});
                     
                     
handles.hServerPortFld = uicontrol('Parent', handles.hDaqSetupPnl,...
                         'String',getappdata(0, 'serverPort'),...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'right',...
                         'Position',[.59, .85, .14, .15],...
                         'Style','edit',...
                         'Callback',{@updateServerPort_Callback, handles});
                     
                    
handles.hServerCnctBtn = uicontrol('Parent', handles.hDaqSetupPnl,...
                         'String','Connect',...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'right',...
                         'Position',[.75, .85, .2, .15],...
                         'Style','pushbutton',...
                         'Callback',{@connect2Server_Callback, handles}); 
                     
                            
handles.hImgRootLbl = uicontrol('Parent', handles.hDaqSetupPnl,...
                         'String','Image name:',...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'left',...
                         'Position',[.05, .7, .35, .15],...
                         'Style','text');
                     
handles.hImgRootFld = uicontrol('Parent', handles.hDaqSetupPnl,...
                         'String',getappdata(0, 'ImgNameRoot'),...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'left',...
                         'Position',[.4, .7, .55, .15],...
                         'Style','edit',...
                         'Callback',{@updateImgRoot_Callback, handles});
                     
                     
handles.hSmplRtLbl = uicontrol('Parent', handles.hDaqSetupPnl,...
                         'String','Sampling [MHz]:',...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'left',...
                         'Position',[.05, .55, .3, .15],...
                         'Style','text');
                     
handles.hSmplRtFld = uicontrol('Parent', handles.hDaqSetupPnl,...
                         'String',getappdata(0, 'SamplingRateMHz'),...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'left',...
                         'Position',[.35, .55, .12, .15],...
                         'Style','edit',...
                         'Callback',{@updateSamplingRateMHz_Callback, handles});
                     
handles.hRcrLenLbl = uicontrol('Parent', handles.hDaqSetupPnl,...
                         'String','Record [usec]:',...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'left',...
                         'Position',[.52, .55, .3, .15],...
                         'Style','text');
                     
handles.hRcrLenFld = uicontrol('Parent', handles.hDaqSetupPnl,...
                         'String',getappdata(0, 'AcqLengthMicroSec'),...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'left',...
                         'Position',[.82, .55, .12, .15],...
                         'Style','edit',...
                         'Callback',{@updateAcqLengthMicroSec_Callback, handles});                     
                     

handles.hTrigLvlLbl = uicontrol('Parent', handles.hDaqSetupPnl,...
                         'String','Trig level:',...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'left',...
                         'Position',[.05, .4, .3, .15],...
                         'Style','text');
                     
handles.hTrigLvlFld = uicontrol('Parent', handles.hDaqSetupPnl,...
                         'String',getappdata(0, 'AtrigLevel'),...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'left',...
                         'Position',[.35, .4, .12, .15],...
                         'Style','edit',...
                         'Callback',{@updateAtrigLevel_Callback, handles});
                     
handles.hPreTrigLbl = uicontrol('Parent', handles.hDaqSetupPnl,...
                         'String','Delay [usec]:',...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'left',...
                         'Position',[.52, .4, .3, .15],...
                         'Style','text');
                     
handles.hPreTrigFld = uicontrol('Parent', handles.hDaqSetupPnl,...
                         'String',getappdata(0, 'PreTrigSampl'),...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'left',...
                         'Position',[.82, .4, .12, .15],...
                         'Style','edit',...
                         'Callback',{@updatePreTrigSampl_Callback, handles}); 
                     
handles.hOffsetLbl = uicontrol('Parent', handles.hDaqSetupPnl,...
                         'String','Offset CH1/2/3/4:',...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'left',...
                         'Position',[.05, .25, .3, .15],...
                         'Style','text');
                     
handles.hCh1OffstFld = uicontrol('Parent', handles.hDaqSetupPnl,...
                         'String',getappdata(0, 'OffsetCH1'),...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'left',...
                         'Position',[.35, .25, .12, .15],...
                         'Style','edit',...
                         'Callback',{@updateOffsetCH1_Callback, handles}); 
       
handles.hCh2OffstFld = uicontrol('Parent', handles.hDaqSetupPnl,...
                         'String',getappdata(0, 'OffsetCH2'),...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'left',...
                         'Position',[.5, .25, .12, .15],...
                         'Style','edit',...
                         'Callback',{@updateOffsetCH2_Callback, handles});
                     
handles.hCh3OffstFld = uicontrol('Parent', handles.hDaqSetupPnl,...
                         'String',getappdata(0, 'OffsetCH3'),...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'left',...
                         'Position',[.65, .25, .12, .15],...
                         'Style','edit',...
                         'Callback',{@updateOffsetCH3_Callback, handles}); 

 handles.hCh4OffstFld = uicontrol('Parent', handles.hDaqSetupPnl,...
                         'String',getappdata(0, 'OffsetCH4'),...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'left',...
                         'Position',[.8, .25, .12, .15],...
                         'Style','edit',...
                         'Callback',{@updateOffsetCH4_Callback, handles});                    
                     
handles.hOffsetLbl = uicontrol('Parent', handles.hDaqSetupPnl,...
                         'String','Channel option:',...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'left',...
                         'Position',[.05, .10, .6, .15],...
                         'Style','text');                     

pulldownValue = getappdata(0, 'Channeloption'); %read the channel option from appdata
% select the pulldown index based on channeloption value
if pulldownValue == 3
    pulldownValue = 1;
elseif pulldownValue == 0
    pulldownValue = 2;
end
handles.hChOptFld = uicontrol('Parent', handles.hDaqSetupPnl,...
                         'string',{'DUAL_1_3';'QUAD'},...
                         'Units','normalized',...
                         'Fontsize',9,...
                         'Fontweight', 'normal',...
                         'HorizontalAlignment', 'left',...
                         'position',[.35, .10, .6, .15],...  
                         'style','pop',...
                         'value',pulldownValue,...
                         'Callback',{@updateChanneloption_Callback, handles});                     
 

% handles.hFetchImgDataBtn = uicontrol('Parent', handles.hDaqSetupPnl,...
%                                 'String', 'Fetch image data',...
%                                 'Units','normalized',...
%                                  'Fontsize',9,...
%                                  'Fontweight', 'normal',...
%                                  'HorizontalAlignment', 'center',...
%                                  'Position',[.05, .05, .9, .18],...
%                                  'Style','togglebutton',...
%                                 'Callback',{@FetchImgData_Callback, handles});
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

                           