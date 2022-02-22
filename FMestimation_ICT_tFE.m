% This program produces the IFE, IFEMG, CCEP, CCEMG, CCEP-2, and CCEMG-2
% estimates in Table 4 (it also produces the OLS and OLSMG
% estimates, for comparision with the Stata results)

%% Adding File Path and Clear
LASTN=maxNumCompThreads(12)
addpath('C:\Users\HEY!\Documents\Draft Paper 2021 Alpha\Rotimi\Study 2\Matlab\klt-files\output')
addpath('C:\Users\HEY!\Documents\Draft Paper 2021 Alpha\Rotimi\Study 2\Matlab\klt-files\programs')
addpath('C:\Users\HEY!\Documents\Draft Paper 2021 Alpha\Rotimi\Study 2\Matlab\klt-files\programs\matlabprograms')
addpath('C:\Users\HEY!\Documents\Draft Paper 2021 Alpha\Rotimi\Study 2\Matlab\klt-files\output')
addpath('C:\Users\HEY!\Documents\Draft Paper 2021 Alpha\Rotimi\Study 2')
clear;
clc;
%% TABLE 4 PART A AND TABLE 5: FACTOR MODELS WITH PERSON FIXED EFFECTS
%LOAD DATA (exported from STATA into .xls files using p4)
%NOTE: if any variables are going to be excluded from the CCE cross-section, put those at the end. 
%Y=xlsread('GSFlogearn_insampleBOTH2_2ch.xls')';
%X1=xlsread('GSFeducyears2_insampleBOTH2_2ch.xls')';
%X2=X1.^2;
%X3=xlsread('GSFageq_insampleBOTH2_2ch.xls')'; 
%X4=X3.^2; 
%X5=X3.^4; 

%% LOAD DATA (from Excel file.xlxs files into Matlab and Specify Data Range)
filename='C:\Users\HEY!\Documents\Draft Paper 2021 Alpha\Rotimi\Study 2\ICTmain.xlsx';  % specify the directory you are using
range_for_data='A3:l212';      % variables start in fourth row  (6 regressors followed by 3 dependent variable and 1 Optional Regressors,  in our case)
year=15;       % this tells us how to slice stacked data
% T=year;
%% Data Reshape Functions %%
%% Reshape Dependent Variables%%
data  =   xlsread(filename, 'ICT main', range_for_data);
% construct dependent variable
Y=reshape(data(:,10),year,[]);      % dependent variable is Return on Asset (ROA)
% Y=reshape(data(:,9),year,[]);      % dependent variable is Return on Equity (ROE)
% Y=reshape(data(:,11),year,[]);      % dependent variable is Net Interest Margin (NIM)
%Y=Y';
[Tmax, N]=size(Y);                   % size N x Tmax
%% Reshape and construct regressors
% X1=reshape(data(:,4),year,[]);     % first regressor debt/GDP growth (dgd)
X1=reshape(data(:,3),year,[]);     % first regressor ATM Transaction (ATM)
%X1=X1';
LX1=log(X1);
% X2=reshape(data(:,5),year,[]);     % second regressor inflation (dp)
X2=reshape(data(:,4),year,[]);     % second regressor Point of Sales Transaction (POS)
%X2=X2';
LX2=log(X2);
X3=reshape(data(:,5),year,[]);     % Third regressor Internet Banking Transaction (IB)
%X3=X3';
LX3=log(X3);
X4=reshape(data(:,6),year,[]);     % Fourth regressor Mobile Banking Transaction (MB)
%X4=X4';
LX4=log(X4);
%X6=reshape(data(:,7),year,[]);     % Fifth regressor Retail Channel and Goverment Transaction (CIFTS_RTGS)
%X6=X6';
X5=reshape(data(:,8),year,[]);     % Sixth regressor Cash Deposit Transaction (ACD)
%X5=X5';
LX5=log(X5);
%X7=reshape(data(:,12),ccode,[]);     % Seventh regressor (Factors) Foreigh Exchange Transaction (FXR)
%X7=X7';

