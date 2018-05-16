%Save Result/C27warning.fig
clc
clear;
load('coeff.mat')
[b,date]=xlsread('testData.xls');
D =date(2,6);
LL=[];  %[1, longitude, latitude]
LL=[LL,1];
LL=[LL,b(1,4)];
LL=[LL,b(1,5)];
Cond=p1*LL';
m=[];
n=[]; 
z=[];
dd=b(:,3); 
cc=b(:,1); 

%Determining the order of conductivity function
R=[];
Adjusted_R=[];
AIC=[];
BIC=[];
for All_order=1:10
    dep=ones(size(depth,1),1);
    for order=1:All_order
        dep=[dep,depth.^order];
    end
    q=rank(dep);
    
    [b_C,bint_C,r_C,rint_C,stats_C]=regress(Cond,dep);
    R2_C=stats_C(1,1);
    n1=size(dep,1)
    k1=size(dep,2);
    Adjusted_R_C=1-(1-R2_C)*((n1-1)/(n1-k1));

%   Adjusted_R^2
    R=[R,R2_C];        
    Adjusted_R=[Adjusted_R,Adjusted_R_C];        
    Adjusted_R_C=max(Adjusted_R);
    [j,order]=find(Adjusted_R==Adjusted_R_C);     
%   AIC
    AIC=[AIC,log(sum(r_C.^2)/n1)+2*All_order/n1];
    aic_C = min(AIC);    
    [j1,Aorder]=find(AIC==aic_C);
%   BIC 
    BIC=[BIC,log(sum(r_C.^2)/n1)+All_order*log(n1)/n1];
    bic_C = min(BIC);
    [j2,Border]=find(AIC==aic_C);    
end 
%
results=[Adjusted_R',AIC',BIC'];

y=polyfit(depth',Cond',order);
Y=polyval(y,dd);
C=abs(Y-cc);
for i=1:length(dd)        
     if C(i,1)>0.1
        m=[m,dd(i,1)];
        n=[n,C(i,1)];
        z=[z,cc(i,1)];
     end
end
plot(dd,Y,'r',dd,cc,'b.');
hold on
plot(m,z,'g+');
grid on
ylabel('Conductivity (S/m)');xlabel('Depth (m)');