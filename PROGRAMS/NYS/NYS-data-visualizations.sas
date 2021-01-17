*********************************************************************                             
*                                                                   
*  PROGRAM DESCRIPTION: Visualize data from the National Youth Study;
*                                                                   
*-------------------------------------------------------------------
*  JOB NAME:       NYS-data-visualizations.sas                                   
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
%setup(NYS-DATA-VISUALIZATIONS,C:\USERS\PSIODA\DESKTOP\BIOS-767);

proc format;
 value numdisp
  . = "(missing)"
  other=[6.1];
run;

/**************** Produce Data Listing for Random Sample of Dental Study Children *****/
data nys_deviance;
 set dat2.nys_deviance;
 where caseid in (3 158);
run;

ods escapechar='^';
option papersize=("8.5in","11.0in") topmargin=0.1in rightmargin=0.1in leftmargin=0.1in bottommargin=0.1in;
ods pdf file = "&outpath.&slash.NYS-Table1.pdf" style=journal;
title1 "Listing of National Youth Study Data for Case ID 3 and 158";
proc report data = nys_deviance missing;
	column (caseid sexc ethcat baseattdev exposure age attdev);

	define caseid     / "Case ID" group    format=z4.   		style={just=l cellwidth=0.70in};
	define sexc       /           group    format=$10.  		style={just=l cellwidth=0.80in};
	define ethcat     /           group    format=$40.  		style={just=l cellwidth=1.25in};
	define baseattdev /           group    format=numdisp.   	style={just=c cellwidth=1in};
	define exposure   /           group    format=numdisp.   	style={just=c cellwidth=1in};
	define age        /           group    format=3.         	style={just=c cellwidth=1in};
	define attdev     /           display  format=numdisp.   	style={just=c cellwidth=1in};

	compute before caseid;
		line @1 " ";
	endcomp;
run;
ods pdf close;

proc transpose data = dat2.nys_deviance out = missing(drop=_:) prefix=age;
	by caseid;
		id age;
		var attdev;
run;

ods noproctitle;
option papersize=("10.2in","7.7in") topmargin=0.1in rightmargin=0.1in leftmargin=0.1in bottommargin=0.1in;
ods graphics / reset  height=7.5in width=10in noborder;
ods pdf file = "&outpath.&slash.NYS-Table2.pdf" style=journal;
title1 "Missing Data Patterns for Attitudes Toward Deviance Score by Age";
title2;
ods pdf select MissPattern ;
proc mi data = missing nimpute=2;
	var age:;
run;
ods pdf close;

ods escapechar='^';
option papersize=("10.2in","3.7in") topmargin=0.1in rightmargin=0.1in leftmargin=0.1in bottommargin=0.1in;
ods graphics / reset  height=3.5in width=10in noborder;
ods pdf file = "&outpath.&slash.NYS-Figure1.pdf" style=journal;
title1 "Histograms of Attitudes Toward Deviance Score by Age";
	proc sgpanel data = dat2.nys_deviance;
		panelby age / rows=1 onepanel;
		histogram attdev / nbins=12 binstart=0;
		colaxis values=(1 to 4 by 0.5);
	run;
ods pdf close;


ods escapechar='^';
option papersize=("10.2in","3.7in") topmargin=0.1in rightmargin=0.1in leftmargin=0.1in bottommargin=0.1in;
ods graphics / reset  height=3.5in width=10in noborder;
ods pdf file = "&outpath.&slash.NYS-Figure2.pdf";
title1 "Scatter Plot and Regresion Line for Baseline Exposure and Attitudes Toward Deviance Score by Age";
proc sgpanel data = dat2.nys_deviance noautolegend;
	panelby age / rows=1 onepanel;    
	reg x=exposure y=attdev / jitter;
	colaxis values=(1 to 4 by 0.5);
	rowaxis values=(2 to 4 by 0.5);
run;
ods pdf close;



