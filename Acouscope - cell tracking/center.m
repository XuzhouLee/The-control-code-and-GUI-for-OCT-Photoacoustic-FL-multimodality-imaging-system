function [x_vec,y_vec] = center(I,threshold?contoursize)
BW=imbinarize(I,'adaptive','Sensitivity',threshold);
[B,L] = bwboundaries(BW,'noholes');
x_vec=[0];
y_vec=[0];
for k = 1:length(B)
   boundary = B{k};
   if length(boundary)>50
       x_ave=sum(boundary(:,2))/(length(boundary));
       x_vec(end+1)=x_ave;
       y_ave=sum(boundary(:,1))/(length(boundary));
       y_vec(end+1)=y_ave;
   end
end
x_vec=x_vec(1:end);
y_vec=y_vec(1:end);
end

