function net = negative_millar_causality()
%Millar 10
%Causality network (either regression/activation)
%('LHY mRNA','TOC1 mRNA','Y mRNA','PPR9 mRNA','PRR7 mRNA','NI mRNA','GI mRNA');
net = [0,0,0,0,0,0,0;
       1,0,0,0,1,1,0;
       1,0,0,1,1,1,1;
       0,1,1,0,0,1,1;
       0,1,1,1,0,0,1;
       0,1,1,1,1,0,1;
       1,1,1,1,1,1,0];
   
end