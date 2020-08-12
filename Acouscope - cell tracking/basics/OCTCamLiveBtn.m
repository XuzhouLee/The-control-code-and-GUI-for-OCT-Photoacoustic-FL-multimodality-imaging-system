function handles = OCTCamLiveBtn(source, event, handles)
% function to open the camera in the OCT scan head. a bit buggy.
% camera is refreshed by matlab, so it will block/slow Matlab processing.
% Do not keep the camera open if acquiring data.

% TODO: find a better way to display and refresh camera without sticking
% Matlabin a while loop


octStatus = getappdata(0, 'octStatus');
setappdata(0, 'point',0);



refreshNum = 0;


if get(source, 'Value') == 1 

    setappdata(0,'PosXa',[]);
    setappdata(0,'PosYa',[]);
    setappdata(0,'PosXb',[]);
    setappdata(0,'PosYb',[]);
    
    if isempty(octStatus.Device) 
        errordlg('OCT is not initialized. Initialize before opening camera.')
        set(source, 'Value', 0);
        return
    end
    set(handles.OCT.CamLiveBtn, 'String', 'Click to stop live view')
    %getting camera image size
    sizeX = libpointer('int32Ptr', 0);
    sizeY = libpointer('int32Ptr', 0);
    
    imgpath = libpointer('cstring', 'C:\Instruments\Acouscope\imagetest.bmp');

    %% taking an image
    
    ColoredData = calllib('octlib', 'createColoredData')
    calllib('octlib', 'getMaxCameraImageSize', octStatus.Device, sizeX, sizeY);
    %% main window
    handles.hfigLiveCam=figure('MenuBar','none',...
                    'Name','Live Cam',...
                    'Units','pixels',...
                    'Position',[40,350,sizeY.Value+40, sizeX.Value+40],...
                    'Resize','off',...
                    'Visible','on'); 
    
    handles.hAxesLiveCam = axes('Parent', handles.hfigLiveCam,...
                            'Units','pixels',...
                            'Position',[20,20,sizeY.Value, sizeX.Value]);
    setappdata(0, 'LiveCamFigHandle', handles.hfigLiveCam); 

    sizeY.Value;
    sizeX.Value;
    while get(source, 'Value') == 1
        % camera keeps getting refreshed while the camera button is
        % pressed. This will keep Matlab from executing other commands
        
        %% set brightness
        %calllib('octlib', 'setCameraPropertyFloat', octStatus.Device, 'Camera_Brightness', 0);
        
        %% get an image
        calllib('octlib', 'getCameraImage', octStatus.Device, sizeX.Value, sizeY.Value, ColoredData);
        %setdatatype(colored,'C_ColoredDataPtr',sizeX.Value, sizeY.Value)
        setappdata(0,'ColoredData',ColoredData);
        %%%%%
    
        
        
        %%%%%
        [imghdl, b] = calllib('octlib', 'getColoredDataPtr', ColoredData);
        
        setdatatype(imghdl, 'int32Ptr', sizeX.Value, sizeY.Value);
        %% extract RGB
        img2 = uint32(imghdl.Value);
        img3 = double(img2);
        img4 = img3 - floor(img3/256^3)*256^3; %getting rid of alpha channel in ARGB image

        img(:,:,1) = floor(img4/256^2)/256;
        img(:,:,2) = (floor(img4/256)/256 - img(:,:,1)*256);
        img(:,:,3) = (img4/256-img(:,:,2)*256-img(:,:,1)*256^2);
        
        imshow(img,'parent',handles.hAxesLiveCam);
        
        if getappdata(0,'ScanType') == 1
        set(handles.hfigLiveCam,'WindowButtonDownFcn',@ButttonDownFcn);
        end
        
        Scanline = getappdata(0,'Scanline');

        if ishandle(Scanline) == 1
            if getappdata(0,'patternType') == 2
               ScanArea = plot(Scanline.XData,Scanline.YData,'r-','parent',handles.hAxesLiveCam);
            elseif getappdata(0,'patternType') == 3
               Pos = getappdata(0,'Pos');
               ScanArea = rectangle('position',Pos,'EdgeColor','r','parent',handles.hAxesLiveCam);
            end
        end

        pause(0.05);
        refreshNum = refreshNum+1;
        if refreshNum >= 1250
            set(handles.OCT.CamLiveBtn, 'String', 'Live View Camera');
            close(getappdata(0, 'LiveCamFigHandle'))
            break,
        end
        
    end
else
    set(handles.OCT.CamLiveBtn, 'String', 'Live View Camera');
    close(getappdata(0, 'LiveCamFigHandle'))
end
end


    