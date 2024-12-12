
function altered_image = Real_data_to_image(SAW,target_size1,target_size2)
angle_degrees = 0:1:359;
angle_radians = deg2rad(angle_degrees);
SAW_nickel = zeros(360,1);
%Noisy_image = cell(441*number_of_sample,1);
%cropped_image = cell(441*number_of_sample,1);
%resized_image = cell(441*number_of_sample,1);
%altered_image_cell = cell(441*number_of_sample,1);
SAW_nickel(1:360) = SAW(1:360);% create the data for polar plot
figure(1);
polarplot(angle_radians,SAW_nickel,'.','MarkerSize',4);
ax = gca;
ax.RTick = [];
ax.ThetaTick = [];
Noisy_image = print('-RGBImage');
%figure(2);
%imshow(Noisy_image{m});
r = centerCropWindow2d(size(Noisy_image),target_size1);
cropped_image = imcrop(Noisy_image,r);
%figure(2);
%imshow(cropped_image{i});
resized_image = imresize(cropped_image,target_size2);
%figure(2);
%imshow(resized_image{i});
altered_image = im2gray(resized_image);
figure(2);
imshow(uint8(altered_image)); 
clear Noisy_image cropped_image resized_image;
%delete SAW_nickel Noisy_image cropped_image resized_image altered_image_cell;
end



