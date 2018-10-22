function [TP,FP,TN,FN,TPR,FPR,SPC,PPV,AUROC,AUPREC] = ROC_Millar10(fitness)

temp_fit = reshape(fitness,[1 size(fitness,1)*size(fitness,1)]);
sorted_fit = sort(temp_fit,'ascend');
temp = 1;

for threshold = sorted_fit%0:0.001:100
    %Analysis of performance (Do not consider self regulation)
    true_net = true_millar_causality(); %Load true network
    neg_net = 1 - true_net - eye(size(true_net,1)); %Load opposite network
    bool_Net = fitness >= threshold;
    TP(temp) = sum(sum(and(true_net,bool_Net))); %True Positive
    FP(temp) = sum(sum(and(neg_net,bool_Net))); %False Positive
    TN(temp) = sum(sum(neg_net)) - FP(temp); %True Negative
    FN(temp) = sum(sum(true_net)) - TP(temp); %False Negative
    TPR(temp) = TP(temp)/(TP(temp) + FN(temp));
    FPR(temp) = FP(temp)/(FP(temp) + TN(temp));
    SPC(temp) = TN(temp)/(TN(temp) + FP(temp));
    if TP(temp) == 0 && FP(temp) == 0
        PPV(temp) = 1;
    else
        PPV(temp) = TP(temp)/(TP(temp) + FP(temp));
    end
    temp = temp + 1;
end
AUROC = trapz(fliplr(FPR),fliplr(TPR));  
AUPREC = trapz(fliplr(TPR),fliplr(PPV));

end