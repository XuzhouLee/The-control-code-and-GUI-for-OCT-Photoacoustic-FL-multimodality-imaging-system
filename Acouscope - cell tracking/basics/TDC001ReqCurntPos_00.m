
function PosDeg = TDC001ReqCurntPos_00(wvplt)
    % function to get current position from controller    
    
    src = '01'; %source generic USB device (Thorlabs RS232 doc)
    dest = '50'; %destination
    CHAN_IDENT =  '00';
    
    %% scaling factors going from APT units (steps per s) to physical units (deg/sec)
    T = 2048 / (6 * 1e6); % Time constant for TDC001 (Thorlabs RS232 documentation)
    EncCnt = 1919.64; % Stage scaling rfactor for PRM1Z8 (from Thorlabs RS232 documentation)
    POS_APT_Fctr = EncCnt; % APT_Pos = POS_APT_Fctr * Physical Pos
    VEL_APT_Fctr = EncCnt * T * 65536;
    ACC_APT_Fct = EncCnt * T^2 * 65536;
    numBits = 'uint32';
    
    %% request current position
    %disp('requesting current position');

    %% flush the buffer
    if wvplt.BytesAvailable() ~= 0
        fread(wvplt, wvplt.BytesAvailable()); %flush the buffer
    end
    reqposcntrmsg = hex2dec({'11','04','00','00',dest, src});
    fwrite(wvplt, reqposcntrmsg)
    out = fread(wvplt, 12); %reading the message back from the buffer
    val = 0;
    for i=1:4, val = val+out(8+i)*256^(i-1);end %converting the last 4 bytes to 32 bit dec
    %val
    val2C = TwosComplement(val, numBits); %take the two's compliment of the number
    val2CMod = mod(val2C, 360*EncCnt); % Modulo 360
    PosDeg = val2CMod/EncCnt;
end