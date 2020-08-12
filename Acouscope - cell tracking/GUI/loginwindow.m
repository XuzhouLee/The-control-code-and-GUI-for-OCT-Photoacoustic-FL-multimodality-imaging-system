function handles = loginwindow(source, handles)

% function to restrict access to users who have not been trained.
% users and passwords are stored in
% C:\Instruments\Acouscope\gui_data\users.txt

global Modules  %defined in Acousope_00

%% Log In or Log out??
toggle_state = get(source, 'Value');

%% stored list of users, passwords: Make sure users and passwords are paired correctly
[users, pswrds] = textread('C:\Instruments\Acouscope\gui_data\users.txt', '%s %s');
    
%% stored list of shortcodes, department and PI: Make sure shortcodes and deptid piname are matched correctly    
%[shortcodes, deptnm, deptid, prjctid, piname ] = textread('C:\Instrument Control\FemtoScalpel\gui_data\finance.txt', '%s %s %s %s %s');

%% initialize log file, if needed
Date_vec = clock;
year = Date_vec(1);
month = Date_vec(2);
LogFileName = ['C:\Instruments\Acouscope\Logs\acouscope_Log_', num2str(year, '%04d'), '_',...
                            num2str(month, '%02d'), '.csv'];
formatSpec = '%s \t %s \t %s'; % LoginTime, user, log out time

%% if log file is not created yet, create it:                        
if ~exist(LogFileName)
    %xlswrite(LogFileName, [{'Login Time'} {'User'} {'Short Code'} {'Project ID'} {'Department'} {'Department ID'} {'PI Name'}  {'Temperature'} {'Log Out Time'} {'Duration(hrs)'}]);
    LogFileId = fopen(LogFileName, 'w');
    fprintf(LogFileId, formatSpec, 'LoginTime', 'User', 'LogoutTime');
    fclose(LogFileId);
end


%% check if file open by MS excel or another program
[FileID, MSG] = fopen(LogFileName, 'a');
if ~isempty(MSG)
    errordlg('Error opening csv log file; Make sure Log file is not open by another application before logging in. ');
    set(source, 'Value', ~toggle_state);
    return
end
fclose(FileID);


%% toggle cases log in or log out?
if toggle_state == 1
    %% case "Log In"
    prompt = {'User:',...
                'Password:'};
    dlg_title = 'Login Window';
    num_lines = 1;
    usr_input = inputdlg(prompt,dlg_title,num_lines);
    
    if isempty(usr_input)
        set(source, 'Value', ~toggle_state);
        return
    else
        usr = usr_input{1};
        pswrd = usr_input{2};
        
    
        usr_match = strmatch(usr, users, 'exact');
        pswrd_match = strmatch(pswrd, pswrds, 'exact');
        
        if isempty(usr_match)
            errordlg('User not authorized to use equipments. Please contact administrator.','Login Error');
            set(source, 'Value', 0);
            return
        elseif (isempty(pswrd_match)) | (pswrd_match ~= usr_match)
            errordlg('Invalide Password. Please try again.','Login Error');
            set(source, 'Value', 0);
            return
        else
            %% Record keeping and login and file update
            set(source, 'String', 'Log Out');
        
            %% enable module buttons
            for i=1:length(Modules)
                    set(handles.(Modules{i}), 'Enable', 'on');  
            end
            
            %% enable laser shutter button

            if isfield(handles,'hShtrBtn')
                set(handles.hShtrBtn, 'Enable', 'on');
                set(handles.hShtrBtn, 'Backgroundcolor', [.8 .8 .8],...
                                        'Fontweight', 'normal');
            end
            
            %% Update the csv longin record
            fid = fopen(LogFileName, 'a');
            fprintf(fid, '\r\n %s \t %s \t', datestr(clock), usr);
            fclose(fid);
        end
        
    end
      PAMCtrl(handles);
      EksplaOPO(handles);
      SetDAQ(handles);

    
elseif toggle_state == 0
        %% case "log out"
        % close all module figures except for main
        fh=findall(0,'type','figure');
        fh_close_indx = find(fh ~=1); %index of figure handles to close (all handles other than handle 1)
        fh_close = fh(fh_close_indx); % fingure handes to close (all except handle 1)
        for qq = 1:length(fh_close)
            close(figure(fh_close(qq)))
        end

              
        %% disable all modules
        for i=1:length(Modules)
                    set(handles.(Modules{i}), 'Enable', 'off');  
        end
        
        %% disable laser shutter
        if isfield(handles,'hShtrBtn')
            set(handles.hShtrBtn, 'Enable', 'off');
            set(handles.hShtrBtn, 'Backgroundcolor', [.8 .8 .8],...
                                        'Fontweight', 'normal');
            if getappdata(0, 'LsrShtrOpn') == 1
                closeLaserShutter_3_000(handles);
                set(handles.handles.hShtrBtn, 'Value', 0,...
                                        'String', 'Open Laser Sutter');
            end
                     
            
        end
        
        
        %% disbale run instrunction file      
        if isfield(handles,'InsFileRun')
            set(handles.InsFileRun, 'Enable', 'off');
        end
  

        set(source, 'String', 'Log In');
        %% Update the csv longin record
        fid = fopen(LogFileName, 'a');
        fprintf(fid, '%s', datestr(clock));
        fclose(fid);
        Main_closereq(0,0, handles);
            
end



end
