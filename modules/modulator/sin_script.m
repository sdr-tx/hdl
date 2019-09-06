%% Script summary
% An analog signal(sig_an) of frequency (f) is sampled at (fs)
% Then it's quantified with steps(d_step) and obtain (sig_q)
% Finally the number of each sample would represent the duty of the PWM signal(pwm)

clear 
clc

fs = 1e6; 									% Sampling frequency
f  = 10e3; 									% Message frequency

B = 6; 	  									% Number of bits
N = 100;  									% Length of signal
t = (0:(N-1))*(1/fs); 

sig_an  = 0.5 * sin(2*pi*f*t)+0.5;
d_step  = max(sig_an)/(2^B-1);
sig_q   = round(sig_an/d_step);


pwm=[];

for(i=1:1:N)
		aux(1:sig_q(i))=ones();           
    aux(1+sig_q(i):(2^B))=zeros();
    pwm=[pwm; sprintf('%d', aux)]; 
end

display(pwm)

