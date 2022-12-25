%initialize in command line first
global w_ij w_jk th_i th_j
K=2;J=5;I=1; %2-5-1 Neural Network
w_ij=randn(I,J)*0.1;w_jk=randn(J,K)*0.1;
th_i=randn*0.1;th_j=randn(J,1)*0.1;