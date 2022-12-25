%initialize in command line first
% global w_ij w_jk th_i th_j
% K=2;J=3;I=1; %2-3-1 Neural Network
% w_ij=randn(I,J)*0.1;w_jk=randn(J,K)*0.1;
% th_i=randn(I,1)*0.1;th_j=randn(J,1)*0.1;

function u=annc1(x)
global w_ij w_jk th_i th_j
eta=0.04;
% input vector
o_k(1,1)=x(1);
o_k(2,1)=x(2);
% forward pass
h_j=w_jk*o_k-th_j;
o_j=tansig(h_j); % tansig function
h_i=w_ij*o_j-th_i;
o_i=h_i; % linear function

% error signal delta
delta_i=x(1)*1; %
delta_j=(w_ij'*delta_i).*dtansig(h_j,o_j);
% weight updating
w_jk=w_jk+eta*delta_j*o_k';
w_ij=w_ij+eta*delta_i*o_j';
% bias updating
th_j=th_j+eta*delta_j*(-1);
th_i=th_i+eta*delta_i*(-1);
% output
u=o_i;