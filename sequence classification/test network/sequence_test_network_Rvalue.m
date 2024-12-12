load cubic_SAW_velocity_models.mat
load label.mat
rng("shuffle");
load 'sequence result'\network.mat
SAW = Crystal(6).velocity;
% prepare the SNR 30 data
%---------------------------------------------
number_of_sample = 1;



%-------------------------------------------------
%prepare testing SNR data
%-------------------------------------------------
test_noisy_signal_SNR10 = sequence_make_noise(10,number_of_sample,SAW);
test_noisy_signal_SNR20 = sequence_make_noise(20,number_of_sample,SAW);
test_noisy_signal_SNR30 = sequence_make_noise(30,number_of_sample,SAW);
test_noisy_signal_SNR40 = sequence_make_noise(40,number_of_sample,SAW);
test_noisy_signal_SNR50 = sequence_make_noise(50,number_of_sample,SAW);
test_noisy_signal_SNR60 = sequence_make_noise(60,number_of_sample,SAW);
test_noisy_signal_SNR70 = sequence_make_noise(70,number_of_sample,SAW);
test_noisy_signal_SNR80 = sequence_make_noise(80,number_of_sample,SAW);
%---------------------------------------------------
tic
Prediction = classify(network{4},test_noisy_signal_SNR20);
Accuracy = mean(Prediction == Label);
toc
%-------------------------------------------------------------------
Prediction = cellstr(Prediction);
Label = cellstr(Label);
vector_prediction = zeros(441,3);
vector_label = zeros(441,3);
R_value = zeros(441,1);
ang_phi = zeros(441,1);
ang_tau = zeros(441,1);
for i = 1:441
    vector_prediction(i,:) = str2double(regexp(Prediction{i},'\d*\.?\d*','match'));
    vector_label(i,:) = str2double(regexp(Label{i},'\d*\.?\d*','match'));
    [R_value(i), ang_phi(i), ang_tau(i)] = get_R_value(vector_prediction(i,:),0, vector_label(i,:),0);
end

bar(R_value,2);
title('Prediction R-value for SNR 60 data','FontSize',11);
xlabel('Planes','FontSize',11);
ylabel('R-value','FontSize',11);
set(gca, 'LooseInset', [0,0,0,0]);
good = 0;
for i = 1:441
    if R_value(i) < 8
        good = good+1;
    end
end










