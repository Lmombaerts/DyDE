
% put key subdirectories in path if not already there
path(path, './Optimization');
path(path, './Data');


n=2000;
x=zeros(1,n);
y=zeros(1,n);

x(1)=rand();%0.2;
y(1)=rand();%0.4;
betaxy=0.02;
betayx=0.1;
rx=3.7;
ry=3.8;

for i=1:n-1
    x(i+1)=x(i)*(rx-rx*x(i)-betaxy*y(i));
    y(i+1)=y(i)*(ry-ry*y(i)-betayx*x(i));
end

x=x(200:221)';
y=y(200:221)';

numdati=length(x)-1;

xd=[x(2:numdati+1),x(1:numdati)];
yd=[y(2:numdati+1),y(1:numdati)];
xmin=min(x);
xmax=max(x);
ymin=min(y);
ymax=max(y);

for i=1:20
	for j=1:20
              cx(i+20*(j-1))=ymin+(ymax-ymin)*(j-1)/19;
              cy(i+20*(j-1))=ymin+(ymax-ymin)*(i-1)/19;
    end
end
c=[cx',cy'];


sigmai=0.1;

for i=1:length(yd)
	for j=1:length(c)
	       Amat(i,j)=exp(-norm(yd(i,:)-c(j,:))^2/2./sigmai^2);
    end
end

for i=1:numdati
     
	xlvec=[];
        xlvec=xd;
        xlvec(i,:)=[];
        Amatlot=[];
        Amatlot=Amat;
        Amatlot(i,:)=[];

        xlvec1=xlvec(:,1);
        x0=Amatlot'*xlvec1;
        alpha1 = l1eq_pd(x0, Amatlot, [], xlvec1, 1e-3);

        xlvec2=xlvec(:,2);
        x0=Amatlot'*xlvec2;
        alpha2 = l1eq_pd(x0, Amatlot, [], xlvec2, 1e-3);

        Amatpred=Amat(i,:);
        xpred1vec(i)=Amatpred*alpha1;
        xpred2vec(i)=Amatpred*alpha2;

end

xpred=[xpred1vec',xpred2vec'];

for i=1:numdati
	epsvec(i)=norm(xd(i,:)-xpred(i,:));
        normx(i)=norm(xd(i,:)-mean(xd));
end
Delta=norm(epsvec)/norm(normx);


Rxy=exp(-Delta/5.)



