function [xActual,u_k,du,D,convergence_flag,v_k,theta_k,isValid_flag] = run_simulation_GA(xActual,u_k,du,total_sim_iter,v_k,theta_k,dT,sys,mpc,i_ref,D,c,N,refTrajectory,unicycle,x_ref,y_ref)
    % loop 
    convergence_flag = 0;
    isValid_flag = 0;

    for i = 1:total_sim_iter-10

    % Update the matrices A,B that governs the motions of the robot 
    % Purpose of this step: prepare that matrices that are used to 
    % predict the states of the robot 
    % from current time step k over a specified horizon
    % Note: v_k, theta_k, dT needs to be updated at the end of the loop
    [A,B,C] = prediction_model_GA(v_k,theta_k,dT);

    % Create augumented matrices，used to introudce integral action
    sys.A = A;
    sys.B = B;
    sys.C = C;

    sys.A_tilde = [sys.A sys.B;                               % 5x5 
               zeros(sys.num_inputs,sys.num_states) eye(sys.num_inputs)
              ];

    sys.B_tilde = [sys.B;                                     % 5x2
               eye(sys.num_inputs)
              ];

    sys.C_tilde = [sys.C zeros(size(sys.C,1),sys.num_inputs)];    % 3x5

    % Update the vector [x_k+1; u_k] 
    % x_k+1 : Robot state at sample instant one sample interval after current
    % sample.
    % u_k: the control inputs at current sample instant 
    x_kplus1_tilde = [xActual(:,end);u_k(:,end)];

    % Decide how far you want to predict
    % Extract part of the trajectory states based on specified horizon
    % if N=8, you need to extract 24 data 
        % if the index exceeds the trajecotry size, extract til the end
        % else extract 3*N number of data, but remember 
        % to substract 1 because i_ref already includes the current element
        if i_ref + (3 * N - 1) >= length(refTrajectory)
            extracted_refTrajectory = refTrajectory(i_ref:end);
            % decreasing the horizon
            N = N - 1;
        else 
            extracted_refTrajectory = refTrajectory(i_ref:i_ref + 3*N - 1);
        end
        i_ref = i_ref + sys.num_states; 

    % run MPC
    % find the first delta u in the optimal sequence of delta u (change in control inputs)
    % store the delta u in 
    du(:,end+1) = run_MPC_GA(sys,mpc,x_kplus1_tilde,extracted_refTrajectory);
  
    % uk = uk-1 + delta uk
    u_k(:,end+1) = u_k(:,end) + du(:,end);

    % disp(size(u_k,1));

    
    % Send the control command to the actual robot ( simulated robot)
    t0 = dT*i;
    tf = t0 + dT;
    T = t0:dT:tf;

    currentState = xActual(:,end);  % alternative: xActual(:,end) 
    u = u_k(:,end);                        % Similiarly, u_k(:,end) 

    % put a guard before simulating the motion of the vehicle
    if u_k(1,i) > 200 || u_k(2,i) > 200
        convergence_flag = 0;
        isValid_flag = 0;
        disp('invalid solution')
        break;
    end 

    [~,q] = ode45(@(t,q) derivative(unicycle,q,u),T,currentState);

    % update state
    finalState = q(end,:);
    xActual(:, end+1) = finalState;       % alternative: xActual(:,end + 1) = q(end,:)
    theta_k = finalState(3);                        % v_k should be updated
    v_k = u_k(1,end);
    if v_k < 0
        v_k = 0;
    end 

    % Terminate when robot is off the course
    p1 = finalState(1:2);
    p2 = [x_ref(i+1) y_ref(i+1)];
    D(end+1) = norm(p2-p1);
    D_avg = sum(D) / length(D);
        if(D_avg > D(1) + c)
            convergence_flag = 0;
            isValid_flag = 1;
            break
        else
            convergence_flag = 1;
            isValid_flag = 1;
        end

    end 
    


end 