*********************************************************************                             
*                                                                   
*  PROGRAM DESCRIPTION: Process data from the Dental Study;
*                                                                   
*-------------------------------------------------------------------
*  JOB NAME:       dental-data.sas                                   
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
%setup(DENTAL-DATA,C:\USERS\PSIODA\DESKTOP\BIOS-767);

/*
data fitz.dental(rename=(y1=age8 y2=age10 y3=age12 y4=age14));
 set fitz.dental;
run;
*/

/** code to write CSV files from SAS **/
data _null_;
 set dat2.dental;
 file "&datPath2.&slash.dental-data.txt" dlm=',';
 put id gender age8 age10 age12 age14;
run;
