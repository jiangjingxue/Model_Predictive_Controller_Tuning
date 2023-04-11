function [result] = IsTerminationSatisfied(counter,limit)
    % terminate when number of iteration exceeds the limit
    if(counter > limit)
        result = 1;
    else
        result = 0;
    end 
    % terminate when the fitness stop improving
end