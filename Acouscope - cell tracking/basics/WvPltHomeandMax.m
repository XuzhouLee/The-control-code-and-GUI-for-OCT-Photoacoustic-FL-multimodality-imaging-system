function WvPltHomeandMax(wvplt)
    
    %% set motor velocity params
    % set velocity to 25 deg/sec and acceleration to 25deg/sec/sec
    % HEX commands are from APT controller manual - Serial com
    % can be found at: https://drive.google.com/open?id=0B2EexJuTHv9QRjU0azhxQ0VlY0U
    setvelparamsmsg = hex2dec({'13','04','0E','00','D0','01',...
                               '01','00','00','00','00','00',...
                               '6E','01','00','00','84','61','10','00'});

    fwrite(wvplt, setvelparamsmsg);

    % %% go home to reset counter
    disp('Resetting Waveplate Encoder Counter')
    gohome = hex2dec({'43','04','00','00','50', '01'});
    fwrite(wvplt,gohome);
    pause (5);

    % go to angle for default start transmission as set in Params_init.m
    FrcInit = getappdata(0, 'StartEnrgFraction');
    fprintf('Setting Waveplate Angle to %5.4f transmission\n', FrcInit)
    SetLsrTransWP_00(wvplt, FrcInit);
    pause(5);
end