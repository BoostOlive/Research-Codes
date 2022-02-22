% This program takes the results from the previous matlab factor 
% models programs and places the results from the paper into 
% their own paper-table-style matrices.

LASTN=maxNumCompThreads(12);
clear;

%% Table 1
clear
load('C:\Users\HEY!\Documents\Draft Paper 2021 Alpha\Rotimi\Study 2\Matlab\klt-files\output/ICTResult_i.mat')
Table1=zeros(2,6);
Table1(1,1)=betaIFE2(1,1);
Table1(2,1)=seIFE2(1,1);
Table1(1,3)=betaCCEp(1,1);
Table1(2,3)=seCCEp(1,1);
Table1(1,5)=betaCCEp2step(1,1);
Table1(2,5)=seCCEp2step(1,1);
save('C:\Users\HEY!\Documents\Draft Paper 2021 Alpha\Rotimi\Study 2\Matlab\klt-files\output/Table1.mat','Table1')
%% 
clear
load('C:\Users\HEY!\Documents\Draft Paper 2021 Alpha\Rotimi\Study 2\Matlab\klt-files\output/ICTResult_i.mat')
load('C:\Users\HEY!\Documents\Draft Paper 2021 Alpha\Rotimi\Study 2\Matlab\klt-files\output/Table1.mat')
Table1(1,2)=betaIFE2.(1,2);
Table1(2,2)=seIFE2.(1,2);
Table1(1,4)=betaCCEp.(1;2);
Table1(2,4)=seCCEp.(1;2);
Table1(1,6)=betaCCEp2step.(1,2);
Table1(2,6)=seCCEp2step.(1,2);
save('C:\Users\HEY!\Documents\Draft Paper 2021 Alpha\Rotimi\Study 2\Matlab\klt-files\output/Table1.mat','Table1')
csvwrite('C:\Users\HEY!\Documents\Draft Paper 2021 Alpha\Rotimi\Study 2\Matlab\klt-files\output/Table1.csv',Table1)
delete('C:\Users\HEY!\Documents\Draft Paper 2021 Alpha\Rotimi\Study 2\Matlab\klt-files\output/Table1.mat')

%% Table 2
clear
load('../mydata/results_saa2BOTH2_iFE1ch.mat')
Table5=zeros(6,4);
Table5(1,1)=betaOLSMG(1,1);
Table5(2,1)=seOLSi(1,1);
Table5(1,2)=betaIFEH4(1,1);
Table5(2,2)=seIFEi4(1,1);
Table5(1,3)=betaCCEmg(1,1);
Table5(2,3)=seCCEmg(1,1);
Table5(1,4)=betaCCEmg2step(1,1);
Table5(2,4)=seCCEmg2step(1,1);
Table5(4,2)=J1ife(1,1);
Table5(4,3)=J1cce(1,1);
Table5(4,4)=J1cce2step(1,1);
Table5(5,2)=Tau1ife(1,1);
Table5(5,3)=Tau1cce(1,1);
Table5(5,4)=Tau1cce2step(1,1);
OLSneg=zeros(1,N);
IFEneg=zeros(1,N);
CCEneg=zeros(1,N);
CCE2neg=zeros(1,N);
for i=1:N
	if betaOLSi(1,i)>=0 
		OLSneg(1,i)=0;
	else
		OLSneg(1,i)=1;
	end
	if betaIFEi04(1,i)>=0 
		IFEneg(1,i)=0;
	else
		IFEneg(1,i)=1;
	end
	if betaCCEi(1,i)>=0 
		CCEneg(1,i)=0;
	else
		CCEneg(1,i)=1;
	end
	if betaCCEi2step(1,i)>=0 
		CCE2neg(1,i)=0;
	else
		CCE2neg(1,i)=1;
	end
end
Table5(6,1)=mean(OLSneg);
Table5(6,2)=mean(IFEneg);
Table5(6,3)=mean(CCEneg);
Table5(6,4)=mean(CCE2neg);
save('../output/Table5.mat','Table5')
csvwrite('../output/Table5.csv',Table5)
delete('../output/Table5.mat')

