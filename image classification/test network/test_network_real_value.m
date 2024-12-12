load nickel_rawdata.mat
load label.mat
load 'image classification result combination training'\net.mat
tesing_sample_number = 13;
%create test array
%-----------------------------------------
Real_SAW = zeros(361,1);
i = 1;
m = 1;
while i < 362
    Real_SAW(i) = vel_360(tesing_sample_number,m);
    i = i+5;
    m = m+1;
end
Real_SAW(Real_SAW == 0) = NaN; 
% create image for testing
%-----------------------------------------
image = real_data_to_image(Real_SAW,[600 600],[60 60]);
image = reshape(image,[60 60 1]);
%-----------------------------------------
%testing
%----------------------------------------
tic
Prediction = classify(network{1},image);
toc
Prediction = string(Prediction);
%---------------------------------------------------
%vector_prediction = zeros(1,3);
vector_prediction = str2double(regexp(Prediction,'\d*\.?\d*','match'));
[R_value, ang_phi, ang_tau] = get_R_value(vector_prediction,0, miller(tesing_sample_number,:),0);

