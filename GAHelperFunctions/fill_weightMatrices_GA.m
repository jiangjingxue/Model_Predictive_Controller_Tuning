function [CQC_bar,QC_bar,R_bar] = fill_weightMatrices_GA(CQC_bar,QC_bar,R_bar,CQC,QC,CSC,SC,R,N)
    for sample_i = 1:N
        if sample_i == N
            CQC_bar((sample_i-1)*size(CQC,1)+1:sample_i * size(CQC,1),(sample_i-1)*size(CQC,2)+1:sample_i * size(CQC,2)) = CSC;
            QC_bar((sample_i-1)*size(QC,1)+1:sample_i * size(QC,1),(sample_i-1)*size(QC,2)+1:sample_i * size(QC,2)) = SC;
        else
            % exponentially increasing weight matrix Q 
            % QC = 2^(sample_i - 1) * QC;
            % CQC = 2^(sample_i - 1) * CQC;
            CQC_bar((sample_i-1)*size(CQC,1)+1:sample_i * size(CQC,1),(sample_i-1)*size(CQC,2)+1:sample_i * size(CQC,2)) = CQC;
            QC_bar((sample_i-1)*size(QC,1)+1:sample_i * size(QC,1),(sample_i-1)*size(QC,2)+1:sample_i * size(QC,2)) = QC;
        end

        R_bar((sample_i-1)*size(R,1)+1:sample_i * size(R,1),(sample_i-1)*size(R,2)+1:sample_i * size(R,2)) = R;      
    end    
end 