% Table D2
clear
load('../mydata/results_ss2aa2BOTH2_iFE2ch.mat')
TableD2=zeros(8,6);
TableD2(1,1)=beduc_ife(1,1);
TableD2(2,1)=seIFEplincom(1,1);
TableD2(1,3)=beduc_ccep(1,1);
TableD2(2,3)=seCCEplincom(1,1);
TableD2(1,5)=beduc_ccep2step(1,1);
TableD2(2,5)=seCCEp2steplincom(1,1);
save('../output/TableD2.mat','TableD2')
clear
load('../mydata/results_ss2aa2BOTH2_tFE2ch.mat')
load('../output/TableD2.mat')
TableD2(1,2)=beduc_ife(1,1);
TableD2(2,2)=seIFEplincom(1,1);
TableD2(1,4)=beduc_ccep(1,1);
TableD2(2,4)=seCCEplincom(1,1);
TableD2(1,6)=beduc_ccep2step(1,1);
TableD2(2,6)=seCCEp2steplincom(1,1);
save('../output/TableD2.mat','TableD2')

clear
load('../mydata/results_saa2a4BOTH2_iFE1ch.mat')
load('../output/TableD2.mat')
TableD2(4,1)=betaIFE8(1,1);
TableD2(5,1)=seIFE8(1,1);
TableD2(4,3)=betaCCEp(1,1);
TableD2(5,3)=seCCEp(1,1);
TableD2(4,5)=betaCCEp2step(1,1);
TableD2(5,5)=seCCEp2step(1,1);
save('../output/TableD2.mat','TableD2')
clear
load('../mydata/results_saa2a4BOTH2_tFE1ch.mat')
load('../output/TableD2.mat')
TableD2(4,2)=betaIFE7(1,1);
TableD2(5,2)=seIFE7(1,1);
TableD2(4,4)=betaCCEp(1,1);
TableD2(5,4)=seCCEp(1,1);
TableD2(4,6)=betaCCEp2step(1,1);
TableD2(5,6)=seCCEp2step(1,1);
save('../output/TableD2.mat','TableD2')

clear
load('../mydata/results_ss2aa2a4BOTH2_iFE2ch.mat')
load('../output/TableD2.mat')
TableD2(7,1)=beduc_ife(1,1);
TableD2(8,1)=seIFEplincom(1,1);
TableD2(7,3)=beduc_ccep(1,1);
TableD2(8,3)=seCCEplincom(1,1);
TableD2(7,5)=beduc_ccep2step(1,1);
TableD2(8,5)=seCCEp2steplincom(1,1);
save('../output/TableD2.mat','TableD2')
clear
load('../mydata/results_ss2aa2a4BOTH2_tFE2ch.mat')
load('../output/TableD2.mat')
TableD2(7,2)=beduc_ife(1,1);
TableD2(8,2)=seIFEplincom(1,1);
TableD2(7,4)=beduc_ccep(1,1);
TableD2(8,4)=seCCEplincom(1,1);
TableD2(7,6)=beduc_ccep2step(1,1);
TableD2(8,6)=seCCEp2steplincom(1,1);
save('../output/TableD2.mat','TableD2')
csvwrite('../output/TableD2.csv',TableD2)
delete('../output/TableD2.mat')

% Table D3
clear
load('../mydata/results_ss2aa2BOTH2_iFE2ch.mat')
TableD3=zeros(17,4);
TableD3(1,1)=beduc_olsmg_fix(1,1);
TableD3(2,1)=seOLSmglincom(1,1);
TableD3(1,2)=beduc_ifemg_fix(1,1);
TableD3(2,2)=seIFEmglincom(1,1);
TableD3(1,3)=beduc_ccemg_fix(1,1);
TableD3(2,3)=seCCEmglincom(1,1);
TableD3(1,4)=beduc_ccemg2step_fix(1,1);
TableD3(2,4)=seCCEmg2lincom(1,1);
TableD3(3,2)=J1ife(1,1);
TableD3(3,3)=J1cce(1,1);
TableD3(3,4)=J1cce2step(1,1);
TableD3(4,2)=Tau1ife(1,1);
TableD3(4,3)=Tau1cce(1,1);
TableD3(4,4)=Tau1cce2step(1,1);
OLSneg=zeros(1,N);
IFEneg=zeros(1,N);
CCEneg=zeros(1,N);
CCE2neg=zeros(1,N);
for i=1:N
	if beduc_olsi_fix(1,i)>=0 
		OLSneg(1,i)=0;
	else
		OLSneg(1,i)=1;
	end
	if beduc_ifei_fix(1,i)>=0 
		IFEneg(1,i)=0;
	else
		IFEneg(1,i)=1;
	end
	if beduc_ccei_fix(1,i)>=0 
		CCEneg(1,i)=0;
	else
		CCEneg(1,i)=1;
	end
	if beduc_ccei2step_fix(1,i)>=0 
		CCE2neg(1,i)=0;
	else
		CCE2neg(1,i)=1;
	end
