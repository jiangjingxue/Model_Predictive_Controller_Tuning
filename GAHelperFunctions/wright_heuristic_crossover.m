function [child1] = wright_heuristic_crossover(parent1,parent1_fitness,parent2,parent2_fitness)

% prepare the stucture that stores the child
child1 = struct('N',[zeros(1)],'Q',[zeros(3)],'R',[zeros(2)],'S',[zeros(3)]);

% perfrom uniform crossover for integer N 
child1.N = uniform_crossover(parent1.N,parent2.N);

% generate a random number r in [0,1]
r = rand;

% perfrom crossover 
if parent1_fitness >= parent2_fitness
    Q11 = helper1(parent1.Q(1,1),parent2.Q(1,1),r);
    Q22 = helper1(parent1.Q(2,2),parent2.Q(2,2),r);
    Q33 = helper1(parent1.Q(3,3),parent2.Q(3,3),r);
    R11 = helper1(parent1.R(1,1),parent2.R(1,1),r);
    R22 = helper1(parent1.R(2,2),parent2.R(2,2),r);
    S11 = helper1(parent1.S(1,1),parent2.S(1,1),r);
    S22 = helper1(parent1.S(2,2),parent2.S(2,2),r);
    S33 = helper1(parent1.S(3,3),parent2.S(3,3),r);
    child1.Q = diag([Q11,Q22,Q33]);
    child1.R = diag([R11,R22]);
    child1.S = diag([S11,S22,S33]);  
else
    Q11 = helper2(parent1.Q(1,1),parent2.Q(1,1),r);
    Q22 = helper2(parent1.Q(2,2),parent2.Q(2,2),r);
    Q33 = helper2(parent1.Q(3,3),parent2.Q(3,3),r);
    R11 = helper2(parent1.R(1,1),parent2.R(1,1),r);
    R22 = helper2(parent1.R(2,2),parent2.R(2,2),r);
    S11 = helper2(parent1.S(1,1),parent2.S(1,1),r);
    S22 = helper2(parent1.S(2,2),parent2.S(2,2),r);
    S33 = helper2(parent1.S(3,3),parent2.S(3,3),r);
    child1.Q = diag([Q11,Q22,Q33]);
    child1.R = diag([R11,R22]);
    child1.S = diag([S11,S22,S33]);
end 

end

function child_i = helper1(parent1_i,parent2_i,r) 
% parent1 has the better fitness 
child_i = r * (parent1_i - parent2_i) + parent1_i;
end 

function child_i = helper2(parent1_i,parent2_i,r) 
% parent1 has the better fitness 
child_i = r * (parent2_i - parent1_i) + parent2_i;
end 

function N = uniform_crossover(N1,N2)
% generate a random number
k = rand;
if k < 0.5 
    N = N1;
else
    N = N2;
end 
end