% This program estimates the Ando and Bai (2015) and the Su and Chen (2015) 
% slope homogeneity tests. 

LASTN=maxNumCompThreads(12)
addpath('C:\Users\HEY!\Documents\Draft Paper 2021 Alpha\Rotimi\Study 2\Matlab\klt-files\output')
addpath('C:\Users\HEY!\Documents\Draft Paper 2021 Alpha\Rotimi\Study 2\Matlab\klt-files\programs')
addpath('C:\Users\HEY!\Documents\Draft Paper 2021 Alpha\Rotimi\Study 2\Matlab\klt-files\programs\matlabprograms')
addpath('C:\Users\HEY!\Documents\Draft Paper 2021 Alpha\Rotimi\Study 2\Matlab\klt-files\output')
addpath('C:\Users\HEY!\Documents\Draft Paper 2021 Alpha\Rotimi\Study 2')
clear;
clc;

%% load('../mydata/results_ss2aa2a4BOTH2_iFE2ch.mat')
load('C:\Users\HEY!\Documents\Draft Paper 2021 Alpha\Rotimi\Study 2\Matlab\klt-files\output/ICTResult_i.mat')
betaIFEab=betaIFEi02(:,1:N);
Fifeab=Fi12;
Lifeab=Li12';
Mfifeab=eye(length(Fifeab))-Fifeab*((Fifeab'*Fifeab)\Fifeab');
ri=2;
betaIFEsc=betaIFE2(:,1);
Fifesc=F12;
Lifesc=L12';
Mfifesc=eye(length(Fifesc))-Fifesc*((Fifesc'*Fifesc)\Fifesc');
r=2;
%% Ando and Bai test
xife=zeros(T*N,k); %reshape the variables (already demeaned) into the form for the slope test program
for p=1:k
    xife(:,p)=reshape(Xdoti(:,:,p),N*T,1);
end
yife=reshape(Ydoti,N*T,1);

thres=0.0001;
initial_b=zeros(size(xife,2),1);

[r1ife,epsilonife,Tau1ife]=AndoBai15(yife,xife,ri,T,N,thres,initial_b,betaIFEab,Fifeab,Lifeab,Mfifeab);
Tau1ife


Uccei=Ydoti; %Obtain CCE factor, loading, and M terms for use in slope test
for i=1:N
for p=1:k;
    Uccei(:,i)=Uccei(:,i)-Xdoti(:,i,p)* betaCCEi(p,i);
end
end
[rccei,~,~,~]=nbplog(Uccei,10,1,0);
[Fcce,Lcce,~]=panelFactorNew(Uccei,rccei);
Lcce=Lcce';
Mfcce=eye(length(Fcce))-Fcce*((Fcce'*Fcce)\Fcce');

xcce=zeros(T*N,k);
for p=1:k
    xcce(:,p)=reshape(Xdoti(:,:,p),N*T,1);
end
ycce=reshape(Ydoti,N*T,1);

thres=0.0001;
initial_b=zeros(size(xife,2),1);

[r1cce,epsiloncce,Tau1cce]=AndoBai15(ycce,xcce,rccei,T,N,thres,initial_b,betaCCEi,Fcce,Lcce,Mfcce);
Tau1cce



Yres=Ydoti; %Obtain the CCE2step loadings (from re-estimated - i.e., second step - coefficients) and M term (already have factors) for use in slope test
for p=1:k
    for i=1:N
        Yres(:,i)=Yres(:,i)-Xdoti(:,i,p)*betaCCEi2step(p,i);
    end
end
Fcce2stepPlus=Fcce2stepi;
if mgfe==1
    Fcce2stepPlus(:,r2stepi+1)=ones(T,1);
end
Fcce2stepAUG=repmat(Fcce2stepPlus,[1 1 N]);
Fcce2stepAUG=permute(Fcce2stepAUG,[1 3 2]);
[Lcce2stepFIXED]=Mul_panelbetai(Fcce2stepAUG,Yres);
Mfcce2step=eye(length(Fcce2stepPlus))-Fcce2stepPlus*((Fcce2stepPlus'*Fcce2stepPlus)\Fcce2stepPlus');
xcce2step=zeros(T*N,k);
for p=1:k
    xcce2step(:,p)=reshape(Xdoti(:,:,p),N*T,1);
end
ycce2step=reshape(Ydet,N*T,1);
[r1cce2step,epsiloncce2step,Tau1cce2step]=AndoBai15(ycce2step,xcce2step,r2stepi,T,N,thres,initial_b,betaCCEi2step,Fcce2stepPlus,Lcce2stepFIXED,Mfcce2step);
Tau1cce2step



%% Su and Chen test
xife=zeros(T*N,k);
for p=1:k
    xife(:,p)=reshape(Xdoti(:,:,p),N*T,1);
end
yife=reshape(Ydoti,N*T,1);
r=2;
thres=0.0001;
initial_b=zeros(size(xife,2),1);

[LMife,epsilonife,J1ife]=SuChen15(yife,xife,r,T,N,thres,initial_b,betaIFEsc,Fifesc,Lifesc);
% J1ife



xcce=zeros(T*N,k);
for p=1:k
    xcce(:,p)=reshape(Xdoti(:,:,p),N*T,1);
end
ycce=reshape(Ydoti,N*T,1);

thres=0.0001;
initial_b=zeros(size(xife,2),1);
Uccep=Ydoti;
for p=1:k;
    Uccep=Uccep-Xdoti(:,:,p)* betaCCEp(p,1);
end
[rcce,~,~,~]=nbplog(Uccep,10,1,0);
[Fcce,Lcce,~]=panelFactorNew(Uccep,rcce);
Lcce=Lcce';

[LMcce,epsiloncce,J1cce]=SuChen15(ycce,xcce,rcce,T,N,thres,initial_b,betaCCEp,Fcce,Lcce);
%J1cce



Uccep2step=Ydoti;
for p=1:k;
    Uccep2step=Uccep2step-Xdoti(:,:,p)* betaCCEp2step(p,1);
end
for i=1:N
    Uccep2step(:,i)=M2step*Uccep2step(:,i);
end
[LMcce2step,epsiloncce2step,J1cce2step]=SuChen152step(ycce,xcce,r2step,T,N,thres,initial_b,betaCCEp2step,Uccep2step,Fcce2step);
%J1cce2step


save('C:\Users\HEY!\Documents\Draft Paper 2021 Alpha\Rotimi\Study 2\Matlab\klt-files\output/ICTResult_i.mat')


