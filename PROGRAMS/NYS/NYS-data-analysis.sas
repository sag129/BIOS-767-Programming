*********************************************************************                             
*                                                                   
*  PROGRAM DESCRIPTION: Analysis of data from the National Youth Study;
*                                                                   
*-------------------------------------------------------------------
*  JOB NAME:       NYS-data-analysis.sas                                   
*  LANGUAGE:       SAS, VERSION 9.4                                  
*                                                                   
*  NAME:           Matthew Psioda                               
*  DATE COMPLETE:  2020-12-30                                           
*-------------------------------------------------------------------
*                                                                   
*  Modification History:       
*                                                                                                                         
*  NAME:                         << Insert Name of Primary Programmer >>                               
*  DATE COMPLETE:                << YYYY-MM-DD >>   
*  DESCRIPTION OF MODIFICATION:  << Please insert 2-3 sentences >>                                                               
********************************************************************;
%include "C:\USERS\PSIODA\DESKTOP\BIOS-767\MACROS\SETUP.SAS";
%setup(NYS-DATA-ANALYSIS,C:\USERS\PSIODA\DESKTOP\BIOS-767);


/***************************************** Statistical Analysis -- MRMA *********************************/
option papersize=("8.5in","11.0in") topmargin=0.1in rightmargin=0.1in leftmargin=0.1in bottommargin=0.1in;
ods noptitle;
ods pdf file = "&outpath.&slash.NYS-Deviance-Analysis.pdf" nogtitle dpi=350;
ods graphics / reset noborder;
title1 j=c "Analysis Via the Linear Mixed Model";
proc mixed data = dat2.nys_deviance plots=all;
	class sexc(ref='Male') ethCat(ref='White') caseid ;
	model ATTDEV = sexc ethCat exposure age / solution ;
	random intercept age / subject=caseid type=un;
run;
quit;
ods pdf close;

