*********************************************************************                             
*                                                                   
*  PROGRAM DESCRIPTION: Visualize data from the Toenail data;
*                                                                   
*-------------------------------------------------------------------
*  JOB NAME:       tdo-data-visualizations.sas                                   
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
%include "C:\USERS\PSIODA\DOCUMENTS\GITHUB\BIOS-767-PROGRAMMING\MACROS\SETUP.SAS";
%setup(TDO-DATA-VISUALIZATIONS,C:\USERS\PSIODA\DOCUMENTS\GITHUB\BIOS-767-PROGRAMMING);


proc format;
 value visit
  0 = "Baseline"
  1 = "Month 1"
  2 = "Month 2"
  3 = "Month 3"
  6 = "Month 6"
  9 = "Month 9"
 12 = "Month 12";
 value treat
  0 = 'A'
  1 = 'B';
run;
quit;

/** Table of Number of Visits for Participants **/
proc freq data = dat2.toenail noprint;
	table treatn*idnum / out = numMeasures(drop=percent rename=(count=numMeasures));
run;
proc freq data = numMeasures noprint;
    by treatn;
	table numMeasures / out = distNumMeasures outcum;
run;

data table1;
 merge distNumMeasures(where=(treatn=0) rename=(count=countA percent=percentA cum_pct=cPercentA))
       distNumMeasures(where=(treatn=1) rename=(count=countB percent=percentB cum_pct=cPercentB));
 by numMeasures;
run;

ods escapechar='^';
option papersize=("7.5in","3.0in") topmargin=0.1in rightmargin=0.1in leftmargin=0.1in bottommargin=0.1in;
ods pdf file = "&outpath.&slash.TDO-Table1.pdf" style=journal;
title1 "Number and Percentage of Assessments Completed";
proc report data = table1 split='^';
	column (numMeasures ("Treatment Group A" CountA PercentA cPercentA) 
                        ("Treatment Group B" CountB PercentB cPercentB));
	define numMeasures / "Number of^Measurements" group    format=1.  style={just=d cellwidth=1in};

	define CountA       / "Count"                  display  format=3.  style={just=d cellwidth=1in};
	define PercentA     / "Percent"                display  format=6.2 style={just=d cellwidth=1in};
	define cPercentA    / "Cumulative^Percent"     display  format=6.2 style={just=d cellwidth=1in};

	define CountB       / "Count"                  display  format=3.  style={just=d cellwidth=1in};
	define PercentB     / "Percent"                display  format=6.2 style={just=d cellwidth=1in};
	define cPercentB    / "Cumulative^Percent"     display  format=6.2 style={just=d cellwidth=1in};
run;
ods pdf close;



/** Table of Number of Visits for Participants **/
proc sort data = dat2.toenail out = toenail;
 by treatn;
run;

proc freq data = toenail noprint;
    by treatn;
	table time / out = distTimes(drop=percent);
run;

data distTimes2;
 merge distTimes distTimes(where=(time=0) rename=(count=den));
 by treatn;

  percent = count/den;
  drop den:;
run;


data table2;
 merge distTimes2(where=(treatn=0) rename=(count=countA percent=percentA))
       distTimes2(where=(treatn=1) rename=(count=countB percent=percentB));
 by time;
run;

ods escapechar='^';
option papersize=("5.5in","3.0in") topmargin=0.1in rightmargin=0.1in leftmargin=0.1in bottommargin=0.1in;
ods pdf file = "&outpath.&slash.TDO-Table2.pdf" style=journal;
title1 "Number and Percentage of Patients Completing Each Visit";
proc report data = table2 split='^';
	column (time ("Treatment Group A" CountA PercentA) 
                 ("Treatment Group B" CountB PercentB));
	define time         / "Visit" order=data                format=visit. style={just=c cellwidth=1in};

	define CountA       / "Count"                  display  format=3.     style={just=d cellwidth=1in};
	define PercentA     / "Percent"                display  format=6.2    style={just=d cellwidth=1in};

	define CountB       / "Count"                  display  format=3.     style={just=d cellwidth=1in};
	define PercentB     / "Percent"                display  format=6.2    style={just=d cellwidth=1in};
run;
ods pdf close;



/**************** Figure of Severe Infection by Visit and Treatment Group *****/
proc means data = dat2.toenail noprint;
 class time treatn;
 var y;
 types time*treatn;
 output out = summary n=nSev mean=pSev;
run;

data plotData;
 set summary;
  y = round(nSev*pSev);
  display = strip(put(y,4.))||'/'||strip(put(nSev,4.))||'$('||strip(put(pSev,6.3))||')';
run;


option papersize=("9.2in","8.7in") topmargin=0.1in rightmargin=0.1in leftmargin=0.1in bottommargin=0.1in;
ods graphics / reset height=4in width=9in noborder;
ods pdf file = "&outpath.&slash.TDO-Figure1.pdf" style=sasweb startpage=no dpi=350;
title1 j=c "Proportion of Patients with Severe Infection by Visit and Treatment Group";
footnote;

proc sgplot data = plotData;
 vbar time / group=treatn groupdisplay=cluster response=pSev stat=sum 
              datalabel=display datalabelfitpolicy=splitalways splitchar='$';
 yaxis label='Proportion';

 format time visit. treatn treat.;
 label treatn = 'Treatment Group' time = 'Visit';
run;

title;
proc sgplot data = plotData;
 vbar treatn / group=time groupdisplay=cluster response=pSev stat=sum 
              datalabel=display datalabelfitpolicy=splitalways splitchar='$';
 yaxis label='Proportion';

 format time visit. treatn treat.;
 label treatn = 'Treatment Group' time = 'Visit';
run;

ods pdf close;




/**************** Figure of Severe Infection by Visit and Treatment Group *****/
proc means data = dat2.toenail noprint;
 class time treatn;
 var y;
 types time*treatn;
 output out = summary n=nSev mean=pSev;
run;

option papersize=("9.2in","4.7in") topmargin=0.1in rightmargin=0.1in leftmargin=0.1in bottommargin=0.1in;
ods graphics / reset height=4in width=9in noborder;
ods pdf file = "&outpath.&slash.TDO-Figure2.pdf" style=sasweb startpage=no dpi=350;
title1 j=c "Proportion of Patients with Severe Infection by Visit and Treatment Group";
footnote;

proc sgplot data = plotData;
 series x=time y=pSev / group=treatn markers markerattrs=(symbol=circleFilled) datalabel=nSev ;
 yaxis label='Proportion' values=(0.00 to 0.50 by 0.10);
 xaxis label='Visit' values=(0 1 2 3 6 9 12) valuesformat=visit.;
 keylegend / position=topright location=inside;

 format time visit. treatn treat.;
 label treatn = 'Treatment Group' time = 'Visit';
run;

ods pdf close;
