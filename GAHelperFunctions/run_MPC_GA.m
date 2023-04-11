function du_optimal = run_MPC_GA(sys,mpc,x_kplus1_tilde,extracted_refTrajectory)

    % load the basic matrices
    N = mpc.N;
    Q = mpc.Q;
    R = mpc.R;
    S = mpc.S;

    Atil = sys.A_tilde;
    Btil = sys.B_tilde;
    Ctil = sys.C_tilde;

    % create empty stacked diagonal weighting matrices
    CQC = Ctil' * Q * Ctil;
    CSC = Ctil' * S * Ctil;
    QC = Q * Ctil;
    SC = S * Ctil;

    CQC_bar = zeros(size(CQC,1) * N,size(CQC,2) * N);       % 5*N by 5*N
    QC_bar = zeros(size(QC,1)* N,size(QC,2) * N);           % 3*N by 5*N 
    R_bar = zeros(size(R,1) * N, size(R,2) * N);            % 2*N by 2*N 

    % create empty stacked coefficient matrices A,B for the prediction model
    A_bar = zeros(size(Atil,1) * N, size(Atil,2) * 1);            % 5*N by 5 
    B_bar = zeros(size(Btil,1) * N, size(Btil,2) * N);            % 5*N by 2*N

    % fill in A_bar, B_bar for the prediction model
    [A_bar,B_bar] = fill_AB_GA(A_bar,B_bar,Atil,Btil,N);

    % fill in CQC_bar, QC_bar and R_bar for the MPC cost function 
    [CQC_bar,QC_bar,R_bar] = fill_weightMatrices_GA(CQC_bar,QC_bar,R_bar,CQC,QC,CSC,SC,R,N);

    % compute the H and f term of the quadratic objective function
    % Note: f should be a column vector 
    H = 2.* B_bar'* CQC_bar * B_bar + R_bar;
    fT = [x_kplus1_tilde' extracted_refTrajectory'] * [A_bar' * CQC_bar * B_bar; -QC_bar * B_bar];
    % fT = [x_kplus1_tilde' extracted_refTrajectory'] * [A_bar' ; -QC_bar * B_bar];

    % Set up the min and max for the quadratic objective function
    du_min = ones(sys.num_inputs, N);
    du_max = ones(sys.num_inputs, N);
    for i = 1:N
        du_min(:, i) = sys.umin;
        du_max(:, i) = sys.umax;
    end

    % Prepare the coefficient matrices/vecotrs for the solver
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    lb = du_min;
    ub = du_max;
    x0 = [];
    %options;
    H = (H+H')/2;

    % call the solver
    % matlab function: x = quadprog(H,f,A,b,Aeq,beq,lb,ub,x0,options)
    % decision variable is change in control inputs u 
    du_star = quadprog(H,fT,A,b,Aeq,beq,lb,ub,x0,optimset('Display', 'off'));          % du_optimal is a column vector
    
    du_optimal = du_star(1:2,1);   
end 