S=0; %Can be a Nxm matrix to assign each person into one of m groups, m<N, in order to produce group-specific, rather than person-specific, trends. Not used in this paper
[T N]=size(Y);
%% SPECIFY MODEL SETTINGS
order=1; %Set the order of person/group-specific trend to be included in the model (via de-trending, before estimation) [always 0 in our paper]
k=5; %Number of regressors
kcsavg=5; %Number of cross-section averages for CCE -> number of independent variables + 1 (minus the number of age variables used as regressors if any, because age is a "d_t" variable in Pesaran paper, not an "x_it" variable)
demean=1; %Type of fixed effects to include in the model (seperate from interactive fixed effects); 0-no fixed effects, 1-time period fixed effects, 2-person fixed effects, 3-two-way fixed effects
mgfe=0; %removes person FE (i.e., person intercept) in individual-level regs

%PLACE REGRESSORS TOGETHER INTO SINGLE X MATRIX
X=zeros(T,N,k);
X(:,:,1)=LX1;
X(:,:,2)=LX2;
X(:,:,3)=LX3;
X(:,:,4)=LX4;
X(:,:,5)=LX5;

%X(:,:,1)=X1;
%X(:,:,2)=X2;
%X(:,:,3)=X3;
%X(:,:,4)=X4;
%X(:,:,5)=X5;
%% ESTIMATION
%first, demean the variables for use later
[Xdet,Ydet]=RemoveTimeTrends(X,Y,order,S); %Remove unit-specific trends time trends (no trends if order=0)
[Xdott,Ydott]=CSDemean(Xdet,Ydet,1); %Demean along the cross section dimension, which removes time fixed effects
[Xdoti,Ydoti]=TimeDemean(Xdet,Ydet,1); %Demean along the time dimension, which removes individual fixed effects
[Xdot2,Ydot2]=DemeanData(Xdet,Ydet); %Demean in both directions, to remove person and time fixed effects

%OLS pooled
if demean==1
    Yolsp=Ydott;
    Xolsp=Xdott;
elseif demean==2
    Yolsp=Ydoti;
    Xolsp=Xdoti;
elseif demean==3
    Yolsp=Ydot2;
    Xolsp=Xdot2;
end
[betaOLSp]=Mul_panelbeta(Xolsp,Yolsp,eye(T));

%OLS heterogeneous
if mgfe==1
[betaOLSi]=Mul_panelbetai(Xdoti,Ydoti); 
elseif mgfe==0
[betaOLSi]=Mul_panelbetai(Xdet,Ydet);
end
betaOLSMG=mean(betaOLSi,2);
squaredOLSi=zeros(k,k,N);
for i=1:N
    squaredOLSi(:,:,i)=(betaOLSi(:,i)-betaOLSMG(:,1))*(betaOLSi(:,i)-betaOLSMG(:,1))';
end;
varcovOLSi=(1/(N*(N-1)))*sum(squaredOLSi,3);
seOLSi(:,1)=sqrt(diag(varcovOLSi));

%CCE (pooled and heterogeneous)
[betaCCEmg, seCCEmg, betaCCEp, seCCEp, betaCCEi,M, Mmg, varcovCCEmg, varcovCCEp] = CCEfunction(X,Y,order,S,demean,mgfe,kcsavg); %always send in non-demeaned data; any de-meaning handled inside

%CCE two-step (pooled and heterogeneous)
if demean==1
    Ycce2=Ydott;
    Xcce2=Xdott;
elseif demean==2
    Ycce2=Ydoti;
    Xcce2=Xdoti;
elseif demean==3
    Ycce2=Ydot2;
    Xcce2=Xdot2;
end
Uccep=Ycce2;
for p=1:k
    Uccep=Uccep-Xcce2(:,:,p)* betaCCEp(p,1);
end
[r2step,~,~,~]=nbplog(Uccep,10,1,0);
[Fcce2step,Lcce2step,VNTcce2step]=panelFactorNew(Uccep,r2step);

if mgfe==1
    Ycce2i=Ydoti;
    Xcce2i=Xdoti;
elseif mgfe==0
    Ycce2i=Ydet;
    Xcce2i=Xdet;
end
Uccei=Ycce2i;
for p=1:k
	for i=1:N
    		Uccei(:,i)=Uccei(:,i)-Xcce2i(:,i,p)* betaCCEi(p,i);
	end
