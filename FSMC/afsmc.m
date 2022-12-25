function u = afsmc(X)
x = X(1); xdot = X(2); % input x, xdot
global sbar sigma theta
lamda = 2; %controller parameter
gamma = 0.001; %learning rate
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

%update law
for i=1:7
    sbar(i) = sbar(i) + gamma * s * ((theta(i) - u)/sum_mu) * mu(i) * (s - sbar(i))/(sigma(i))^2;

    %apply bounding conditions
    if sbar(i) > 4
        sbar(i) = 4;
    elseif sbar(i) < -4
        sbar(i) = -4;
    end


    sigma(i) = sigma(i) + gamma * s * ((theta(i) - u)/sum_mu) * (s - sbar(i))^2/(sigma(i))^3;

    %apply bounding conditions
    if sigma(i) > 0.4
        sigma(i) = 0.4;
    elseif sigma(i) < 0.01
        sigma(i) = 0.01;
    end

    theta(i) = theta(i) + gamma * s * mu(i) / sum_mu;

    %apply bounding conditions
    if theta(i) > 30
        theta(i) = 30;
    elseif theta(i) < -30
        theta(i) = -30;
    end

end

%print results
sbar
sigma
theta

%run in console:
%global sbar sigma theta
%sbar = [-4 -8/3 -4/3 0 4/3 8/3 4];
%sigma = [0.2 0.2 0.2 0.2 0.2 0.2 0.2];
%theta = [-30 -60/3 -30/3 0 30/3 60/3 30];