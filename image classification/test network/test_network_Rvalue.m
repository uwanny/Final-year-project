load cubic_SAW_velocity_models.mat
load label.mat
rng("shuffle");
load 'image classification result combination training'\net.mat
SAW = Crystal(6).velocity;
% prepare the SNR 30 data
%---------------------------------------------
number_of_sample = 1;
target_size1 = [600 600];
target_size2 = [60 60];

%-------------------------------------------------
%prepare SNR data for 360 directions
%-------------------------------------------------
% test_image_SNR10 = noisy_with_alternation(10,number_of_sample,SAW,target_size1,target_size2);
% test_image_SNR30 = noisy_with_alternation(30,number_of_sample,SAW,target_size1,target_size2);
% test_image_SNR20 = noisy_with_alternation(20,number_of_sample,SAW,target_size1,target_size2);
% test_image_SNR40 = noisy_with_alternation(40,number_of_sample,SAW,target_size1,target_size2);
% test_image_SNR50 = noisy_with_alternation(50,number_of_sample,SAW,target_size1,target_size2);
% test_image_SNR60 = noisy_with_alternation(60,number_of_sample,SAW,target_size1,target_size2);
% test_image_SNR70 = noisy_with_alternation(70,number_of_sample,SAW,target_size1,target_size2);
% 
% test_image_SNR30 = reshape(test_image_SNR30,[60 60 1 441]);
% test_image_SNR10 = reshape(test_image_SNR10,[60 60 1 441]);
% test_image_SNR20 = reshape(test_image_SNR20,[60 60 1 441]);
% test_image_SNR40 = reshape(test_image_SNR40,[60 60 1 441]);
% test_image_SNR50 = reshape(test_image_SNR50,[60 60 1 441]);
% test_image_SNR60 = reshape(test_image_SNR60,[60 60 1 441]);
% test_image_SNR70 = reshape(test_image_SNR70,[60 60 1 441]);
% %---------------------------------------------------


%----------------------------------------------------
% prepare SNR data for 73 directions
%----------------------------------------------------
% test_image_SNR10 = noisy_with_alternation_73direction(10,number_of_sample,SAW,target_size1,target_size2);
% test_image_SNR30 = noisy_with_alternation_73direction(30,number_of_sample,SAW,target_size1,target_size2);
% test_image_SNR20 = noisy_with_alternation_73direction(20,number_of_sample,SAW,target_size1,target_size2);
% test_image_SNR40 = noisy_with_alternation_73direction(40,number_of_sample,SAW,target_size1,target_size2);
% test_image_SNR50 = noisy_with_alternation_73direction(50,number_of_sample,SAW,target_size1,target_size2);
% test_image_SNR60 = noisy_with_alternation_73direction(60,number_of_sample,SAW,target_size1,target_size2);
% test_image_SNR70 = noisy_with_alternation_73direction(70,number_of_sample,SAW,target_size1,target_size2);
% 
% test_image_SNR30 = reshape(test_image_SNR30,[60 60 1 441]);
% test_image_SNR10 = reshape(test_image_SNR10,[60 60 1 441]);
% test_image_SNR20 = reshape(test_image_SNR20,[60 60 1 441]);
% test_image_SNR40 = reshape(test_image_SNR40,[60 60 1 441]);
% test_image_SNR50 = reshape(test_image_SNR50,[60 60 1 441]);
% test_image_SNR60 = reshape(test_image_SNR60,[60 60 1 441]);
% test_image_SNR70 = reshape(test_image_SNR70,[60 60 1 441]);
%---------------------------------------------------------

% %predict results
% %---------------------------------------------------

tic
Prediction = classify(network{1},test_image_SNR10);
Accuracy = mean(Prediction == Label);
toc
%---------------------------------------------------
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



figure;
bar(R_value,2);
title('Prediction R-value for SNR 10 data','FontSize',11);
xlabel('Planes','FontSize',11);
ylabel('R-value','FontSize',11);
set(gca, 'LooseInset', [0,0,0,0]);
good = 0;
for i = 1:441
    if R_value(i) < 8
        good = good+1;
    end
end
%set(gca,'LooseInset',get(gca,'Position'));
% figure;
% edges = [0 8:1:30];
% histogram(R_value{1},BinWidth=2);
% hold on;
% histogram(R_value{2},BinWidth=2);
% histogram(R_value{3},BinWidth=2);
% histogram(R_value{4},BinWidth=2);
% histogram(R_value{5},BinWidth=2);
%histogram(R_value{6});
%histogram(R_value{7});