end
[r2stepi,~,~,~]=nbplog(Uccei,10,1,0);
Uccei=Ycce2i;
for p=1:k
    Uccei=Uccei-Xcce2i(:,:,p)* betaCCEmg(p,1);
end
[Fcce2stepi,Lcce2stepi,VNTcce2stepi]=panelFactorNew(Uccei,r2stepi);

[betaCCEmg2step, seCCEmg2step, betaCCEp2step, seCCEp2step, betaCCEi2step, M2step, Mmg2step, varcovCCEmg2step, varcovCCEp2step] = CCEfunction2step(X,Y,order,S, demean, mgfe, Fcce2step, Fcce2stepi); %always send in non-demeaned data

%IFE (note, for full analysis, IFE is estimated for each of 1-10 factors, and then the final number is chosen in p6. The replication code only generates the estimates chosen in p6 for the paper, for the sake of run time)
%[betaIFE1, seIFE1, sigma21, SSR1, nnn1, r11, r21, betaIFE01, betaOLS1, F11, L11, F21, L21, VNT11, VNT21, varcovIFE1, Uife1] = IFEfunction(X,Y,order,S,demean,1,1); %always send in non-demeaned data; any de-meaning handled inside
[betaIFE2, seIFE2, sigma22, SSR2, nnn2, r12, r22, betaIFE02, betaOLS2, F12, L12, F22, L22, VNT12, VNT22, varcovIFE2, Uife2] = IFEfunction(X,Y,order,S,demean,2,1);
%[betaIFE3, seIFE3, sigma23, SSR3, nnn3, r13, r23, betaIFE03, betaOLS3, F13, L13, F23, L23, VNT13, VNT23, varcovIFE3, Uife3] = IFEfunction(X,Y,order,S,demean,3,1);
%[betaIFE4, seIFE4, sigma24, SSR4, nnn4, r14, r24, betaIFE04, betaOLS4, F14, L14, F24, L24, VNT14, VNT24, varcovIFE4, Uife4] = IFEfunction(X,Y,order,S,demean,4,1);
%[betaIFE5, seIFE5, sigma25, SSR5, nnn5, r15, r25, betaIFE05, betaOLS5, F15, L15, F25, L25, VNT15, VNT25, varcovIFE5, Uife5] = IFEfunction(X,Y,order,S,demean,5,1);
%[betaIFE6, seIFE6, sigma26, SSR6, nnn6, r16, r26, betaIFE06, betaOLS6, F16, L16, F26, L26, VTN16, VNT26, varcovIFE6, Uife6] = IFEfunction(X,Y,order,S,demean,6,1);
%[betaIFE7, seIFE7, sigma27, SSR7, nnn7, r17, r27, betaIFE07, betaOLS7, F17, L17, F27, L27, VNT17, VNT27, varcovIFE7, Uife7] = IFEfunction(X,Y,order,S,demean,7,1);
%[betaIFE8, seIFE8, sigma28, SSR8, nnn8, r18, r28, betaIFE08, betaOLS8, F18, L18, F28, L28, VNT18, VNT28, varcovIFE8, Uife8] = IFEfunction(X,Y,order,S,demean,8,1);
%[betaIFE9, seIFE9, sigma29, SSR9, nnn9, r19, r29, betaIFE09, betaOLS9, F19, L19, F29, L29, VNT19, VNT29, varcovIFE9, Uife9] = IFEfunction(X,Y,order,S,demean,9,1);
%[betaIFE10, seIFE10, sigma210, SSR10, nnn10, r110, r210, betaIFE010, betaOLS10, F110, L110, F210, L210, VNT110, VNT210, varcovIFE10, Uife10] = IFEfunction(X,Y,order,S,demean,10,1);

