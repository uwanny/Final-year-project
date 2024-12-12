load cubic_SAW_velocity_models.mat
load label.mat
rng("shuffle");
load 'image classification result combination training'\net.mat
SAW = Crystal(6).velocity;
% prepare the SNR 30 data
%---------------------------------------------
number_of_sample = 1;
SNR = 30;
target_size1 = [600 600];
target_size2 = [60 60];
test_image_SNR30 = noisy_with_alternation(SNR,number_of_sample,SAW,target_size1,target_size2);

%-------------------------------------------------
%prepare another SNR data
%-------------------------------------------------
test_image_SNR40 = noisy_with_alternation(40,number_of_sample,SAW,target_size1,target_size2);
test_image_SNR50 = noisy_with_alternation(50,number_of_sample,SAW,target_size1,target_size2);
test_image_SNR60 = noisy_with_alternation(60,number_of_sample,SAW,target_size1,target_size2);
test_image_SNR70 = noisy_with_alternation(70,number_of_sample,SAW,target_size1,target_size2);

test_image_SNR30 = reshape(test_image_SNR30,[60 60 1 441]);
test_image_SNR40 = reshape(test_image_SNR40,[60 60 1 441]);
test_image_SNR50 = reshape(test_image_SNR50,[60 60 1 441]);
test_image_SNR60 = reshape(test_image_SNR60,[60 60 1 441]);
test_image_SNR70 = reshape(test_image_SNR70,[60 60 1 441]);
%---------------------------------------------------
%predict results
%---------------------------------------------------
tic
Prediction = classify(network{1},test_image_SNR70);
Accuracy = mean(Prediction == Label);
toc
%---------------------------------------------------
