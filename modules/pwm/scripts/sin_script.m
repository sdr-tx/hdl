%% Script summary
% An analog signal(sig_an) of frequency (f) is sampled at (fs)
% Then it's quantified with steps(d_step) and obtain (sig_q)
% Finally the number of each sample would represent the duty of the PWM signal(pwm)

clear 
clc

fs = 1e6; 									% Sampling frequency
f  = 5e3; 									% Message frequency


B = 6; 	  									% Number of bits
N = 1000;  									% Length of signal
t = (0:(N-1))*(1/fs); 


sig_an  = sin(2*pi*f*t);                    % Input signal
sig_an= sig_an./(max(sig_an)*2) + 0.5;      % Normalization of the signal between -1;+1
d_step  = max(sig_an)/(2^B-1);              % Quantization step value
sig_q   = round(sig_an/d_step);             % Quatification of the signal


pwm=[];

fid_bin = fopen('data_pwm_bits.dat','wt');
fid_dec = fopen('data_pwm_dec.dat','wt');

for(i=1:1:N)
		aux(1:sig_q(i))=ones();           
    aux(1+sig_q(i):(2^B))=zeros();
    pwm=[pwm; sprintf('%d', aux)]; 
    
    fprintf(fid_dec, '%d\n',sig_q(i));
    fprintf(fid_bin, '%s\n',pwm(i,:));

end

%display(pwm)

fclose(fid_bin);
fclose(fid_dec);