*********************************************************************                             
*                                                                   
*  PROGRAM DESCRIPTION: analysis data from the ICHS Study;
*                                                                   
*-------------------------------------------------------------------
*  JOB NAME:       xerop-data-analysis.sas                                   
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
%setup(XEROP-DATA-ANALYSIS,C:\USERS\PSIODA\DESKTOP\BIOS-767);

proc format;
 value season
  1 = "Summer"
  2 = "Autumn"
  3 = "Winter"
  4 = "Spring"
  5 = "Summer"
  6 = "Autumn";
 value xerop
  0 = 'No'
  1 = 'Yes'
 99 = 'Overall';
run;
quit;

option papersize=("8.5in","11.0in") topmargin=0.1in rightmargin=0.1in leftmargin=0.1in bottommargin=0.1in;
ods graphics / reset height=6.0in width=2.0in noborder;
ods pdf file = "&outpath.&slash.XEROP-Figure3.pdf" style=sasweb startpage=no dpi=200;
title;

ods pdf exclude ClassLevels ;
 proc genmod data = dat2.xerop;
  class id time(ref='Spring');
  format time season.;
  model respInf(event='1') = age xerop time / dist=bin link=logit;
  repeated subject=id / type=AR;
 run;

ods pdf close;
