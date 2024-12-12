  
function altered_image = noisy_with_alternation(SNR,number_of_sample,SAW,target_size1,target_size2)
rng('shuffle');
angle_degrees = 0:1:359;
angle_radians = deg2rad(angle_degrees);
SAW_nickel = zeros(441*number_of_sample,360);
%Noisy_image = cell(441*number_of_sample,1);
%cropped_image = cell(441*number_of_sample,1);
%resized_image = cell(441*number_of_sample,1);
%altered_image_cell = cell(441*number_of_sample,1);
altered_image = zeros(target_size2(1),target_size2(2),441*number_of_sample);
m=1;
for i = 1:number_of_sample
    for n = 1:21
        for q = 1:21
            disp(m);
            seed = randi(1e9);
            signal(1:180) = SAW(n,q,1:180);
            noisy_signal(1:180) = awgn(signal(1:180),SNR,'measured',seed);
            SAW_nickel(m,1:180) = noisy_signal;% create the data for polar plot
            SAW_nickel(m,181:360) = SAW_nickel(m,1:180);% create the data for polar plot
            figure(1);
            polarplot(angle_radians,SAW_nickel(m,:),'.','MarkerSize',4);
            ax = gca;
            ax.RTick = [];
            ax.ThetaTick = [];
            Noisy_image = print('-RGBImage');
            %figure(2);
            %imshow(Noisy_image);
            r = centerCropWindow2d(size(Noisy_image),target_size1);
            cropped_image = imcrop(Noisy_image,r);
            % figure(2);
            % imshow(cropped_image);
            resized_image = imresize(cropped_image,target_size2);
            % figure(3);
            % imshow(resized_image);
            altered_image(:,:,m) = im2gray(resized_image);
            figure(2);
            imshow(uint8(altered_image(:,:,m))); 
            clear Noisy_image cropped_image resized_image;
            m = m+1;
        end
    end
end
%delete SAW_nickel Noisy_image cropped_image resized_image altered_image_cell;
end