end
TableD3(5,1)=mean(OLSneg);
TableD3(5,2)=mean(IFEneg);
TableD3(5,3)=mean(CCEneg);
TableD3(5,4)=mean(CCE2neg);
save('../output/TableD3.mat','TableD3')

clear
load('../mydata/results_saa2a4BOTH2_iFE1ch.mat')
load('../output/TableD3.mat')
TableD3(7,1)=betaOLSMG(1,1);
TableD3(8,1)=seOLSi(1,1);
TableD3(7,2)=betaIFEH4(1,1);
TableD3(8,2)=seIFEi4(1,1);
TableD3(7,3)=betaCCEmg(1,1);
TableD3(8,3)=seCCEmg(1,1);
TableD3(7,4)=betaCCEmg2step(1,1);
TableD3(8,4)=seCCEmg2step(1,1);
TableD3(9,2)=J1ife(1,1);
TableD3(9,3)=J1cce(1,1);
TableD3(9,4)=J1cce2step(1,1);
TableD3(10,2)=Tau1ife(1,1);
TableD3(10,3)=Tau1cce(1,1);
TableD3(10,4)=Tau1cce2step(1,1);
OLSneg=zeros(1,N);
IFEneg=zeros(1,N);
CCEneg=zeros(1,N);
CCE2neg=zeros(1,N);
for i=1:N
	if betaOLSi(1,i)>=0 
		OLSneg(1,i)=0;
	else
		OLSneg(1,i)=1;
	end
	if betaIFEi04(1,i)>=0 
		IFEneg(1,i)=0;
	else
		IFEneg(1,i)=1;
	end
	if betaCCEi(1,i)>=0 
		CCEneg(1,i)=0;
	else
		CCEneg(1,i)=1;
	end
	if betaCCEi2step(1,i)>=0 
		CCE2neg(1,i)=0;
	else
		CCE2neg(1,i)=1;
	end
end
TableD3(11,1)=mean(OLSneg);
TableD3(11,2)=mean(IFEneg);
TableD3(11,3)=mean(CCEneg);
TableD3(11,4)=mean(CCE2neg);
save('../output/TableD3.mat','TableD3')

clear
load('../mydata/results_ss2aa2a4BOTH2_iFE2ch.mat')
load('../output/TableD3.mat')
TableD3(13,1)=beduc_olsmg_fix(1,1);
TableD3(14,1)=seOLSmglincom(1,1);
TableD3(13,2)=beduc_ifemg_fix(1,1);
TableD3(14,2)=seIFEmglincom(1,1);
TableD3(13,3)=beduc_ccemg_fix(1,1);
TableD3(14,3)=seCCEmglincom(1,1);
TableD3(13,4)=beduc_ccemg2step_fix(1,1);
TableD3(14,4)=seCCEmg2lincom(1,1);
TableD3(15,2)=J1ife(1,1);
TableD3(15,3)=J1cce(1,1);
TableD3(15,4)=J1cce2step(1,1);
TableD3(16,2)=Tau1ife(1,1);
TableD3(16,3)=Tau1cce(1,1);
TableD3(16,4)=Tau1cce2step(1,1);
OLSneg=zeros(1,N);
IFEneg=zeros(1,N);
CCEneg=zeros(1,N);
CCE2neg=zeros(1,N);
for i=1:N
	if beduc_olsi_fix(1,i)>=0 
		OLSneg(1,i)=0;
	else
		OLSneg(1,i)=1;
	end
	if beduc_ifei_fix(1,i)>=0 
		IFEneg(1,i)=0;
	else
		IFEneg(1,i)=1;
	end
	if beduc_ccei_fix(1,i)>=0 
		CCEneg(1,i)=0;
	else
		CCEneg(1,i)=1;
	end
	if beduc_ccei2step_fix(1,i)>=0 
		CCE2neg(1,i)=0;
	else
		CCE2neg(1,i)=1;
	end
