load cubic_SAW_velocity_models.mat
load label.mat
rng("shuffle");
SAW = Crystal(6).velocity;
target_size1 = [600 600];
target_size2 = [60 60];
number_of_sample = 5;
total_sample = number_of_sample*8;
% prepare the SNR 30 40 50 60 70 ... data 8 samples
%---------------------------------------------
SNR = 10;
altered_image_SNR10 = noisy_with_alternation(SNR,number_of_sample,SAW,target_size1,target_size2);
SNR = 20;
altered_image_SNR20 = noisy_with_alternation(SNR,number_of_sample,SAW,target_size1,target_size2);
SNR = 30;
altered_image_SNR30 = noisy_with_alternation(SNR,number_of_sample,SAW,target_size1,target_size2);
SNR = 40;
altered_image_SNR40 = noisy_with_alternation(SNR,number_of_sample,SAW,target_size1,target_size2);
SNR = 50;
altered_image_SNR50 = noisy_with_alternation(SNR,number_of_sample,SAW,target_size1,target_size2);
SNR = 60;
altered_image_SNR60 = noisy_with_alternation(SNR,number_of_sample,SAW,target_size1,target_size2);
SNR = 70;
altered_image_SNR70 = noisy_with_alternation(SNR,number_of_sample,SAW,target_size1,target_size2);
SNR = 80;
altered_image_SNR80 = noisy_with_alternation(SNR,number_of_sample,SAW,target_size1,target_size2);
%--------------------------------------------------------------------------------------
altered_image = cat(3,altered_image_SNR80,altered_image_SNR70,altered_image_SNR60,altered_image_SNR50,altered_image_SNR40, ...
   altered_image_SNR30,altered_image_SNR20,altered_image_SNR10);
clear altered_image_SNR10 altered_image_SNR20 altered_image_SNR30 altered_image_SNR40 altered_image_SNR50 ...
altered_image_SNR60 altered_image_SNR70 altered_image_SNR80;
%--------------------------------------------------------------------------------------
% create the data label
%--------------------------------------------------------------------------------------
data_label = repmat(Label,total_sample,1);
%--------------------------------------------------------------------------------------
randindex = randperm(size(altered_image,3));
random_data = altered_image(:,:,randindex);
random_label = data_label(randindex,:);
training_data = random_data(:,:,1:441*(total_sample-1));
training_label = random_label(1:441*(total_sample-1));
validation_data = random_data(:,:,441*(total_sample-1)+1:end);
validation_label = random_label(441*(total_sample-1)+1:end);
%--------------------------------------------------------------------------------------
training_data1 = reshape(training_data,[60 60 1 441*(total_sample-1)]);
validation_data1 = reshape(validation_data,[60 60 1 441]);
clear training_data validation_data;
%-------------------------------------------------------------------------------------
network = cell(100,1);
inputSize = [60 60];
numClasses = 442;
layers = [
    imageInputLayer(inputSize)

    convolution2dLayer(5,20)
    batchNormalizationLayer
    reluLayer
    %maxPooling2dLayer(2,'Stride',2)

    convolution2dLayer(5,40)
    batchNormalizationLayer
    reluLayer
    %maxPooling2dLayer(2,'Stride',2)

    convolution2dLayer(5,80)
    batchNormalizationLayer
    reluLayer
    %maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,20)
    batchNormalizationLayer
    reluLayer
    %maxPooling2dLayer(2,'Stride',2)

    convolution2dLayer(3,40)
    batchNormalizationLayer
    reluLayer
    %maxPooling2dLayer(2,'Stride',2)

    convolution2dLayer(3,80)
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)

    dropoutLayer(0.5)
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];
options = trainingOptions("adam","MaxEpochs",150,"MiniBatchSize",64,"Shuffle","every-epoch","Plots","training-progress", ...
    "InitialLearnRate",0.0001,"Verbose",true, ...
    "VerboseFrequency",25,"ValidationData",{validation_data1,validation_label},"ValidationFrequency",25,"L2Regularization",0.01,...
 "OutputNetwork","best-validation-loss");
network{1} = trainNetwork(training_data1,training_label,layers,options);
for i = 2:20
    disp(i);
    altered_image_SNR30 = noisy_with_alternation(SNR,number_of_sample,SAW,target_size1,target_size2);
    %-------------------------------------------------------------------------
    randindex = randperm(size(altered_image_SNR30,3));
    random_data = altered_image_SNR30(:,:,randindex);
    random_label = data_label(randindex,:);
    training_data = random_data(:,:,1:441*(number_of_sample-1));
    training_label = random_label(1:441*(number_of_sample-1));
    validation_data = random_data(:,:,441*(number_of_sample-1)+1:end);
    validation_label = random_label(441*(number_of_sample-1)+1:end);
    %-------------------------------------------------------------------------
    training_data1 = reshape(training_data,[60 60 1 441*(number_of_sample-1)]);
    validation_data1 = reshape(validation_data,[60 60 1 441]);
    clear training_data validation_data;
    network{i} = trainNetwork(training_data1,training_label,network{i-1}.Layers,options);
end




