*********************************************************************                             
*                                                                   
*  PROGRAM DESCRIPTION: Process data from the National Youth Survey;
*                                                                   
*-------------------------------------------------------------------
*  JOB NAME:       NYS-data.sas                                   
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
%setup(NYS-DATA,C:\USERS\PSIODA\DOCUMENTS\GITHUB\BIOS-767-PROGRAMMING);


%macro cimp(yr,prefix);
filename s&yr. "&datPath2.\ICPSR_0&prefix.\DS0001\0&prefix.-0001-Data.stc";
proc cimport library=work infile=s&yr.; run;
data dat2.NYS_&yr.(label="19&yr. Wave"); set work.DA&prefix.P1; run;

ods html path="&datPath2." file="NYS-&yr.-contents.html";
    ods html select variables;
	proc contents data = dat2.nys_&yr. out=temp; run;
ods html close;
%mend;

%cimp(76,8375);
%cimp(77,8424);
%cimp(78,8506);
%cimp(79,8917);
%cimp(80,9112);
%cimp(83,9948);
%cimp(87,6542);
