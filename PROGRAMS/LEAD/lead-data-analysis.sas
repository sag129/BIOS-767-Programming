*********************************************************************                             
*                                                                   
*  PROGRAM DESCRIPTION: Analysis of data from the Treatment of Lead-
*                       Exposed Children (TLC) Trial;
*                                                                   
*-------------------------------------------------------------------
*  JOB NAME:       lead-data-analysis.sas                                   
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
%setup(LEAD-DATA-ANALYSIS,C:\USERS\PSIODA\DESKTOP\BIOS-767);

/***************************************** Statistical Analysis -- URMA *********************************/
option papersize=("8.5in","11.0in") topmargin=0.1in rightmargin=0.1in leftmargin=0.1in bottommargin=0.1in;
ods noptitle;
ods pdf file = "&outpath.&slash.Lead-URMA-Analysis.pdf" nogtitle dpi=350;
ods graphics / reset noborder;
title1 j=c "Analysis of blood lead levels -- Univariate Repeated Measures ANOVA";
proc glm data = dat2.tlc plots=all;
 class trt;
 model y0 y1 y4 y6 = trt / nouni ;
 repeated week / nom;
run;
quit;
ods pdf close;

/***************************************** Statistical Analysis -- MRMA *********************************/
option papersize=("8.5in","11.0in") topmargin=0.1in rightmargin=0.1in leftmargin=0.1in bottommargin=0.1in;
ods noptitle;
ods pdf file = "&outpath.&slash.Lead-MANOVA-Analysis.pdf" nogtitle dpi=350;
ods graphics / reset noborder;
title1 j=c "Analysis of blood lead levels -- MANOVA";
proc glm data = dat2.tlc plots=all;
 class trt;
 model y0 y1 y4 y6 = trt / nouni ;
 repeated week / nou mstat=exact;
run;
quit;
ods pdf close;


/***************************************** Statistical Analysis -- MVN *********************************/
data analysis_data;
  set dat2.tlc;
	array mn[4] y0 y1 y4 y6;
	do j = 1 to dim(mn);
		bloodlevel = mn[j];
		week       = 0*(j=1) + 1*(j=2) + 4*(j=3) + 6*(j=4);
		output;
	end;
	drop j;
run;


option papersize=("8.5in","11.0in") topmargin=0.1in rightmargin=0.1in leftmargin=0.1in bottommargin=0.1in;
ods noptitle;
ods pdf file = "&outpath.&slash.Lead-MVN-Analysis.pdf" nogtitle dpi=350;
ods graphics / reset noborder;
title1 j=c "Analysis of blood lead levels -- Multivariate Normal Model";
proc mixed data = analysis_data method=reml plots=all;
 class trt(ref='P') week;
 model bloodlevel = trt*week / noint solution ddfm=kr2 vciry ;
 repeated week / subject=id type=un r;

  contrast "Treatment Effect" trt*week 0  1  0  0   0 -1  0  0,
							  trt*week 0  0  1  0   0  0 -1  0,
							  trt*week 0  0  0  1   0  0  0 -1;

 estimate "Week 1" trt*week 0  1  0  0   0 -1  0  0;
 estimate "Week 4" trt*week 0  0  1  0   0  0 -1  0;
 estimate "Week 6" trt*week 0  0  0  1   0  0  0 -1;
run;
ods pdf close;


/***************************************** Statistical Analysis -- LMM *********************************/
data analysis_data2;
  set dat2.tlc;
	array mn[3] y1 y4 y6;
	do j = 1 to dim(mn);
		bloodlevel = mn[j] - y0;
		week       = 1*(j=1) + 4*(j=2) + 6*(j=3);
		week1      = (j=1);
		week4      = (j=2);
        week6      = (j=3);
		output;
	end;
	drop j y:;
run;

option papersize=("8.5in","11.0in") topmargin=0.1in rightmargin=0.1in leftmargin=0.1in bottommargin=0.1in;
ods noptitle;
ods pdf file = "&outpath.&slash.Lead-LMM-Analysis.pdf" nogtitle dpi=350;
ods graphics / reset noborder;
title1 j=c "Analysis of change fromm baseline blood lead levels -- Linear Mixed Model";
proc mixed data = analysis_data2 method=reml plots=all covtest;
 class trt(ref='P') ;
 model bloodlevel = trt*week1 trt*week4 trt*week6 / noint solution ddfm=kr2 vciry ;
 random intercept week4 week6 / subject=id type=cs G;

  contrast "Treatment Effect" trt*week1 1 -1,
                              trt*week4 1 -1,
							  trt*week6 1 -1;
run;
ods pdf close;




/***************************************** Statistical Analysis -- GEE *********************************/
data analysis_data;
  set dat2.tlc;
	array mn[4] y0 y1 y4 y6;
	do j = 1 to dim(mn);
		bloodlevel = mn[j];
		week       = 0*(j=1) + 1*(j=2) + 4*(j=3) + 6*(j=4);
		output;
	end;
	drop j;
run;

option papersize=("8.5in","11.0in") topmargin=0.1in rightmargin=0.1in leftmargin=0.1in bottommargin=0.1in;
ods noptitle;
ods pdf file = "&outpath.&slash.Lead-GEE-Analysis.pdf" nogtitle dpi=350;
ods graphics / reset noborder;
title1 j=c "Analysis of blood lead levels -- Generalized Estimating Equations";
proc genmod data = analysis_data  plots=all;
 class trt(ref='P') week id;
 model bloodlevel = trt*week / noint ;
 repeated subject=id / type=ar(1) corrw ;

 contrast "Treatment Effect"  trt*week 0  1  0  0  0 -1  0  0,
							  trt*week 0  0  1  0  0  0 -1  0,
							  trt*week 0  0  0  1  0  0  0 -1;

 estimate "Week 1" trt*week 0  1  0  0   0 -1  0  0;
 estimate "Week 4" trt*week 0  0  1  0   0  0 -1  0;
 estimate "Week 6" trt*week 0  0  0  1   0  0  0 -1;
run;
ods pdf close;
