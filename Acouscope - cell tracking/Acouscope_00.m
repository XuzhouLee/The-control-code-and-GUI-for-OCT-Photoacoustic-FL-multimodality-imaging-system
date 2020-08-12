  function Acouscope_00(handles)

clc; clear all;
delete(instrfindall);
clear s; 
instrreset;
warning('off','all');


%% Program to control femtosecond laser nanosurgery instrument
%% Copyrights AG Mordovanakis
%%
javaaddpath('C:\Program Files\Ocean Optics\OmniDriverSPAM\OOI_HOME\OmniDriver.jar');
%Add appropriate paths
if(isdeployed==false)
    addpath('C:\Instruments\Acouscope - cell tracking\GUI',...
            'C:\Instruments\Acouscope - cell tracking\OCT',...
            'C:\Instruments\Acouscope - cell tracking\basics'); 
end

%% tab module panel
global Modules
%laserCOMprt = 3; % virtual COM port for the laser connection (RS232 through virtual FDTI port 

%% Initialization
handles = []; %% Initialize handles structure
Params_Init;
%% Variable initializations Define some useful flags/variables
%Val_Init_0_00(handles);


%% Device Initialization
%% DAQ board control using Matlab Session-Based interface
devices = daq.getDevices;

for i=1:length(devices)
    if isprop(devices(i),'Model') & (strcmp(devices(i).Model, 'USB-6353'))
        disp('Found NI card Model 6353 ...');
        % DAQ session for Master trigger used to trigger shutter, DAQ,
        handles.daqSessionMstrTrig = daq.createSession('ni');  %Synched trigger to use to drive shutter, DAQ
        addDigitalChannel(handles.daqSessionMstrTrig,devices(i).ID, 'Port0/Line0:1', 'OutputOnly'); %Line 0 to drive the shutter, line 1 to drive the Signatec DAQ board
        outputSingleScan(handles.daqSessionMstrTrig, [0,0]); % make sure all triggers are OFF
        release(handles.daqSessionMstrTrig)
        
        % DAQ session for reading shutter status
        handles.daqSessionRead = daq.createSession('ni');
        ShutterLineChk = addDigitalChannel(handles.daqSessionRead,devices(i).ID, 'Port0/Line4', 'InputOnly');
        break
    end
end

% check inf the handle for master trig has been created. If not, probably
% because USB-6353 is not present
if ~isfield(handles, 'daqSessionMstrTrig')
    disp('NI USB-6353 not present. Check USB connection.');
end


%% Ekspla initialization and connection
if ~libisloaded('ekslib')
    
    disp('Loading Ekspla libraries ...');
    try
        loadlibrary('C:\Instruments\Acouscope - cell tracking\REMOTECONTROL64.dll',...
                    'C:\Instruments\Acouscope - cell tracking\REMOTECONTROL.H', ...
                    'alias', 'ekslib');
        disp('Ekspla Libraries successfully loaded.')
     catch ME
        if (strcmp(ME.identifier,'MATLAB:loadlibrary:LoadFailed'))
                disp('Could not load Ekspla libraries.')
                disp('Laser controls from this software will be disabled')
                input('Press any key to continue without laser controls.');
        end
    end
end

% create OPOStatus instance of LsrStatus Class:
% classdef LsrStatus
%           Properties:
%               OPOStatus .Connection
%               OPOStatus.AmpON
%               OPOStatus.Wavelength
%               OPOStatus.Shutter

OPOStatus = LsrStatus();
% save the instance in app data
setappdata(0, 'OPOStatus', OPOStatus); 
% try to connect to the laser controller
OPOStatus.Connection = connectEkspla(handles);



%%   loading OCT libraries and initializing OCT
if ~libisloaded('octlib')
    try
        disp('Loading OCT SpectralRadar libraries ...');
        loadlibrary('C:\Instruments\Acouscope - cell tracking\OCT\SpectralRadar.dll',...
                    'C:\Instruments\Acouscope - cell tracking\OCT\SpectralRadar.h',...
                    'alias', 'octlib');
        disp('OCT SpectralRadar libraries loaded');
        
    catch  ME
        if (strcmp(ME.identifier,'MATLAB:loadlibrary:LoadFailed'))
                disp('Could not load Thorlabs OCT libraries.');
                disp('OCT and Scanner controls from this software will be disabled');
                input('Press any key to continue without OCT/Scanner controls.');
        end
    end 

end


if libisloaded('octlib')
    
    
    %Check if OCT is ON by looking for NI USB-6251
    foundit = 0;
    for i=1:length(devices)
        if isprop(devices(i),'Model') & (strcmp(devices(i).Model, 'USB-6251 (OEM)'))
            disp('Found NI card Model 6251 ...');
            foundit = 1;
%             octStatus.Device = calllib('octlib', 'initDevice');
%             octStatus.Probe = calllib('octlib', 'initProbe', octStatus.Device, 'Probe');            
            break
        else
        end
    end
    
    % what to do if the OCT is not present
    if foundit == 0
            dlgprmt = ['OCT not present. Verify that OCT is turned ON. Would you like to abort and try again or continue without OCT/scanner controls?'];
            option = questdlg(dlgprmt, ...
                            'OCT connection error', ...
                            'Continue (no OCT/scanner)','Abort','Continue (no OCT/scanner)');
            % Handle response
            switch option
                case 'Continue (no OCT/scanner)'
                    disp('Continuing without OCT/Scanner controls ...')
                case 'Abort'
                    Main_closereq(0,0, handles);
                    return
            end
    end

    
end

% %% Loading Thorlabs Camera (beam profiler) .NET ddls
% asm = System.AppDomain.CurrentDomain.GetAssemblies;
% if ~any(arrayfun(@(n) strncmpi(char(asm.Get(n-1).FullName), ...
%         'uc480DotNet', length('uc480DotNet')), 1:asm.Length))
%     NET.addAssembly(...
%         'C:\Instruments\Acouscope\uc480DotNet.dll');
% end
% disp('ThorCam .Net libraries loaded');


%% Initializing waveplate
%% open and set the COM port and parameters
handles.wvplt = serial('COM4');
% Set the COM port params (from the waveplate motor controller (Thorlabs APT DC
% Servo) manual
set(handles.wvplt,'BaudRate',115200);
set(handles.wvplt,'DataBits',8);
set(handles.wvplt,'StopBits',1);
set(handles.wvplt,'Parity','none');
set(handles.wvplt,'Timeout', 2);
set(handles.wvplt, 'InputBufferSize',512);
set(handles.wvplt, 'Timeout', 10);
set(handles.wvplt, 'ReadAsyncMode', 'continuous');

% open COM port
fopen(handles.wvplt);
% Home the motor for calibration then move to default value set in
% params_init
WvPltHomeandMax(handles.wvplt);
pause(2); % 2 seconds to allow the motor to home


%% starting TCPIP server
% setting up tcpip server for comunication with DAQ computer
handles.tcpipServer = tcpip('0.0.0.0',55000,'NetworkRole','Server');
set(handles.tcpipServer,'OutputBufferSize',256);
setappdata(0, 'tcpipServer', handles.tcpipServer);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%        Main Window GUI

% --- Construct the components of the main GUI
% loginwindow;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main Window and controls%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles.hfigM=figure('MenuBar','none',...
            'numbertitle','off',...
            'Name','AcouScope',...
            'Units','normalized',...
            'Position',[.295,.165,.40,.64],...
            'Resize','on',...
            'Visible','on');


handles.hMdlPnl = uipanel('Parent', handles.hfigM,...
                        'Title', 'Modules',...
                        'Fontweight', 'bold',...
                        'Units', 'normalized',...
                        'Position', [.18 .91 .29 .09]);


%%
Modules = [{'DAQServer'}, {'blank2'}];
                    
%some normalized distances for alignment
brdr = .02;
xpitch = (1-brdr)/length(Modules);
xwidth = 1-4*brdr;
ywidth = xpitch-brdr;

for i=1:length(Modules)
    handles.(Modules{i}) = uicontrol(... % List of available types of plot
                         'Parent', handles.hMdlPnl,... 
                         'String',Modules{i},...
                         'Units','normalized',...
                         'Fontsize',12,...
                         'Position',[brdr+(length(Modules)-i)*xpitch 0.04  ywidth xwidth],...
                         'Tag', [Modules{i},'Tag'],...
                         'Enable', 'off',...
                         'Style','togglebutton');  
end

set(handles.DAQServer, 'Style','pushbutton');

%% Login button
handles.hLogin = uicontrol('String','Log In',...
                     'Backgroundcolor', [.8 .8 .8],...
                     'Fontsize', 15, ...
                     'Units','normalized',...
                     'Position',[.02 .925 .14 .05],...
                     'Tag', 'LoginTag',...
                     'Style','togglebutton');


%% status Panel
handles.hStsPnl = uipanel('Parent', handles.hfigM,...
                            'Title', 'System Status',...
                            'Fontweight', 'bold',...
                            'Units', 'normalized',...
                            'Fontsize', 12, ...
                            'Position', [.02, .73, .45, .1725]);
                        
StatusModules = [{'LaserStatus'}, {'LaserWavelength'}, {'ShutterStatus'}, {'OCTStatus'}];
%some normalized distances for alignment
brdr = .02;
Statusxpitch = (1-brdr)/length(StatusModules);
Statusxwidth = Statusxpitch-brdr;
Statusywidth = 1-4*brdr;



for i=1:length(StatusModules)
    handles.label.(StatusModules{i}) = uicontrol(... % List of available types of plot
                         'Parent', handles.hStsPnl,... 
                         'String',StatusModules{i},...
                         'Units','normalized',...
                         'Fontsize',10,...
                         'Position',[0.04 brdr+(length(StatusModules)-i)*Statusxpitch Statusywidth*.4 Statusxwidth],...
                         'Tag', [StatusModules{i},'Tag'],...
                         'HorizontalAlignment', 'left',...
                         'Style','text'); 
                     
    handles.indicator.(StatusModules{i}) = uicontrol(... % List of available types of plot
                         'Parent', handles.hStsPnl,... 
                         'Units','normalized',...
                         'Fontweight', 'bold', 'Fontsize', 16,...
                         'Position',[0.5 brdr+(length(StatusModules)-i)*Statusxpitch Statusywidth*.52 Statusxwidth],...
                         'Tag', [StatusModules{i},'Tag'],...
                         'HorizontalAlignment', 'left',...
                         'Backgroundcolor', [.9, .1, .1],...
                         'Style','text');                   
end

%% update and display

% check and initialize startup parameters
OPOStatus = readOPOAmp(handles); %check OPO Amp status
OPOStatus = getOPOWavelength(handles); % get OPO wavelength
OPOStatus = getShutterStatus(handles); % check shutter status

startwavelength = OPOStatus.Wavelength; %staring OPO wavelength

%% initializing octStatus object
% instantiate octStatus as an instance of the OCTStatus class and save the
% NULL copy to appdata
octStatus = OCTStatus();
setappdata(0, 'octStatus', octStatus);

if ~isempty(octStatus.Device) & ~octStatus.Device.isNull % check OCT status to set main window buttons and colors
    set(handles.indicator.OCTStatus, 'String', 'SLD ON', 'Backgroundcolor', [.1, 1, .1]);
else
    set(handles.indicator.OCTStatus, 'String', 'SLD OFF', 'Backgroundcolor', [.5, .5, .5]);
end


%% Control Panel
handles.hCtrlPnl = uipanel('Parent', handles.hfigM,...
                            'Title', 'System Control',...
                            'Fontweight', 'bold',...
                            'Units', 'normalized',...
                            'Fontsize', 12, ...
                            'Position', [.02, .52, .45, .2]);
                        
handles.hShtrBtn = uicontrol('Parent', handles.hCtrlPnl,...
                     'String','Open Shutter',...
                     'Backgroundcolor', [.8 .8 .8],...
                     'Fontsize', 12, ...
                     'Units','normalized',...
                     'Position',[.2 .78 .6 .2],...
                     'Tag', 'ShtrBtnTag',...
                     'Enable', 'off',...
                     'Style','togglebutton');

handles.hGtOCTBtn = uicontrol('Parent', handles.hCtrlPnl,...
                     'String','Acquire OCT',...
                     'Backgroundcolor', [.8 .6 .6],...
                     'Fontsize', 12, ...
                     'Units','normalized',...
                     'Position',[.2 .56 .6 .2],...
                     'Tag', 'GtOCTBtnTag',...
                     'Style','pushbutton');

handles.hGtPAMBtn = uicontrol('Parent', handles.hCtrlPnl,...
                     'String','Acquire PAM',...
                     'Backgroundcolor', [.6 .8 .6],...
                     'Fontsize', 12, ...
                     'Units','normalized',...
                     'Position',[.2 .32 .6 .2],...
                     'Tag', 'GtOCTBtnTag',...
                     'Style','pushbutton'); 
                        
handles.hGtPAMBtn = uicontrol('Parent', handles.hCtrlPnl,...
                     'String','Acquire Fluorescence',...
                     'Backgroundcolor', [.6 .6 .8],...
                     'Fontsize', 12, ...
                     'Units','normalized',...
                     'Position',[.2 .08 .6 .2],...
                     'Tag', 'GtOCTBtnTag',...
                     'Style','pushbutton'); 
         

%%Callback values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   set(handles.LaserOPO, 'callback', {@EksplaOPO, handles}); 
%   set(handles.PAMCtrl, 'callback', {@PAMCtrl, handles}); 
  set(handles.hShtrBtn, 'callback', {@LaserShutterBtn_Callback, handles});% callback for module
  set(handles.hLogin, 'callback', {@Login_Callback, handles});
  set(handles.DAQServer, 'callback', {@RefreshDAQServer_Callback, handles});
  set(handles.hfigM, 'CloseRequestFcn',{@Main_closereq, handles});

  
end



%% Login function: controls user access by disabling main buttons unless valid credentials are given
% valid credentials are saved in Acouscope/gui_data
% also save log in and log out data to Acouscope/Logs
function Login_Callback(source, event, handles)
    loginwindow(source, handles);
    
end

%% laser shutter function to toggle shutter status
% Shutter controller must be on Remote setting in hardware
function LaserShutterBtn_Callback(source, event, handles)
    if get(source, 'Value') == 1 % if user clicked Open
        status = openLaserShutter(handles);
    else
        closeLaserShutter(handles);
        set(source, 'String', 'Open Laser Shutter', 'Background', [.8,0.8,0.8], 'Fontweight', 'normal');
    end
end

%% Refreshing the TCPIP connection
function RefreshDAQServer_Callback(source, event, handles)
   
    tcpipServer = getappdata(0, 'tcpipServer');
    if strcmp(tcpipServer.Status, 'open')
        % if session previously open, close it first
        fclose(tcpipServer);
    end
    fopen(tcpipServer);
    
end