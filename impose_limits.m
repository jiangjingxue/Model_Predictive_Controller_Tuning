function [child] = impose_limits(child,child_prev)

[rowQ,~] = find(child.Q < 0);
[rowR,~] = find(child.R < 0);
[rowS,~] = find(child.S < 0);

% check matrix Q
if isempty(rowQ) ~= 1
    for i = 1:length(rowQ)
        child.Q(rowQ(i),rowQ(i)) = child_prev.Q(rowQ(i),rowQ(i));
    end
end

% check matrix R
if isempty(rowR) ~= 1
    for i = 1:length(rowR)
        child.R(rowR(i),rowR(i)) = child_prev.R(rowR(i),rowR(i));
    end
end

% check matrix S
if isempty(rowS) ~= 1
    for i = 1:length(rowS)
        child.S(rowS(i),rowS(i)) = child_prev.S(rowS(i),rowS(i));
    end
end

% check N 
if child.N < 0
    child.N = child_prev.N;
end


end