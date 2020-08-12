function EnergyCalib(src, event, handles)

% % function to calibrate energy. 
% Calibrate Energy: The laser pulse energy is controlled by rotating the laser polarization via a waveplate. The laser transmission through a polarizer mounted after the waveplate, allows for a fraction of the laser energy to be transmitted.While the rotation mount position that corresponds to MIN energy transmission does not change, the rotation mount encoder value may change after computer restarts or after the motor controller is unplugged. For this, we need to obtain the new encoder values (or angular position) that corresponds to the MIN energy transmission. This calibration can be done as follows:
% 1- set the laser wavelength to 532nm
% 2- install the diode power meter S121C and center it on the beam after the beam telescope
% 3- Start the Thorlabs Optical Power Meter Utility and select the power sensor:
% 	- make sure wavelength is set to 532nm
% - make sure that the sensor is zeroed with the laser shutter closed
% 4- Open the laser shutter and manually move the rotation stage (from the buttons on the motor controller) until the energy is close to MIN   
% 5- On the Acouscope GUI, click Calibrate Energy.
% 6- Wait for MATLAb to acquire 40 measurements around the tentative MIN
% 7- Once matlab is done, it will plot the data. Ignore outliers. Look for the transmission MIN by zooming in on the plot MIN. Record the MIN angle value (horizontal axis).
% 8- Open the file Acouscope/GUI/Params_Init.m and update the value for MinAngle.
% 9- Close Acouscope and start it again. No need to restart Matlab.
% 10- Verify that the Fractional Calibration Slider is working by testing the extreme and mid energy levels and measuring the power with the Thorlabs Utility.

uiwait(msgbox('Set up the Thorlabs PM100USB meter and manually move the waveplate to near minimum.','Success','modal'));


wavelength = 532;
setOPOWavelength(handles, wavelength);
pause(2);
% averaging
samples = 1;
incrementNum = 20;
angleScan = 10;% range to scan around the guess minimum

% Find a VISA-USB object. The Power Meter
powermeter = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x1313::0x8072::P2006096::0::INSTR', 'Tag', '');

% Create the VISA-USB object if it does not exist
% otherwise use the object that was found.
if isempty(powermeter)
    powermeter = visa('NI', 'USB0::0x1313::0x8072::P2006096::0::INSTR');
else
    fclose(powermeter);
    powermeter = powermeter(1);
end

% Connect to instrument object, obj1.
fopen(powermeter);

% Get background
bkgrd = 0;

for i=1:samples
    bkgrd = bkgrd + str2num(query(powermeter, 'MEASure:POWer?'));
end
bkgrd = bkgrd/samples;



%get current waveplate angle
currentPosDeg = TDC001ReqCurntPos_00(handles.wvplt);   
degIncrement = angleScan/ incrementNum;   

PosDeg = zeros(1, 2*incrementNum+1);

openLaserShutter(handles);
for i=1:2*incrementNum+1 % iterate over all angles around the guess MIN
    % go to next waveplate angle pos
    PosDeg(i) = currentPosDeg - angleScan + (i-1) *  degIncrement;
    newPosDeg =   PosDeg(i);
    disp(['measuring position ', num2str(i), ' of ', num2str(2*incrementNum+1)])
    TDC001MoveAbsolute_00(handles.wvplt, newPosDeg);
    pause(1);
    %% measure using power meter
    tpower = 0;
    for j=1:samples
        powerString = [];
        while (isempty(powerString) || str2num(powerString) > 1 || str2num(powerString) < 0)
            powerString = query(powermeter, 'MEASure:POWer?');
        end
        
        tpower = tpower + str2num(powerString);
        pause(.5);
    end
    tempower = tpower/samples - bkgrd;
    power(i) = tempower;
    

end

closeLaserShutter(handles);

figure(153)

plot(PosDeg, power)    


uiwait(msgbox('From the plot, determine minimum position in degrees and enter it as MinAngle in Params_init.m','Success','modal'));


% Disconnect from instrument object, obj1.
fclose(powermeter);

end