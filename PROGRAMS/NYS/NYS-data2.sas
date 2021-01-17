*********************************************************************                             
*                                                                   
*  PROGRAM DESCRIPTION: Process data from the National Youth Survey;
*                                                                   
*-------------------------------------------------------------------
*  JOB NAME:       NYS-data2.sas                                   
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
%setup(NYS-DATA2,C:\USERS\PSIODA\DESKTOP\BIOS-767);


%macro varDetails(yr,Varlist);
proc contents data = dat2.nys_&yr.(keep=&varList.) out=temp noprint; run;
ods html path="." file="temp.html";
 proc print data = temp noobs;
  var name label;
 run;
ods html close;
%mend;

%macro modify(yr=,houseID=,youthID=,sex=,ethnicity=,age=,outcome=NONE,exposure=NONE,filter=NONE,filter2=NONE);
%let outcomeVarList = cheat|property|marijuana|steal5|hitperson|alcohol|breakin|selldrugs|steal50;

data temp;
	set dat2.nys_&yr.;
		%if &filter ^= NONE %then %do;
			where &filter.;
		%end;
run;

data dat2.nys_&yr._mod;
	set temp(keep=CASEID &houseID. &youthID. &sex. &ethnicity. &age. 
                 %if %scan(&outcome.,1,|)  ^= NONE %then %do;  %sysfunc(tranwrd(&outcome.,|,%str( )))  %end;
                 %if %scan(&exposure.,1,|) ^= NONE %then %do;  %sysfunc(tranwrd(&exposure.,|,%str( ))) %end;
            );

	%if %scan(&outcome,1,|) ^= NONE %then %do; 
		array dev[%eval(%sysfunc(count(&outcome,|))+1)] %sysfunc(tranwrd(&outcome.,|,%str( )));
		do j = 1 to %eval(%sysfunc(count(&outcome,|))+1);
			if dev{j} not in (1,2,3,4) then do;
				put dev{j}=;
				dev{j} = .;
			end;
		end;
		ATTDEV   = mean(of dev[*]);
		NMISSDEV = nMiss(of dev[*]);
	%end;
	%if %scan(&exposure,1,|) ^= NONE %then %do; 
		array edev[%eval(%sysfunc(count(&exposure,|))+1)] %sysfunc(tranwrd(&exposure.,|,%str( )));
		do j = 1 to %eval(%sysfunc(count(&exposure,|))+1);
			if edev{j} not in (1,2,3,4) then do;
				put edev{j}=;
				edev{j} = .;
			end;
		end;
		EXPOSURE  = mean(of edev[*]);
		NMISSEDEV = nMiss(of edev[*]);
	%end;

	drop j;
	rename 
    &houseID.   = houseID 
    &youthID.   = youthID 
	&sex.       = sex 
	&ethnicity. = ethnicity 
	&age.       = Age 

	%if %scan(&outcome,1,|) ^= NONE %then %do; 
		%do j = 1 %to %eval(%sysfunc(count(&outcome,|))+1);
			%scan(&outcome,&j,|) = %scan(&outcomeVarList,&j,|)
		%end;
	%end;
	%if %scan(&exposure,1,|) ^= NONE %then %do; 
		%do j = 1 %to %eval(%sysfunc(count(&exposure,|))+1);
			%scan(&exposure,&j,|) = e%scan(&outcomeVarList,&j,|)
		%end;
	%end;;

	%if %scan(&filter2,1,|) ^= NONE %then %do;
			if &filter2.;
	%end;

	label ATTDEV    = 'Attitudes Toward Deviance'
          NMISSDEV  = 'Attitudes Toward Deviance (missing)'
          EXPOSURE  = 'Exposure To Delinquency'
          NMISSEDEV = 'Exposure To Delinquency (missing)';
run;

%mend;

