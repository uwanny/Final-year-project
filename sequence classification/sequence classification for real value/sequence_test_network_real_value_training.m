load cubic_SAW_velocity_models.mat
load network.mat
load nickel_rawdata.mat
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
Real_SAW(isnan(Real_SAW)) = 0;
% create image for testing
%-----------------------------------------
%-----------------------------------------
%testing
%----------------------------------------

tic
Prediction = classify(network{3},Real_SAW(1:360));
toc

Prediction = string(Prediction);
%---------------------------------------------------
%vector_prediction = zeros(1,3);
vector_prediction = str2double(regexp(Prediction,'\d*\.?\d*','match'));
[R_value, ang_phi, ang_tau] = get_R_value(vector_prediction,0, miller(tesing_sample_number,:),0);

