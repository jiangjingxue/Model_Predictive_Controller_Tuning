function [xActual,u_k,du,v_k,theta_k,D] = reset_states(x0,x_refi,y_refi)
% Resets the states xAcutal and u_k
% Resets the control variables du
% Resets the initial velocity (v_k) and heading (theta_k) 

[xActual,u_k,du] = deal([],[],[]);

xActual(:,1) = x0;
u_k(:,1) = [0;0];
du(:,1) = [0;0];

v_k = 0.0;
theta_k = x0(3);

p1 = [x0(1) x0(2)];
p2 = [x_refi y_refi];
D = norm(p2 - p1);

end