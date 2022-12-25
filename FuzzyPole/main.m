
clc;
close all;
global KE KCE KD KI
%% Problem Definiton

problem.CostFunction = @(x) SAE(x);  % Cost Function
problem.nVar = 4;       % Number of Unknown (Decision) Variables
problem.VarMin =  [-2 -2 -2 -2];  % Lower Bound of Decision Variables
problem.VarMax =  [2 2 2 2];   % Upper Bound of Decision Variables

%% Parameters of PSO

params.MaxIt = 13;        % Maximum Number of Iterations
params.nPop = 200;           % Population Size (Swarm Size)
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



%PSO gains
KE = power(10,BestSol.Position(1));
KCE = power(10,BestSol.Position(2));
KD = power(10,BestSol.Position(3));
KI = power(10,BestSol.Position(4));

fileID = fopen('gain_values.txt','w');
formatSpec = 'KE = %4.3f, KCE = %4.3f, KD = %4.3f\n, KI = %4.3f\n';
fprintf(fileID,formatSpec,KE,KCE,KD,KI);

result = sim('pole');
y3 = result.out;
figure(2)
plot(result.tout, y3, 'b')
legend('PSO gains')


