load cubic_SAW_velocity_models.mat
load label.mat
load 'image classification result for different SNR'\1.mat
loaded_network = network;
clear network;
rng("shuffle");
SAW = Crystal(6).velocity;
% prepare the SNR 30 data
%---------------------------------------------
number_of_sample = 10;
SNR = 30;
target_size1 = [600 600];
target_size2 = [60 60];
altered_image_SNR30 = noisy_with_alternation(SNR,number_of_sample,SAW,target_size1,target_size2);
%--------------------------------------------------------------------------------------
% create the data label
%--------------------------------------------------------------------------------------
data_label = repmat(Label,number_of_sample,1);
%--------------------------------------------------------------------------------------
randindex = randperm(size(altered_image_SNR30,3));
random_data = altered_image_SNR30(:,:,randindex);
random_label = data_label(randindex,:);
training_data = random_data(:,:,1:441*(number_of_sample-1));
training_label = random_label(1:441*(number_of_sample-1));
validation_data = random_data(:,:,441*(number_of_sample-1)+1:end);
validation_label = random_label(441*(number_of_sample-1)+1:end);
%--------------------------------------------------------------------------------------
training_data1 = reshape(training_data,[60 60 1 441*(number_of_sample-1)]);
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
network{1} = trainNetwork(training_data1,training_label,loaded_network{1}.Layers,options);
for i = 2:20
    disp(i);
    altered_image_SNR30 = noisy_with_alternation(SNR,number_of_sample,SAW,target_size1,target_size2);
    %-------------------------------------------------------------------------
    data_label = repmat(Label,number_of_sample,1);
    %------------------------------------------------------------------------
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




