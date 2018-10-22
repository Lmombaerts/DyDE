function net = true_millar_causality()
%Millar 10
%Causality network (either regression/activation)
%('LHY mRNA','TOC1 mRNA','Y mRNA','PPR9 mRNA','PRR7 mRNA','NI mRNA','GI mRNA','ZTL mRNA');
net = [0 1 1 1 1 1 1; %LHY
       0 0 1 1 0 0 1; %TOC1
       0 1 0 0 0 0 0; %Y
       1 0 0 0 1 0 0; %R9
       1 0 0 0 0 1 0; %R7
       1 0 0 0 0 0 0; %NI
       0 0 0 0 0 0 0]; %GI
   
end