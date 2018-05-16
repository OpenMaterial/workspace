%Save Result/T2warning.fig
clc
clear;
load('coeff.mat')%depth,p,p1 of 18 pairs of data.
[b,date]=xlsread('testData.xls');
D =date(2,6); %Preserve date
LL=[];  %[1, longitude, latitude]
LL=[LL,1];
LL=[LL,b(1,4)]; % longitude
LL=[LL,b(1,5)]; % latitude
Temp=p*LL';%18 temperature values obtained at the latitude and longitude %P is the coefficient of the September temperature cube
m=[]; %Preserve the depth of the abnormal temperature
n=[]; %Preserve the absolute value of the temperature difference between the cube and the temperature.
z=[]; %Preserve the abnormal temperature
dd=b(:,3); %Depth of observation
tt=b(:,2); %Depth of observation

%Determining the order of temperature function
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
    [b_T,bint_T,r_T,rint_T,stats_T]=regress(Temp,dep);
    R2_T=stats_T(1,1);
    n1=size(dep,1);
    k1=size(dep,2);    
    Adjusted_R_T=1-(1-R2_T)*((n1-1)/(n1-k1));
 %  Adjuested R^2
    R=[R,R2_T];
    Adjusted_R=[Adjusted_R,Adjusted_R_T];
    Adjusted_R_T=max(Adjusted_R);
    [j,order]=find(Adjusted_R==Adjusted_R_T);
 %  AIC
    AIC=[AIC,log(sum(r_T.^2)/n1)+2*All_order/n1];
    aic_C = min(AIC);    
    [j1,Aorder]=find(AIC==aic_C);
 %  BIC
    BIC=[BIC,log(sum(r_T.^2)/n1)+All_order*log(n1)/n1];
    bic_C = min(BIC);
    [j2,Border]=find(AIC==aic_C);
end
%
results=[Adjusted_R',AIC',BIC'];
%The depth-temperature fitting function is calculated from 18 pairs of data. 
y=polyfit(depth',Temp',order);
%The temperature value of the fitting function at dd is calculated.
Y=polyval(y,dd);
%The absolute value of the difference between the temperature and the actual temperature on the fitting function.
C=abs(Y-tt);
for i=1:length(dd)
    %In the thermocline, the threshold is larger and the temperature difference is greater than 3
     if C(i,1)>3 && dd(i,1)<100 
         m=[m,dd(i,1)]; 
         n=[n,C(i,1)];
         z=[z,tt(i,1)];
     end
    %Other depths, the temperature difference is greater than 1.
    if C(i,1)>1 && dd(i,1)>100 
        m=[m,dd(i,1)];
        n=[n,C(i,1)];
        z=[z,tt(i,1)]; 
    end
end

plot(dd,Y,'r',dd,tt,'b.'); hold on
plot(m,z,'g+')
grid on
ylabel('Temperature (¡æ)');xlabel('Depth (m)');