%IFE heterogeneous (note, for full analysis, IFEMG is estimated for each of 1-10 factors, and then the final number is chosen in p6. The replication code only generates the estimates chosen in p6 for the paper, for the sake of run time)
%[betaIFEH1, betaIFEi1, varcovIFEi1, seIFEi1, sigmai21, SSRi1, nnni1, ri11, ri21, betaIFEi01, betaOLSi1, Fi11, Li11, Fi21, Li21, VNTi11, VNTi21, Uifei1] = IFEifunction(X,Y,order,S,1,1,betaIFE1,seIFE1,mgfe); %always send in non-demeaned
[betaIFEH2, betaIFEi2, varcovIFEi2, seIFEi2, sigmai22, SSRi2, nnni2, ri12, ri22, betaIFEi02, betaOLSi2, Fi12, Li12, Fi22, Li22, VNTi12, VNTi22, Uifei2] = IFEifunction(X,Y,order,S,2,1,betaIFE2,seIFE2,mgfe);
%[betaIFEH3, betaIFEi3, varcovIFEi3, seIFEi3, sigmai23, SSRi3, nnni3, ri13, ri23, betaIFEi03, betaOLSi3, Fi13, Li13, Fi23, Li23, VNTi13, VNTi23, Uifei3] = IFEifunction(X,Y,order,S,3,1,betaIFE3,seIFE3,mgfe);
%[betaIFEH4, betaIFEi4, varcovIFEi4, seIFEi4, sigmai24, SSRi4, nnni4, ri14, ri24, betaIFEi04, betaOLSi4, Fi14, Li14, Fi24, Li24, VNTi14, VNTi24, Uifei4] = IFEifunction(X,Y,order,S,4,1,betaIFE4,seIFE4,mgfe);
%[betaIFEH5, betaIFEi5, varcovIFEi5, seIFEi5, sigmai25, SSRi5, nnni5, ri15, ri25, betaIFEi05, betaOLSi5, Fi15, Li15, Fi25, Li25, VNTi15, VNTi25, Uifei5] = IFEifunction(X,Y,order,S,5,1,betaIFE5,seIFE5,mgfe);
%[betaIFEH6, betaIFEi6, varcovIFEi6, seIFEi6, sigmai26, SSRi6, nnni6, ri16, ri26, betaIFEi06, betaOLSi6, Fi16, Li16, Fi26, Li26, VNTi16, VNTi26, Uifei6] = IFEifunction(X,Y,order,S,6,1,betaIFE6,seIFE6,mgfe);
%[betaIFEH7, betaIFEi7, varcovIFEi7, seIFEi7, sigmai27, SSRi7, nnni7, ri17, ri27, betaIFEi07, betaOLSi7, Fi17, Li17, Fi27, Li27, VNTi17, VNTi27, Uifei7] = IFEifunction(X,Y,order,S,7,1,betaIFE7,seIFE7,mgfe);
%[betaIFEH8, betaIFEi8, varcovIFEi8, seIFEi8, sigmai28, SSRi8, nnni8, ri18, ri28, betaIFEi08, betaOLSi8, Fi18, Li18, Fi28, Li28, VNTi18, VNTi28, Uifei8] = IFEifunction(X,Y,order,S,8,1,betaIFE8,seIFE8,mgfe);
%[betaIFEH9, betaIFEi9, varcovIFEi9, seIFEi9, sigmai29, SSRi9, nnni9, ri19, ri29, betaIFEi09, betaOLSi9, Fi19, Li19, Fi29, Li29, VNTi19, VNTi29, Uifei9] = IFEifunction(X,Y,order,S,9,1,betaIFE9,seIFE9,mgfe);
%[betaIFEH10, betaIFEi10, varcovIFEi10, seIFEi10, sigmai210, SSRi10, nnni10, ri110, ri210, betaIFEi010, betaOLSi10, Fi110, Li110, Fi210, Li210, VNTi110, VNTi210, Uifei10] = IFEifunction(X,Y,order,S,10,1,betaIFE10,seIFE10,mgfe);


%Compute the marginal return to years of schooling
beduc_olsp=betaOLSp(1,1)+2*betaOLSp(2,1)*mean(X1(:));
beduc_ccep=betaCCEp(1,1)+2*betaCCEp(2,1)*mean(X1(:));
beduc_ccep2step=betaCCEp2step(1,1)+2*betaCCEp2step(2,1)*mean(X1(:));
beduc_ife=betaIFE2(1,1)+2*betaIFE2(2,1)*mean(X1(:));