end
TableD3(17,1)=mean(OLSneg);
TableD3(17,2)=mean(IFEneg);
TableD3(17,3)=mean(CCEneg);
TableD3(17,4)=mean(CCE2neg);
save('../output/TableD3.mat','TableD3')
csvwrite('../output/TableD3.csv',TableD3)
delete('../output/TableD3.mat')



% OLS cross-section dependence test statistics (supplement for T3 and D1)
clear
load('../mydata/results_saa2BOTH2_iFE1ch.mat')
TableCDstats=zeros(5,3);
TableCDstats(1,1)=CSDstatResOLS_saaFEi;
save('../output/TableCDstats.mat','TableCDstats')
clear
load('../mydata/results_saa2BOTH2_tFE1ch.mat')
load('../output/TableCDstats.mat','TableCDstats')
TableCDstats(1,2)=CSDstatResOLS_saaFEt;
TableCDstats(1,3)=CSDstatResIV_saaFEt;
save('../output/TableCDstats.mat','TableCDstats')
clear
load('../mydata/results_ss2aa2BOTH2_iFE2ch.mat')
load('../output/TableCDstats.mat','TableCDstats')
TableCDstats(2,1)=CSDstatResOLS_ssaaFEi;
save('../output/TableCDstats.mat','TableCDstats')
clear
load('../mydata/results_ss2aa2BOTH2_tFE2ch.mat')
load('../output/TableCDstats.mat','TableCDstats')
TableCDstats(2,2)=CSDstatResOLS_ssaaFEt;
TableCDstats(2,3)=CSDstatResIV_ssaaFEt;
save('../output/TableCDstats.mat','TableCDstats')
clear
load('../mydata/results_saa2a4BOTH2_iFE1ch.mat')
load('../output/TableCDstats.mat','TableCDstats')
TableCDstats(3,1)=CSDstatResOLS_saa2a4FEi;
save('../output/TableCDstats.mat','TableCDstats')
clear
load('../mydata/results_saa2a4BOTH2_tFE1ch.mat')
load('../output/TableCDstats.mat','TableCDstats')
TableCDstats(3,2)=CSDstatResOLS_saa2a4FEt;
TableCDstats(3,3)=CSDstatResIV_saa2a4FEt;
save('../output/TableCDstats.mat','TableCDstats')
clear
load('../mydata/results_ss2aa2a4BOTH2_iFE2ch.mat')
load('../output/TableCDstats.mat','TableCDstats')
TableCDstats(4,1)=CSDstatResOLS_ss2aa2a4FEi;
save('../output/TableCDstats.mat','TableCDstats')
clear
load('../mydata/results_ss2aa2a4BOTH2_tFE2ch.mat')
load('../output/TableCDstats.mat','TableCDstats')
TableCDstats(4,2)=CSDstatResOLS_ss2aa2a4FEt;
TableCDstats(4,3)=CSDstatResIV_ss2aa2a4FEt;
save('../output/TableCDstats.mat','TableCDstats')
clear
load('../mydata/results_saa2BOTH2_iFE1ch.mat')
load('../output/TableCDstats.mat','TableCDstats')
TableCDstats(5,1)=CSDstatResOLS_saaFEiDemoByYear;
save('../output/TableCDstats.mat','TableCDstats')
clear
load('../mydata/results_saa2BOTH2_tFE1ch.mat')
load('../output/TableCDstats.mat','TableCDstats')
TableCDstats(5,2)=CSDstatResOLS_saaFEtDemoByYear;
save('../output/TableCDstats.mat','TableCDstats')
csvwrite('../output/TableCDstats.csv',TableCDstats)
delete('../output/TableCDstats.mat')


% Export individual beta_i's for analysis in Stata
clear
load('../mydata/results_saa2BOTH2_iFE1ch.mat')
csvwrite('../mydata/betais_ols.csv',betaOLSi(1,:)');
csvwrite('../mydata/betais_ife.csv',betaIFEi04(1,1:N)');
csvwrite('../mydata/betais_cce.csv',betaCCEi(1,:)');
csvwrite('../mydata/betais_cce2.csv',betaCCEi2step(1,:)');





