function setScanTypeBtn_Callback(src, event, handles)
    patternType = get(src, 'Value');
    if patternType == 3
        if getappdata(0,'ScanType')== 0
           set(handles.PAM.HScanRangeEdt,'enable','on');
           set(handles.PAM.HScanPtsEdt,'enable','on');
        end
        set(handles.PAM.HScanPtsEdt,'string','128');
        setappdata(0, 'ScanRows', 128);
        set(handles.PAM.WScanPtsEdt,'enable','on');
        set(handles.PAM.WScanRangeEdt,'enable','on');
        set(handles.PAM.ScanAxisEdt,'enable','on');
        set(handles.PAM.freeScanBtn,'enable','on');
    elseif patternType == 1
        set(handles.PAM.HScanRangeEdt,'enable','off');
        set(handles.PAM.HScanPtsEdt,'enable','off');
        set(handles.PAM.WScanPtsEdt,'enable','off');
        set(handles.PAM.WScanRangeEdt,'enable','off');
        set(handles.PAM.ScanAxisEdt,'enable','off');
        set(handles.PAM.freeScanBtn,'enable','off');
    elseif patternType == 2
%         set(handles.PAM.HScanRangeEdt,'enable','off');
        set(handles.PAM.HScanRangeEdt,'string','0');
        setappdata(0, 'HScanRange', 0);
%         set(handles.PAM.HScanPtsEdt,'enable','off');
        setappdata(0, 'ScanRows', 1);
        set(handles.PAM.HScanPtsEdt,'string','1');
        set(handles.PAM.WScanPtsEdt,'enable','on');
        set(handles.PAM.WScanRangeEdt,'enable','on');
        set(handles.PAM.ScanAxisEdt,'enable','on');
        set(handles.PAM.freeScanBtn,'enable','on');
    end
    if patternType == 3
        setappdata(0, 'patternType', 3);
    elseif patternType == 2
        setappdata(0, 'patternType', 2);
    elseif patternType == 1
        setappdata(0, 'patternType', 1);
    end
end