  
  
function noisy_signal = noise_to_signal(SNR,number_of_sample,SAW)
rng('shuffle');
noisy_signal = cell(441*number_of_sample,1);
signal = zeros(180,1);
m=1;
for i = 1:number_of_sample
    for n = 1:21
        for q = 1:21
            disp(m);
            seed = randi(1e9);
            signal(1:180) = SAW(n,q,1:180);
            noisy_signal{m} = awgn(signal,SNR,'measured',seed);
            m = m+1;
        end
    end
end
%delete SAW_nickel Noisy_image cropped_image resized_image altered_image_cell;
end






