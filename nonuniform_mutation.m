% reference
% https://sci2s.ugr.es/sites/default/files/files/ScientificImpact/AIRE12-1998.PDF
function [child] = nonuniform_mutation(child,t,gmax,b,pm,max,min)
% parameters
% t: generation t
% gmax: max number of generations
% b: increasing b will increase the dependency on the number of
% iteration, the larger the better (set b > 1) 
% pm: the probability a new N is chosen at random from the set of permissible values
% max: upperbound of the weights
% min: lowerbound of the weights

maxQ = max(1);
maxR = max(2);
maxS = max(3);
maxN = max(4);
minQ = min(1);
minR = min(2);
minS = min(3);
minN = min(4);

% not needed: mutated_child = struct('N',[zeros(1)],'Q',[zeros(3)],'R',[zeros(2)],'S',[zeros(3)]);

% mutate horizon N (interger mutation: random resetting)
child.N = random_setting(child.N,pm,minN,maxN);

% mutate matrix Q
for i = 1:3
    % generate a random number tao which have a value of either zero or one
    tao = randi([0 1],1,1);
    element = child.Q(i,i);

    if tao == 0
        child.Q(i,i) = element + get_delta(t,gmax,b,maxQ - element);
    else
        child.Q(i,i) = element - get_delta(t,gmax,b,element - minQ);
    end    
end

% mutate matrix R
for i = 1:2
    % generate a random number tao which have a value of either zero or one
    tao = randi([0 1],1,1);
    element = child.R(i,i);
    
    if tao == 0
        child.R(i,i) = element + get_delta(t,gmax,b,maxR - element);
    else
        child.R(i,i) = element - get_delta(t,gmax,b,element - minR);
    end
end 

% mutate matrix S
for i = 1:3    
    % generate a random number tao which have a value of either zero or one
    tao = randi([0 1],1,1);
    element = child.S(i,i);

    if tao == 0
        child.S(i,i) = element + get_delta(t,gmax,b,maxS - element);
    else
        child.S(i,i) = element - get_delta(t,gmax,b,element - minS);
    end     
end
end  


function [delta] = get_delta(t,gmax,b,y)
r = rand;
exp = (1-t/gmax)^b;     % exponent of power 

delta = y * (1 - r^exp);
end

function [N] = random_setting(N_child,pm,minN,maxN)
p = rand;
if p < pm
    % generate a random N from 1 to 10
    N = randi([minN maxN],1,1); 
else
    N = N_child;
end
end