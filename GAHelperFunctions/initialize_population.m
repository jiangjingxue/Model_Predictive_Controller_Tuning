function [pop,queue] = initialize_population(popsize)

% prepare the queue
import java.util.LinkedList
queue = LinkedList();

index = 1:popsize;
index = index(randperm(length(index)));

% prepare the stucture that stores the population
pop = struct('N',[zeros(1)],'Q',[zeros(3)],'R',[zeros(2)],'S',[zeros(3)]);
pop = repmat(pop,popsize,1);

for i = 1:popsize

    % randomly select the horizon N between 1 to 10; 
    maxN = 10;
    N = randi([1 maxN],1,1);

    % randomly select the state weight matrix Q and control weight matrix R 
    minWeight = 0;
    maxWeight = 100;
    r = (maxWeight-minWeight).*rand(5,1) + minWeight;
    r = round(r,3);
    Q = diag([r(1) r(2) r(3)]);     
    R = diag([r(4) r(5)]);
    
    minTermCost = 0;
    maxTermCost = 10;
    p = (maxTermCost-minTermCost).*rand(3,1) + minTermCost;
    p = round(p,3);
    S = diag([p(1) p(2) p(3)]);    

    % stores the generated matrices into the population
    pop(i).N = N;
    pop(i).Q = Q;
    pop(i).R = R;
    pop(i).S = S;

    % insert the index into the queue
    queue.add(index(i));
end






end