function ButttonDownFcn(src,event)
point = getappdata(0, 'point');
octStatus = getappdata(0, 'octStatus');
ColoredData = getappdata(0,'ColoredData');

PosX = libpointer('doublePtr', 0);
PosY = libpointer('doublePtr', 0);

currentPosition = get(gca,'CurrentPoint');
y = currentPosition(1,2);
x = currentPosition(1,1);


if point == 0
    if x>0 & x<=480 & y>0 & y<=640
    point = 1;
    setappdata(0, 'point',point);
    setappdata(0, 'x',currentPosition(1,1));
    setappdata(0, 'y',currentPosition(1,2));
    calllib('octlib', 'CameraPixelToPosition', octStatus.Probe, ColoredData, currentPosition(1,2), currentPosition(1,1), PosX, PosY);
    setappdata(0,'PosXa',PosX.value);
    setappdata(0,'PosYa',PosY.value);
    X1 = PosX.value
    Y1 = PosY.value

    end   
elseif point == 1
    if x>0 & x<=480 & y>0 & y<=640
    point = 0;
    setappdata(0, 'point',point);
    A = [getappdata(0, 'x'),currentPosition(1,1)];
    B =[getappdata(0, 'y'),currentPosition(1,2)];
    calllib('octlib', 'CameraPixelToPosition', octStatus.Probe, ColoredData, currentPosition(1,2), currentPosition(1,1),PosX, PosY);
    setappdata(0,'PosXb',PosX.value);
    setappdata(0,'PosYb',PosY.value);
    X2 = PosX.value
    Y2 = PosY.value
    Scanline = getappdata(0,'Scanline');
    delete(Scanline);
    hold on
    if getappdata(0,'patternType') == 2
        Scanline = plot(A,B,'r-');
        setappdata(0, 'Scanline',Scanline);
    elseif getappdata(0,'patternType') == 3
        minX = min(getappdata(0, 'x'),currentPosition(1,1));
        minY = min(getappdata(0, 'y'),currentPosition(1,2));
        Xlength = abs(getappdata(0, 'x')-currentPosition(1,1));
        Ylength = abs(getappdata(0, 'y')-currentPosition(1,2));
        Pos = [minX minY Xlength Ylength];
        setappdata(0,'Pos',Pos);
        Scanline = rectangle('position',Pos,'EdgeColor','r');
        setappdata(0, 'Scanline',Scanline);
    A = [];
    B = [];
    end
    end
end
end
