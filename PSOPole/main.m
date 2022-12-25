
clc;
close all;
global P I D
%% Problem Definiton

problem.CostFunction = @(x) SAE(x);  % Cost Function
problem.nVar = 3;       % Number of Unknown (Decision) Variables
problem.VarMin =  [10 10 1];  % Lower Bound of Decision Variables
problem.VarMax =  [510 510 501];   % Upper Bound of Decision Variables

%% Parameters of PSO

params.MaxIt = 20;        % Maximum Number of Iterations
params.nPop = 100;           % Population Size (Swarm Size)
params.w = 1;               % Intertia Coefficient
params.wdamp = 0.99;        % Damping Ratio of Inertia Coefficient
params.c1 = 2;              % Personal Acceleration Coefficient
params.c2 = 2;              % Social Acceleration Coefficient
params.ShowIterInfo = true; % Flag for Showing Iteration Informatin

%% Calling PSO

out = PSO(problem, params);

BestSol = out.BestSol;
BestCosts = out.BestCosts;

%% Results

figure(1);
% plot(BestCosts, 'LineWidth', 2);
semilogy(BestCosts, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;

% nominal PID
P = 154;
I = 189;
D = 11;
result = sim('pole');
y1 = result.out; %PID controller

%GA PID
P = 15.871;
I = 41.311;
D = 267.145;
result = sim('pole');
y2 = result.out;

%PSO PID
P = BestSol.Position(1);
I = BestSol.Position(2);
D = BestSol.Position(3);

fileID = fopen('PID_values.txt','w');
formatSpec = 'P = %4.3f, I = %4.3f, D = %4.3f\n';
fprintf(fileID,formatSpec,P,I,D);

result = sim('pole');
y3 = result.out;
figure(2)
plot(result.tout, y1, 'r', result.tout, y2, 'k', result.tout, y3, 'b')
legend('nominal PID', 'GA PID', 'PSO PID')


