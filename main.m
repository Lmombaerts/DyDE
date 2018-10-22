%Call for Huanfei's inference technique for short time series 
%Laurent Mombaerts @Octobre 2018

clear; close all;

load millar10.mat
mRNA_idx = [1 4 7 10 12 14 16]; 
mRNA_names = {'LHY mRNA';'TOC1 mRNA';'Y mRNA';'PRR9 mRNA';'PRR7 mRNA';'NI mRNA';'GI mRNA'}; 
samplingTime = 4;
for simuNumber = 1:50
    mRNA_data = LL{1,simuNumber}(mRNA_idx,1:samplingTime:end);

    %% Apply LTI all to all
    %Resample to realistic data (48h of transients data, every 4 hours)
    tL = 0:samplingTime:(size(mRNA_data,2)-1)*samplingTime; 
    %Interpolation to 1h (piecewise cubic spline)
    tLI = 0:48;
    dataLI = pcs(mRNA_data, tL, tLI); 
    [fitness, ~, ~, ~, ~] = just_tfest(1, 1, dataLI); %Inference
    [TP{simuNumber},FP{simuNumber},TN{simuNumber},FN{simuNumber},TPR{simuNumber},FPR{simuNumber},SPC{simuNumber},PPV{simuNumber},AUROC_DT{simuNumber},AUPREC_DT{simuNumber}] = ROC_Millar10(fitness); 
    fitness_ATA{simuNumber} = fitness;

    %% Apply RBF Huanfei
    for i = 1:size(mRNA_data,1)
        for j = 1:size(mRNA_data,1)
            if i~=j
                R_matrix(i,j) = huanfeiRBF(mRNA_data(i,:)',mRNA_data(j,:)'); %Inference
            end
        end
    end
    fitness_RBF{simuNumber} = R_matrix;
    [TP_RBF{simuNumber},FP_RBF{simuNumber},TN_RBF{simuNumber},FN_RBF{simuNumber},TPR_RBF{simuNumber},FPR_RBF{simuNumber},SPC_RBF{simuNumber},PPV_RBF{simuNumber},AUROC_RBF{simuNumber},AUPREC_RBF{simuNumber}] = ROC_Millar10(R_matrix); 
end

%load allData.mat

save resultsComparison


%% Plot Results
load('resultsComparison.mat')

figure; subplot(1,2,1); histogram(cell2mat(AUPREC_DT))
hold on; histogram(cell2mat(AUPREC_RBF)); grid; grid minor; box on; title('AUPREC'); legend('All to All','Huanfei 2018');
xlabel('Value'); ylabel('Density');
subplot(1,2,2); histogram(cell2mat(AUROC_DT)); 
hold on; histogram(cell2mat(AUROC_RBF));  grid; grid minor; box on; title('AUROC'); legend('All to All','Huanfei 2018');
xlabel('Value'); ylabel('Density');

%% ROC Curve
FPR_DT = zeros(50,50);TPR_DT = zeros(50,50);
FPR_g = zeros(50,50);TPR_g = zeros(50,50);
for i = 1:50
    FPR_DT(i,1:49) = FPR{i};
    TPR_DT(i,1:49) = TPR{i};
    FPR_g(i,1:49) = FPR_RBF{i};
    TPR_g(i,1:49) = TPR_RBF{i};
end
plotROC_overExperiments(FPR_DT,TPR_DT);
plotROC_overExperiments(FPR_g,TPR_g);

