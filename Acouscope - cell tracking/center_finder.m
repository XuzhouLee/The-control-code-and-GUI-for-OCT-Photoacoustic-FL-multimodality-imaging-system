I=imread('C:\Users\OCT\Desktop\A.png');
I=im2double(I);
%I = rgb2gray(I);
I = wthresh(I,'h',0.30);
BW=imbinarize(I,'global');
[B,L] = bwboundaries(BW,'noholes');
figure;imshow(label2rgb(L, @jet, [.5 .5 .5]))
hold on
x_vec=[0];
y_vec=[0];
for k = 1:length(B)
   boundary = B{k};
   if length(boundary)>10
       plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
       x_ave=sum(boundary(:,1))/(length(boundary));
       x_vec(end+1)=x_ave;
       y_ave=sum(boundary(:,2))/(length(boundary));
       y_vec(end+1)=y_ave;
   end
end
x_vec=x_vec(2:end);
y_vec=y_vec(2:end);
 scatter(y_vec,x_vec,100)
x_vec=(x_vec-128)*1.5/256
y_vec=(y_vec-128)*1.5/256

setappdata(0, 'xtrack', x_vec);
setappdata(0, 'ytrack', y_vec);
setappdata(0, 'tnumber', length(x_vec));
