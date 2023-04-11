function [population,fitness,queue] = delete_oldest(population,fitness,queue,offspring,offspring_fitness)

% Find the best individual in the current population
[elite_fitness,elite_index] = max(fitness);

% Find the oldest individual in the current population
oldest_index = queue.getFirst();

% if there are more than one offspring, select the offspring with the highest fitness 
if length(offspring) > 1
    [best_offspring_fitness,best_offspring_index] = max(offspring_fitness);
    offspring = offspring(best_offspring_index);
    offspring_fitness = best_offspring_fitness;
end

if oldest_index ~= elite_index
    % replace the oldest individual with the offspring
    population(oldest_index) = offspring;
    fitness(oldest_index) = offspring_fitness;

    % update the queue
    youngest_index = queue.pop();
    queue.add(youngest_index);
else
    % case1: the offspring has better fitness than the current elite
    % case2: none of the offspring has better fitness than the current elite   
    if offspring_fitness > elite_fitness
        population(oldest_index) = offspring;
        fitness(oldest_index) = offspring_fitness;
        youngest_index = queue.pop();
        queue.add(youngest_index);
    else
        % keep the elite ( best individual in the population)
    end   
end 

end

 
% Replacement/Deletion strategies
% -- Recall steady-state genetic algorithm 
% usually only produce one or two offspring in each generation. 
% Parents are selected to produce offspring 
% and then a decision is made as to which individuals in the population 
% to select for deletion to make room for the new offspring
% -- Different replacement strategies
% 1) Replace the oldest
% 2) Family Competition: assumes parents would be the memebers of the
% population closest to the newly created offspring. In this way, children
% competes with their parents to be included in the population
