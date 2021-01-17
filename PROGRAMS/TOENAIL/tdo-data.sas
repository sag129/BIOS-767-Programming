*********************************************************************                             
*                                                                   
*  PROGRAM DESCRIPTION: Process data from the Toenail data;
*                                                                   
*-------------------------------------------------------------------
*  JOB NAME:       tdo-data.sas                                   
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
%setup(TDO-DATA,C:\USERS\PSIODA\DOCUMENTS\GITHUB\BIOS-767-PROGRAMMING);

/** code to write SAS dataset from source file **/
data _null_;
 set dat2.toenail;
 file "&datPath2.&slash.toenail.tab" dlm='09'x;
 put idnum time treatn y;                                              
run;
