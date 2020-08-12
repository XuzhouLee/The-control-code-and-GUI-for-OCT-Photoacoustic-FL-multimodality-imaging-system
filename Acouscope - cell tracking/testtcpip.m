clc
tcpipServer = tcpip('0.0.0.0',55000,'NetworkRole','Server');
data = [1,2,3];
data = uint8(data);

if strcmp(tcpipServer.Status, 'open')
    disp('connection already open')
    fclose(tcpipServer)
end

fopen(tcpipServer);

a = 1;

while a
    
    data = input('enter array of size 3');
    fwrite(tcpipServer, data, 'uint8');

    disp('waiting for client to receive')

    while 1
        if tcpipServer.BytesAvailable > 0
            flag = fread(tcpipServer, 1, 'uint8')
            if flag == 1
                disp('data received')
                break
            end
        else
            disp('waiting for data to be received')
            pause(3);
        end


    end

    disp('waiting for later')
    disp('data read')

    a = input('press 1 to continue')
end

disp('closing connection')
fclose(tcpipServer)