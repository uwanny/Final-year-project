load cubic_SAW_velocity_models.mat
load label.mat
rng("shuffle");
load 'sequence result'\network.mat
SAW = Crystal(6).velocity;
% prepare the SNR 30 data
%---------------------------------------------
number_of_sample = 1;


test_noisy_signal_SNR30 = sequence_make_noise(30,number_of_sample,SAW);

%-------------------------------------------------
%prepare another SNR data
%-------------------------------------------------
test_noisy_signal_SNR40 = sequence_make_noise(40,number_of_sample,SAW);
test_noisy_signal_SNR50 = sequence_make_noise(50,number_of_sample,SAW);
test_noisy_signal_SNR60 = sequence_make_noise(60,number_of_sample,SAW);
test_noisy_signal_SNR70 = sequence_make_noise(70,number_of_sample,SAW);
test_noisy_signal_SNR80 = sequence_make_noise(80,number_of_sample,SAW);


%---------------------------------------------------
%predict results
%---------------------------------------------------
tic
Prediction = classify(network{1},test_noisy_signal_SNR30);
Accuracy = mean(Prediction == Label);
toc
%---------------------------------------------------
