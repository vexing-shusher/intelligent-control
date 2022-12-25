function u = fsmc(X)
x = X(1); xdot = X(2); % input x, xdot
global sbar sigma theta
lamda = 2; %controller parameter
x1d = 0; x2d = 0; %desired response
s = (x2d - xdot)+lamda*(x1d-x); %sliding surface
if s > 4
    s = 4;
elseif s < -4
    s = -4;
end
for i = 1:7 %fuzzy partition 7
    mu(i)=exp(-0.5*((s-sbar(i))/sigma(i))^2);
end
sum_mu = sum(mu);%total sum of firing strength
u = mu*theta'/sum_mu; %controller output
if u > 30
    u = 30;
elseif u <-30
    u = -30;
end

%run in console:
%global sbar sigma theta
%sbar = [-4 -8/3 -4/3 0 4/3 8/3 4];
%sigma = [0.2 0.2 0.2 0.2 0.2 0.2 0.2];
%theta = [-30 -60/3 -30/3 0 30/3 60/3 30];



