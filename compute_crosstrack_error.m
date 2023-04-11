function [cte] = compute_crosstrack_error(origin,robot_pos,path_pos)

% build the vectors
v1 = (robot_pos - origin)';
v2 = (path_pos - origin)';

% rotate v2 by 90 degree counter-clockwise
v2_perpend = [0 -1; 1 0] * v2;

% compute cross track error 
cte = dot(v1,v2_perpend) / sqrt(v2(1)^2 + v2(2)^2);

end