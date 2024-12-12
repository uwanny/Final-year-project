load cubic_SAW_velocity_models.mat
load label.mat
rng("shuffle");
SAW = Crystal(6).velocity;
number_of_sample = 100;
total_sample = number_of_sample*7;
% prepare the SNR 30 40 50 60 70 ... data 8 samples
%---------------------------------------------
SNR = 70;
noisy_signal_SNR70 = sequence_make_noise_for_real_value(SNR,number_of_sample,SAW);
SNR = 60;
noisy_signal_SNR60 = sequence_make_noise_for_real_value(SNR,number_of_sample,SAW);
SNR = 50;
noisy_signal_SNR50 = sequence_make_noise_for_real_value(SNR,number_of_sample,SAW);
SNR = 40;
noisy_signal_SNR40 = sequence_make_noise_for_real_value(SNR,number_of_sample,SAW);
SNR = 30;
noisy_signal_SNR30 = sequence_make_noise_for_real_value(SNR,number_of_sample,SAW);
SNR = 20;
noisy_signal_SNR20 = sequence_make_noise_for_real_value(SNR,number_of_sample,SAW);
SNR = 10;
noisy_signal_SNR10 = sequence_make_noise_for_real_value(SNR,number_of_sample,SAW);

%--------------------------------------------------------------------------------------
noisy_signal = cat(1,noisy_signal_SNR70,noisy_signal_SNR60,noisy_signal_SNR50,noisy_signal_SNR40,noisy_signal_SNR30, ...
   noisy_signal_SNR20,noisy_signal_SNR10);
clear noisy_signal_SNR70 noisy_signal_SNR60 noisy_signal_SNR50 noisy_signal_SNR40 noisy_signal_SNR30 ...
noisy_signal_SNR20 noisy_signal_SNR10;
%--------------------------------------------------------------------------------------
% create the data label
%--------------------------------------------------------------------------------------
data_label = repmat(Label,total_sample,1);
%--------------------------------------------------------------------------------------
randindex = randperm(size(noisy_signal,1));
random_data = noisy_signal(randindex);
random_label = data_label(randindex);
training_data = random_data(1:441*(total_sample-1));
training_label = random_label(1:441*(total_sample-1));
validation_data = random_data(441*(total_sample-1)+1:end);
validation_label = random_label(441*(total_sample-1)+1:end);
%--------------------------------------------------------------------------------------

%-------------------------------------------------------------------------------------
network = cell(100,1);
inputSize = 360;
numClasses = 442;
filterSize = 3;
numFilters = 32;

layers = [
    sequenceInputLayer(inputSize)

    convolution1dLayer(filterSize,numFilters,Padding="causal")
    reluLayer
    layerNormalizationLayer
    

    convolution1dLayer(filterSize,2*numFilters,Padding="causal")
    reluLayer
    layerNormalizationLayer
    

    globalAveragePooling1dLayer
    %dropoutLayer(0.5)
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];
options = trainingOptions("adam","MaxEpochs",150,"MiniBatchSize",128,"Shuffle","every-epoch","Plots","training-progress", ...
    "InitialLearnRate",0.001,"Verbose",true, ...
    "VerboseFrequency",25,"ValidationData",{validation_data,validation_label},"ValidationFrequency",25,"L2Regularization",0.01,...
 "OutputNetwork","best-validation-loss");
network{1} = trainNetwork(training_data,training_label,layers,options);
for i = 2:20
    disp(i);
    SNR = 70;
    noisy_signal_SNR70 = sequence_make_noise_for_real_value(SNR,number_of_sample,SAW);
    SNR = 60;
    noisy_signal_SNR60 = sequence_make_noise_for_real_value(SNR,number_of_sample,SAW);
    SNR = 50;
    noisy_signal_SNR50 = sequence_make_noise_for_real_value(SNR,number_of_sample,SAW);
    SNR = 40;
    noisy_signal_SNR40 = sequence_make_noise_for_real_value(SNR,number_of_sample,SAW);
    SNR = 30;
    noisy_signal_SNR30 = sequence_make_noise_for_real_value(SNR,number_of_sample,SAW);
    SNR = 20;
    noisy_signal_SNR20 = sequence_make_noise_for_real_value(SNR,number_of_sample,SAW);
    SNR = 10;
    noisy_signal_SNR10 = sequence_make_noise_for_real_value(SNR,number_of_sample,SAW);
    %-------------------------------------------------------------------------
    noisy_signal = cat(1,noisy_signal_SNR70,noisy_signal_SNR60,noisy_signal_SNR50,noisy_signal_SNR40,noisy_signal_SNR30, ...
   noisy_signal_SNR20,noisy_signal_SNR10);
    clear noisy_signal_SNR70 noisy_signal_SNR60 noisy_signal_SNR50 noisy_signal_SNR40 noisy_signal_SNR30 ...
    noisy_signal_SNR20 noisy_signal_SNR10;
    %---------------------------------------------------------------------------
    data_label = repmat(Label,total_sample,1);
    %---------------------------------------------------------------------------
    randindex = randperm(size(noisy_signal,1));
    random_data = noisy_signal(randindex);
    random_label = data_label(randindex);
    training_data = random_data(1:441*(total_sample-1));
    training_label = random_label(1:441*(total_sample-1));
    validation_data = random_data(441*(total_sample-1)+1:end);
    validation_label = random_label(441*(total_sample-1)+1:end);
    %-------------------------------------------------------------------------

    network{i} = trainNetwork(training_data,training_label,network{i-1}.Layers,options);
end




