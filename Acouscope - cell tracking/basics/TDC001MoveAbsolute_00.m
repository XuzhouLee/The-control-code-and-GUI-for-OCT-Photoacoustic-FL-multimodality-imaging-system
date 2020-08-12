function TDC001MoveAbsolute_00(wvplt, angle)
    % function to get to move APT to a specific angle    

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
    angle;
    angle = real(mod(angle, 360)); %angles can be anything modulo 360
    CurntAngle = TDC001ReqCurntPos_00(wvplt); %current angle position in decimal
    setappdata(0, 'CurntAngle', CurntAngle);
    if (CurntAngle > 180)
        CurntAngle = 360-CurntAngle;
    end

    
    %Val = TwosComplement(Val2CMod, numBits);
    
    if abs(angle - CurntAngle) <= 180
        Val = round(angle*EncCnt); %position in terms of APT encoder counts
        PosHex = dec2hex(Val, 8); %convert to 8-byte hex
        PosByte1 = PosHex(7:8); %LSB. Check APT Manual
        PosByte2 = PosHex(5:6);
        PosByte3 = PosHex(3:4);
        PosByte4 = PosHex(1:2); %MSB
    else
        angle = 360-angle; % when angle >180 go the opposite direction (- angle); here angle is the absolute value of the neavite angle
        Val = round(angle*EncCnt); %absolute value of position in terms of APT encoder counts
        Val2N = bitcmp(Val,numBits)+1;      
        PosHex = dec2hex(Val2N, 8); %convert to 8-byte hex
        PosByte1 = PosHex(7:8); %LSB
        PosByte2 = PosHex(5:6);
        PosByte3 = PosHex(3:4);
        PosByte4 = PosHex(1:2); %MSB
    end
    
    %% move to target position. Afrom APT manual (https://drive.google.com/open?id=0B2EexJuTHv9QRjU0azhxQ0VlY0U)
    MoveAbsolutemsg = hex2dec({'53','04','06','00','D0', src,'01','00',PosByte1,PosByte2,PosByte3,PosByte4});
    %% flush the buffer
    if wvplt.BytesAvailable() ~= 0
        fread(wvplt, wvplt.BytesAvailable()); %flush the buffer
    end
    
    fwrite(wvplt, MoveAbsolutemsg);
    MvCmpleMsg = fread(wvplt, 20);
    CurntAngle = TDC001ReqCurntPos_00(wvplt); %current angle position in decimal
    setappdata(0, 'CurntAngle', CurntAngle);
      
    
    
end