beduc_olsi_fix=zeros(1,N);
beduc_ifei_fix=zeros(1,N);
beduc_ccei_fix=zeros(1,N);
beduc_ccei2step_fix=zeros(1,N);
for i=1:N
    beduc_olsi_fix(1,i)=betaOLSi(1,i)+2*betaOLSi(2,i)*mean(X1(:,i));
    beduc_ifei_fix(1,i)=betaIFEi02(1,i)+2*betaIFEi02(2,i)*mean(X1(:,i));
    beduc_ccei_fix(1,i)=betaCCEi(1,i)+2*betaCCEi(2,i)*mean(X1(:,i));
    beduc_ccei2step_fix(1,i)=betaCCEi2step(1,i)+2*betaCCEi2step(2,i)*mean(X1(:,i));
end

beduc_olsmg_fix=mean(beduc_olsi_fix);
beduc_ifemg_fix=mean(beduc_ifei_fix);
beduc_ccemg_fix=mean(beduc_ccei_fix);
beduc_ccemg2step_fix=mean(beduc_ccei2step_fix);

c=[1,2*mean(X1(:)),0,0,0]

bIFEplincom=betaIFE2(:,1)'*c'
vIFEplincom=c*varcovIFE2(:,:,1)'*c'
seIFEplincom=sqrt(vIFEplincom)

bCCEplincom=betaCCEp'*c'
vCCEplincom=c*varcovCCEp'*c'
seCCEplincom=sqrt(vCCEplincom)

bCCEp2steplincom=betaCCEp2step'*c'
vCCEp2steplincom=c*varcovCCEp2step'*c'
seCCEp2steplincom=sqrt(vCCEp2steplincom)

squaredIFEmglincom=zeros(1,1,N);
for i=1:N
    squaredIFEmglincom(:,:,i)=(beduc_ifei_fix(:,i)-mean(beduc_ifei_fix))*(beduc_ifei_fix(:,i)-mean(beduc_ifei_fix))';
end;
varcovIFEmglincom=(1/(N*(N-1)))*sum(squaredIFEmglincom,3);
seIFEmglincom=sqrt(diag(varcovIFEmglincom))

squaredCCEmglincom=zeros(1,1,N);
for i=1:N
    squaredCCEmglincom(:,:,i)=(beduc_ccei_fix(:,i)-mean(beduc_ccei_fix))*(beduc_ccei_fix(:,i)-mean(beduc_ccei_fix))';
end;
varcovCCEmglincom=(1/(N*(N-1)))*sum(squaredCCEmglincom,3);
seCCEmglincom=sqrt(diag(varcovCCEmglincom))

squaredCCEmg2lincom=zeros(1,1,N);
for i=1:N
    squaredCCEmg2lincom(:,:,i)=(beduc_ccei2step_fix(:,i)-mean(beduc_ccei2step_fix))*(beduc_ccei2step_fix(:,i)-mean(beduc_ccei2step_fix))';
end;
varcovCCEmg2lincom=(1/(N*(N-1)))*sum(squaredCCEmg2lincom,3);
seCCEmg2lincom=sqrt(diag(varcovCCEmg2lincom))

squaredOLSmglincom=zeros(1,1,N);
for i=1:N
    squaredOLSmglincom(:,:,i)=(beduc_olsi_fix(:,i)-mean(beduc_olsi_fix))*(beduc_olsi_fix(:,i)-mean(beduc_olsi_fix))';
end;
varcovOLSmglincom=(1/(N*(N-1)))*sum(squaredOLSmglincom,3);
seOLSmglincom=sqrt(diag(varcovOLSmglincom))

%% Generate T-statistic for 
tstatIFEMGt=betaIFEH2./seIFEi2;
tstatIFEt=betaIFE2./seIFE2;
tstatOLSit=betaOLSi./seOLSi; % Classical fixed individual effect
tstatCCEpt=betaCCEp./seCCEp; % Pooled CCE
tstatCCEp2stept=betaCCEp2step./seCCEp2step; % Pooled CCE 2 Step
tstatCCEmgt=betaCCEmg./seCCEmg; % Pooled CCE
tstatCCEmg2stept=betaCCEmg2step./seCCEmg2step; % Pooled CCE 2 Step

save('C:\Users\HEY!\Documents\Draft Paper 2021 Alpha\Rotimi\Study 2\Matlab\klt-files\output/ICTResult_t.mat')




