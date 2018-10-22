function plotROC_overExperiments(FPR,TPR)

figure; hold on; %ROC
xq = unique(FPR)';
FPR_interp = [];
TPR_interp = [];
for i = 1:size(FPR,1)
    plot(FPR(i,:),TPR(i,:));
    [x,y] = uniquePairs(FPR(i,:),TPR(i,:));
    plot(x,y);
    %Now, interpolate.
    xx = x;
    yy = y;
    for j = 1:length(xq)
        idx = find(xx == xq(j));
        if isempty(idx) %Does not appear in the vector, need interpolation
            %On place y entre les 2 valeurs de x les plus proches
            lower_idx = find(xx > xq(j));
            upper_idx = find(xx < xq(j));
            up = lower_idx(end);
            low = upper_idx(1);
            %fprintf('Value X = %d, upper_idx = %d, lower_idx = %d\n',xq(j),up,low);
            y_interp = interp1([xx(up) xx(low)],[yy(up) yy(low)],xq(j));
            xx = [xx(lower_idx) xq(j) xx(upper_idx)];
            yy = [yy(lower_idx) y_interp yy(upper_idx)];
        end
    end
    plot(xx,yy,'x');
    
    for k = 1:length(xq)
        totVal = 0;
        idx = find(xx == xq(k));
        for l = 1:length(idx)
            totVal = totVal + yy(idx(l));
        end
        yq(i,k) = totVal/length(idx);
    end
end
            
plot(xq,mean(yq,1),'k','LineWidth',3); box on; 

for i = 1:length(xq)
    meanZ(i) = median(yq(:,i));
    high(i) = quantile(yq(:,i),0.95);
    low(i) = quantile(yq(:,i),0.05);
end
CC = xq;
figure;ciplot(low,high,CC); hold on;
plot(CC,meanZ); hold on; 
plot(CC,high,':'); plot(CC,low,':');
legend('95% CI','Median value');
% title('mean(AUROC) =  0.5747; std(AUROC) = 0.05. DREAM4 - In silico, size10, 2');
% xlabel('False Positive Rate (FPR)');
% ylabel('True Positive Rate (TPR)');

end