%varDetails(76,V65 V66 V167 V168 V169 V170 V171 V356--V364);
%modify(yr=76,houseID=V65,youthID=V66,sex=V167,ethnicity=V168,age=V169,
		outcome=V356|V357|V358|V359|V360|V361|V362|V363|V364,
		exposure=V365|V366|V367|V368|V369|V370|V371|V372|V373|V374,filter=V169=11,filter2=ATTDEV>. and EXPOSURE>.);

%varDetails(77,V70 V71 V5 V6 V7 V196--V207);
%modify(yr=77,houseID=V70,youthID=V71,sex=V5,  ethnicity=V6,  age=V7,  outcome=V196|V197|V198|V199|V200|V201|V202|V203|V204);

%varDetails(78,V44 V45 V5 V6 V10 V84 V85 V294--V305);
%modify(yr=78,houseID=V44,youthID=V45,sex=V5,  ethnicity=V6,  age=V10, outcome=V294|V295|V296|V297|V298|V299|V300|V301|V302);

%varDetails(79,V60 V61 V1 V2 V6 V28 V32 V274--V285);
%modify(yr=79,houseID=V60,youthID=V61,sex=V1,  ethnicity=V2,  age=V6,  outcome=V274|V275|V276|V277|V278|V279|V280|V281|V282);

%varDetails(80,V58 V59 V1 V2 V6 V41 V45 V301--V312);
%modify(yr=80,houseID=V58,youthID=V59,sex=V1,  ethnicity=V2,  age=V6,  outcome=V301|V302|V303|V304|V305|V306|V307|V308|V309);

%varDetails(83,V48 V49 V1 V2 V6 V105 V109 V354--V368);
%modify(yr=83,houseID=V48,youthID=V49,sex=V1,  ethnicity=V2,  age=V6,  outcome=V354|V355|V356|V357|V358|V359|V360|V361|V362);

%varDetails(87,HHLD1 RESP1 Y7_2 Y7_3 Y7_7  Y7_420--Y7_435);
%modify(yr=87,houseID=HHLD1,youthID=RESP1,sex=Y7_2,  ethnicity=Y7_3,  age=Y7_7,  outcome=Y7_420|Y7_421|Y7_422|Y7_423|Y7_424|Y7_425|Y7_426|Y7_427|Y7_428);


data nys_deviance;
 set dat2.nys_76_mod
     dat2.nys_77_mod
     dat2.nys_78_mod
     dat2.nys_79_mod
     dat2.nys_80_mod
     dat2.nys_83_mod
     dat2.nys_87_mod;
 by caseid;
run;

data dat2.nys_deviance(drop=HOUSEID YOUTHID);
  label CASEID     = 'Case ID'
        SEX        = 'Sex'
        SEXC       = 'Sex (Character)'
        ETHNICITY  = 'Ethnicity (Character)'
        ETHCAT     = 'Ethnicity Category'
        AGE        = 'Age (Years)'
        BASEATTDEV = 'Baseline Attitudes Toward Deviance'
        EXPOSURE   = 'Baseline Exposure To Delinquency';

 merge nys_deviance(in=a keep = CASEID HOUSEID YOUTHID AGE ATTDEV) 
  dat2.nys_76_mod(in=b keep = CASEID ATTDEV EXPOSURE SEX ETHNICITY rename=(ATTDEV=BASEATTDEV));
 by caseid;
  if a and b;

  label BASEATTDEV = 'Baseline Attitudes Toward Deviance'
        EXPOSURE   = 'Baseline Exposure To Delinquency'
        SEXC       = 'Sex (Character)'
        ETHCAT     = 'Ethnicity (Character)'
        Age        = 'Age (Years)';

  length SEXC $10 ethCat $30;

		     if sex = 1 then sexc = 'Male';
		else if sex = 2 then sexc = 'Female';

		     if ethnicity  = 1 then ethCat = 'White';
		else if ethnicity  = 2 then ethCat = 'Black/African American';
		else if ethnicity ^= 9 then ethCat = 'Other';

run;


