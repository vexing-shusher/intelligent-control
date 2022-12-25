clear

%optimizer parameters
popsize = 100;
gen = 20;
pcross = 0.9;
pmutation = 0.01;

%search space
Pmax = 510;
Pmin = 10;
Imax = 510;
Imin = 10;
Dmax = 501;
Dmin = 1;

%number of bits for each parameter of PID
Pbit = 9;
Ibit = 9;
Dbit = 9;
lchrom = Pbit + Ibit + Dbit; %chromosome length

maxall = 0; %initial fitness value

an = [0 0 0]; % [gen maxf meanf]

pop = rands(popsize, lchrom); %random number in range (-1,1)

pop = ceil(pop); %initial population

%iterating over k generations
for k=1:gen
    %for the k-th generation
    for i=1:popsize
        %decoding PID parameters
        P = bin2dec(num2str(pop(i,1:Pbit)));
        I = bin2dec(num2str(pop(i,Pbit+1:Pbit+Ibit)));
        D = bin2dec(num2str(pop(i,Pbit+Ibit+1:Pbit+Ibit+Dbit)));

        %linear mapping to real search domain
        P = Pmin + (Pmax-Pmin)*P/(2^Pbit - 1);
        I = Imin + (Imax-Imin)*I/(2^Ibit - 1);
        D = Dmin + (Dmax-Dmin)*D/(2^Dbit - 1);

        %find error e for each chromosome i
        result = sim('pole'); %run cart-pole simulation

        SAE = sum(abs(result.err));
        fitness(i) = 1/SAE;
    end
    sumf = sum(fitness); %total fitness
    [maxf,nmax]=max(fitness); %maximum fitness

    if maxf > maxall
        maxall = maxf;
        best = pop(nmax,:);
    end

    %reproduction (selection)
    for i=1:popsize
        test=rand*sumf;
        partsum=fitness(1);
        j=1;
        while partsum < test,partsum=partsum+fitness(j+1);j=j+1;end
        pop_select(i,:)=pop(j,:); % selected chromosome
    end

    pop_select(1,:)=best; % elite preservation

    pop=pop_select;
    i=1;
    % crossover
    for jj=1:popsize/2
        if(rand<=pcross)
            jcross=ceil(rand*(lchrom-1));% crossover site
            for j=jcross+1:lchrom
                pop(i,j)=pop_select(i+1,j);
                pop(i+1,j)=pop_select(i,j);
            end % for j
        end
     i=i+2;
    end % end for jj

    %mutation
    for i=1:popsize
        for j=1:lchrom
            if (rand<=pmutation)
                pop(i,j) = abs(pop(i,j)-1); %0 to 1; 1 to 0
            end
        end
    end

    an = [an; k, maxall, mean(fitness)];

    %print results
    [k, maxall, mean(fitness)]
end

%plotting performance curves
subplot(2,1,1)
hold on
plot([an(2:gen+1,2),an(2:gen+1,3)])
legend('max fitness','mean fitness')

%nominal PID
P = 154;
I = 189;
D = 11;
result = sim('pole.slx');
y1=result.out; %nominal PID controller

%decoding for best PID parameter
P = bin2dec(num2str(best(1:Pbit)));
I = bin2dec(num2str(best(Pbit+1:Pbit+Ibit)));
D = bin2dec(num2str(best(Pbit+Ibit+1:Pbit+Ibit+Dbit)));

%linear mapping to real search domain
P = Pmin + (Pmax-Pmin)*P/(2^Pbit - 1)
I = Imin + (Imax-Imin)*I/(2^Ibit - 1)
D = Dmin + (Dmax-Dmin)*D/(2^Dbit - 1)

fileID = fopen('PID_values.txt','w');
formatSpec = 'P = %4.3f, I = %4.3f, D = %4.3f\n';
fprintf(fileID,formatSpec,P,I,D);



result = sim('pole.slx')
y2=result.out; %best PID controller

subplot(2,1,2)
hold on
plot([y1,y2])
legend('nominal controller','optimized controller')









