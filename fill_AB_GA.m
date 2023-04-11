function [A_bar,B_bar] = fill_AB_GA(A_bar,B_bar,A_tilde,B_tilde,N)

    % need two loops, outer loop to fill the rows
    % inner loop to fill the columns
    
    % the matrix B_bar has size 5*N by 2*N 
    % each sub matrix has size of 5 by 2 

    for sample_i = 1:N
        % fill the A_bar
        A_bar((sample_i-1)*size(A_tilde,1)+1:sample_i * size(A_tilde,1),1:size(A_tilde,2)) = A_tilde^(sample_i);
        for col_i = 1:N
            if col_i <= sample_i
                % fill the B_bar
                B_bar((sample_i-1)*size(B_tilde,1)+1:sample_i * size(B_tilde,1),(col_i-1)*size(B_tilde,2)+1:col_i * size(B_tilde,2)) = A_tilde^(sample_i - col_i)*B_tilde;
            end 
        end
    end     
end 