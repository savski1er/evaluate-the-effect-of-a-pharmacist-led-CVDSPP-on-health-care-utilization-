Libname mtm "D:/arinzeproject/data/1rawdata"; /*asp datasets Library*/
Libname wrk "D:/arinzeproject/data/2workdata"; /*clean datasets Library*/
Libname dat "D:/arinzeproject/data/dat"; /*clean datasets Library*/


/***************************************************************************************/

**********************************************************;
*Data Wrangtling and Processing*
**********************************************************;

/******************************************************/
/****** Step 1: merging the data sets (2 hours) ******/
/*****************************************************/

/* import the mtm data sets. */

%macro impcsv (input, output);
proc import datafile = "D:/arinzeproject/data/dat/&input"
out = &output
dbms = csv
replace;

run;

%mend impcsv;

%impcsv (amtm_demogr_bp_bmi_control.csv, demogcont); /* 31055 observations and 11 variables */;
%impcsv (amtm_demogr_bp_bmi_treatmnt.csv, demogtreat); /* 1639 observations and 11 variables */;

%impcsv (bmtm_history_control.csv, histcont); /* 9955 observations and 10 variables */;
%impcsv (bmtm_history_treatmnt.csv, histtreat); /* 610 observations and 10 variables */;

%impcsv (cmtm_Report_class_control.csv, reporcont); /* 12831 observations and 4 variables */;
%impcsv (cmtm_report_class_treatmnt.csv, reportreat); /* 967 observations and 4 variables */;

%impcsv (dmtm_cho-a1c_control.csv, aicchocont); /* 19640 observations and 5 variables */;
%impcsv (dmtm_ehr_by_diag_code_treatmnt.csv, ehrdiagtreat); /* 2817 observations and 5 variables */;

%impcsv (emtm_hospital_treatmnt.csv, hosptreat); /* 177 observations and 4 variables */;
%impcsv (emtm_pcp_encount_report_treatmnt.csv, popenctreat); /* 1782 observations and 3 variables */;


/* formatting dates for all data */

%macro fdat (input, output);

data &output; set &input;
   format date_of_service  mmddyy10.;
run;

%mend fdat;

%fdat (demogcont, demogcont);
%fdat (demogtreat, demogtreat);
%fdat (reporcont, reporcont);
%fdat (reportreat, reportreat);
%fdat (ehrdiagtreat, ehrdiagtreat);
%fdat (popenctreat, popenctreat);


%macro fdt (input, output);

data &output; set &input;
   format tag_system_date  mmddyy10.;
run;

%mend fdt;

%fdt (histcont, histcont);
%fdt (histtreat, histtreat);


data aicchocont; set aicchocont;
   format lab_reported_date  mmddyy10.;
run;

data hosptreat; set hosptreat;
   format submit_dt  mmddyy10.;
run;


/* Adjusting the data collection data */

data demogcont; set demogcont; if date_of_service >= 2015; run;  
data demogtreat; set demogtreat; if date_of_service >= 2015; run;  

data histcont; set histcont; keep pid title tag_system_date; if tag_system_date >= 2015; run;  /* 9920 observations and 3 variables */;
data histtreat; set histtreat; keep pid title tag_system_date; if tag_system_date >= 2015; run; /* 610 observations and 3 variables */; 

data reporcont; set reporcont; keep pid reporting_class date_of_service; if date_of_service >= 2015; run; /*  12831 observations and 3 variables */; 
data reportreat; set reportreat; keep pid reporting_class date_of_service; if date_Of_service >= 2015; run; /* 967 observations and 3 variables */; 

data aicchocont; set aicchocont; if lab_reported_date >= 2015; run; /* 19640 observations and 5 variables */;
data ehrdiagtreat; set ehrdiagtreat; if date_of_service >= 2015; run; /* 2817 observations and 5 variables */;  

data hosptreat; set hosptreat; if submit_dt >= 2015; run; /* 177 observations and 4 variables */;  
data popenctreat; set popenctreat; if date_of_service >= 2015; run; /* 1782 observations and 3 variables */;  


/* saving created data sets */

%macro retcsv (input, output);

proc export data = &input dbms=csv
outfile = "D:/arinzeproject/data/dat/&output"
replace;
run;

%mend retcsv;

%retcsv (demogcont, demogcont);
%retcsv (demogtreat, demogtreat);
%retcsv (histcont, histcont);
%retcsv (histtreat, histtreat);
%retcsv (reporcont, reporcont);
%retcsv (reportreat, reportreat);
%retcsv (aicchocont, aicchocont);
%retcsv (aicchotreat, aicchotreat);
%retcsv (ehrdiagcont, ehrdiagcont);
%retcsv (ehrdiagtreat, ehrdiagtreat);
%retcsv (hospcont, hospcont);
%retcsv (hosptreat, hosptreat);
%retcsv (pcpenccont, pcpenccont);
%retcsv (pcpenctreat, pcpenctreat);
%retcsv (prescripcont, prescripcont);
%retcsv (prescriptreat, prescriptreat);


%macro impcsv (input, output);
proc import datafile = "D:/arinzeproject/data/dat/&input"
out = &output
dbms = csv
replace;

run;

%mend impcsv;

%impcsv (demogcont.csv, demogcont);
%impcsv (demogtreat.csv, demogtreat);
%impcsv (histcont.csv, histcont);
%impcsv (histtreat.csv, histtreat);
%impcsv (reporcont.csv, reporcont);
%impcsv (reportreat.csv, reportreat);
%impcsv (aicchocont.csv, aicchocont);
%impcsv (aicchotreat.csv, aicchotreat);
%impcsv (ehrdiagcont.csv, ehrdiagcont);
%impcsv (ehrdiagtreat.csv, ehrdiagtreat);
%impcsv (hospcont.csv, hospcont);
%impcsv (hosptreat.csv, hosptreat);
%impcsv (pcpenccont.csv, pcpenccont);
%impcsv (pcpenctreat.csv, pcpenctreat);
%impcsv (prescripcont.csv, prescripcont);
%impcsv (prescriptreat.csv, prescriptreat);


/* combining data sets */

* demographcs*;

%macro conc (inputa, inputb, output);

data &output; set &inputa &inputb; run;

%mend conc;

%conc (demogcont, demogtreat, demogr);
%conc (histcont, histtreat, histor);
%conc (reporcont, reportreat, report);
%conc (aicchocont, aicchotreat, aiccho);
%conc (ehrdiagcont, ehrdiagtreat, ehrdig);
%conc (hospcont, hosptreat, hospit);
%conc (pcpenccont, pcpenctreat, pcpenc);
%conc (prescripcont, prescriptreat, prescrip);


/* saving created data sets */

%macro retcsv (input, output);

proc export data = &input dbms=csv
outfile = "D:/arinzeproject/data/dat/&output"
replace;
run;

%mend retcsv;

%retcsv (demogr, demogr);
%retcsv (histor, histor);
%retcsv (report, report);
%retcsv (aiccho, aiccho);
%retcsv (ehrdig, ehrdig);
%retcsv (hospit, hospit);
%retcsv (pcpenc, pcpenc);
%retcsv (prescrip, prescrip);


%impcsv (demogr.csv, demogr);
%impcsv (histor.csv, histor);
%impcsv (report.csv, report);
%impcsv (aiccho.csv, aiccho);
%impcsv (ehrdig.csv, ehrdig);
%impcsv (hospit.csv, hospit);
%impcsv (pcpenc.csv, pcpenc);
%impcsv (prescrip.csv, prescrip);
%impcsv (followup.csv, followp);


/* data processing */

*in demographic data set*;
data demogr; set demogr;   
		
if gender = 'F' then sex = 0;
if gender = 'M' then sex = 1;

if 24 <= Age <= 35 then agegr = 1;
if 36 <= Age <= 45 then agegr = 2;
if 46 <= Age <= 55 then agegr = 3;
if 56 <= Age <= 65 then agegr = 4;
if 66 <= Age <= 75 then agegr = 5;
if 76 <= Age <= 85 then agegr = 6;
if Age >= 86 then agegr = 7;

if race = 'Black' then nrace = 1;
if race = 'White' then nrace = 2;
if race = 'Asian' then nrace= 3;
if race in ('Ameri','Nativ','Other','More') then nrace = 4; *American Indian or Alaska Native,Native Hawaiian or Other Pacific Islander,Other Pacific Islander, *More than one race*;
if race in ('Refus' , 'Undef') then nrace= 5; *Refused,Undefined*;

if ethnicity = 'Hispanic or Latino' then ethngr = 1;
if ethnicity = 'Not Hispanic or Latino' then ethngr = 2;
if ethnicity in ('Refused to Report/Unre' , 'Undefined') then ethngr = 3;

run;

*create bloop pressure data in demogr*;
* address missing*;
proc stdize data = demogr
	out = demogr
	reponly method = mean;
run;

* create bp*;
data demogr; set demogr; 

map = (vital_bp_systolic+(2*vital_bp_diastolic))/3; 

bp = (vital_bp_systolic/vital_bp_diastolic); 
if bp < 130/80 then bpgola = 1; else bpgola = 0;
if bp < 140/90 then bpgolb = 1; else bpgolb = 0;
if bpgola = 1 | bpgolb = 1 then bpgol = 1; else bpgol = 0;

run;

*in insurance data set*;
data report; set report;   
		
if reporting_class = 'Self-Pay' then payer = 1; 
if reporting_class = 'Commercial' then payer = 2; 
if reporting_class = 'Medicaid' then payer = 3; 
if reporting_class = 'Medicare' then payer = 4; 
if reporting_class = 'Charity' then payer = 5; 
if reporting_class = 'Full Pay' then payer = 6; 

run;

*in pcp encounter data set*;
data pcpenc; set pcpenc;   
		
if visit_type = 'Annual' then pcpvity = 1; 
if visit_type = 'Chiropractic' then pcpvity = 2; 
if visit_type = 'Coumadin Man' then pcpvity = 3; 
if visit_type = 'Humphrey Vis' then pcpvity = 4; 
if visit_type = 'Immunization' then pcpvity = 5; 
if visit_type = 'Injection Only' then pcpvity = 6; 
if visit_type = 'Laboratory' then pcpvity = 7; 
if visit_type = 'Mammogram' then pcpvity = 8; 
if visit_type = 'Mental Health' then pcpvity = 9; 
if visit_type = 'Mobile Medic' then pcpvity = 10; 
if visit_type = 'Office Visit' then pcpvity = 11; 
if visit_type = 'Optical Mate' then pcpvity = 12; 
if visit_type = 'Optometry Vi' then pcpvity = 13; 
if visit_type = 'Physicals' then pcpvity = 14; 
if visit_type = 'Retinal Scan' then pcpvity = 15; 
if visit_type = 'Telephonic' then pcpvity = 16; 
if visit_type = 'Transition' then pcpvity = 17; 
if visit_type = 'Virtual' then pcpvity = 18; 
if visit_type = 'Women Health' then pcpvity = 19; 
if visit_type = 'Xray Only' then pcpvity = 20; 

run;

*in a1c and ldl goals data set*;
data aiccho; set aiccho; if result_value = ' ' then result_value = mean(result_value); run;

data aiccho; set aiccho;   
		
if result_name = 'A1C' & result_value < 6.5 then a1cgola = 1; else a1cgola = 0;
if result_name = 'A1C' & result_value < 7 then a1cgolb = 1; else a1cgolb = 0;
if a1cgola = 1 | a1cgolb = 1 then a1cgol = 1; else a1cgol = 0;

if result_name = 'LDL' & result_value < 100 then ldlgola = 1; else ldlgola = 0;
if result_name = 'LDL' & result_value < 120 then ldlgolb = 1; else ldlgolb = 0;
if ldlgola = 1 | ldlgolb = 1 then ldlgol = 1; else ldlgol = 0;

run;


*in ehr data set*;
data ehrdig; set ehrdig;   
		
if dxcode = 'Acute Ischemic' then ehrillness = 1; 
if dxcode = 'Acute Myrocard' then ehrillness = 2; 
if dxcode = 'Angina Pectori' then ehrillness = 3; 
if dxcode = 'Hyperlipidemia' then ehrillness = 4; 
if dxcode = 'Hypertension' then ehrillness = 5; 
if dxcode = 'Other IHD' then ehrillness = 6; 

run;


*in historical data set*;
data histor; set histor;   
		
if title = 'Alcohol Use' then behav = 1; 
if title = 'Light alcohol use' then behav = 2; 
if title = 'No Alcohol Use' then behav = 3; 
if title = 'Illicit drug use' then behav = 4; 
if title = 'No Drug Use' then behav = 5; 
if title = 'Tobacco Use' then behav = 6; 
if title = 'No Tobacco Use' then behav = 7; 
if title = 'Caffeine use' then behav = 8; 
if title = 'No Caffeine Use' then behav = 9; 
if title = 'Cancer' then behav = 10; 
if title = 'Family Issues' then behav = 11; 
if title = 'Financial Problems' then behav = 12; 
if title = 'Marital status' then behav = 13; 
if title = 'Nutrition' then behav = 14; 
if title = 'Housing' then behav = 15; 
if title = 'Work Status' then behav = 16; 
if title = 'Education' then behav = 17; 
if title = 'Health Screening' then behav = 18; 
if title = 'Exercise' then behav = 19; 
if title = 'Culture Language' then behav = 20; 
if title = 'Sexual Preference' then behav = 21; 
if title = 'Other' then behav = 22; 

run;


*loading data sets*;
%impcsv (demogr.csv, demogr);
%impcsv (histor.csv, histor);
%impcsv (report.csv, report);
%impcsv (aiccho.csv, aiccho);
%impcsv (ehrdig.csv, ehrdig);
%impcsv (hospit.csv, hospit);
%impcsv (pcpenc.csv, pcpenc);
%impcsv (prescrip.csv, prescrip);
%impcsv (followup.csv, followp);

/* Placing hospitalized formated into work file */;
data work; set hospit; run;

/*Creating index date and unique patients */ * obs  48996 *;
proc sort data = work; by pid admit_date; run;

data indexdt (keep = index_dt pid);
  set work (rename= (admit_date = index_dt));
  by pid index_dt;
  if first.pid then output;
run;

*merging index and hospit data set*;
proc sql;
create table hospit as select a.*,b.* 
from hospit a left join indexdt b
on a. pid = b. pid;
quit;

*hospitalization 30, 60, 90 days after index days data set*;
data index_dat; set hospit; keep pid dischrg_date admit_date index_dt hvisit30 hvisit60 hvisit90; *48996*;
hvisit30 = dischrg_date + 30;
hvisit60 = dischrg_date + 60;
hvisit90 = dischrg_date + 90;
      format hvisit30 mmddyy10.;
      format hvisit60 mmddyy10.; 
      format hvisit90 mmddyy10.;
run; 

data index_dat; set index_dat; 
  dis_index_dt = index_dt + (dischrg_date - admit_date);
    format dis_index_dt mmddyy10.;
run;

data index_dat; set index_dat; 

if dis_index_dt < admit_date <= hvisit30 then hvisit_30 = 1; else hvisit_30 = 0;
if dis_index_dt < admit_date <= hvisit60 then hvisit_60 = 1; else hvisit_60 = 0;
if dis_index_dt < admit_date <= hvisit90 then hvisit_90 = 1; else hvisit_90 = 0;

run;

*create 30 days visit rate*;
data visit_rate; set index_dat; proc sort; by pid; run;
data visit_rate; set visit_rate; by pid;
    retain visit_rate_30;
      if first.pid then visit_rate_30 = hvisit_30;
      else visit_rate_30 = hvisit_30 + visit_rate_30;
      if last.pid;
run;

data visit_rate; set visit_rate; keep pid visit_rate_30;
proc sort data = visit_rate nodupkey; by pid; run;

*merging 30 days visit rate and index_dat data set*;
proc sql;
create table index_dat as select a.*,b.* 
from index_dat a left join visit_rate b
on a. pid = b. pid;
quit;

*create 60 days visit rate*;
data visit_rate; set index_dat; proc sort; by pid; run;
data visit_rate; set visit_rate; by pid;
    retain visit_rate_60;
      if first.pid then visit_rate_60 = hvisit_60;
      else visit_rate_60 = hvisit_60 + visit_rate_60;
      if last.pid;
run;

data visit_rate; set visit_rate; keep pid visit_rate_60;
proc sort data = visit_rate nodupkey; by pid; run;

*merging 60 days visit rate and index_dat data set*;
proc sql;
create table index_dat as select a.*,b.* 
from index_dat a left join visit_rate b
on a. pid = b. pid;
quit;

*create 90 days visit rate*;
data visit_rate; set index_dat; proc sort; by pid; run;
data visit_rate; set visit_rate; by pid;
    retain visit_rate_90;
      if first.pid then visit_rate_90 = hvisit_90;
      else visit_rate_90 = hvisit_90 + visit_rate_90;
      if last.pid;
run;

data visit_rate; set visit_rate; keep pid visit_rate_90;
proc sort data = visit_rate nodupkey; by pid; run;

*merging 90 days visit rate and index_dat data set*;
proc sql;
create table index_dat as select a.*,b.* 
from index_dat a left join visit_rate b
on a. pid = b. pid;
quit;

*merging index and hospit data set*;
data visitdat; set index_dat; keep pid visit_rate_30 visit_rate_60 visit_rate_90; run;
proc sort data = visitdat nodupkey; by pid; run;

proc sql;
create table hospit as select a.*,b.* 
from hospit a left join visitdat b
on a. pid = b. pid;
quit;


/* Placing emergency room formated into work file */;
data work1; set ehrdig; run;

/*Creating index date and unique patients */ * obs  48996 *;
proc sort data = work1; by pid ehr_service_date; run;

data indexdt1 (keep = index_dtehr pid);
  set work1 (rename= (ehr_service_date = index_dtehr));
  by pid index_dtehr;
  if first.pid then output;
run;

*merging index and ehrdig data set*;
proc sql;
create table ehrdig as select a.*,b.* 
from ehrdig a left join indexdt1 b
on a. pid = b. pid;
quit;

*merging index and hospit data set*;
data ehrdat (keep = pid hvisit30 hvisit60 hvisit90); set index_dat; run;

proc sql;
create table ehrdig as select a.*,b.* 
from ehrdig a left join ehrdat b
on a. pid = b. pid;
quit;

data ehrdig; set ehrdig; 

if index_dtehr < ehr_service_date <= hvisit30 then ehrvisit_30 = 1; else ehrvisit_30 = 0;
if index_dtehr < ehr_service_date <= hvisit60 then ehrvisit_60 = 1; else ehrvisit_60 = 0;
if index_dtehr < ehr_service_date <= hvisit90 then ehrvisit_90 = 1; else ehrvisit_90 = 0;

run;


*create 30 days ehr visit rate*;
data ehr_rate; set ehrdig; proc sort; by pid; run;
data ehr_rate; set ehr_rate; by pid;
    retain ehr_rate_30;
      if first.pid then ehr_rate_30 = ehrvisit_30;
      else ehr_rate_30 = ehrvisit_30 + ehr_rate_30;
      if last.pid;
run;

data ehr_rate; set ehr_rate; keep pid ehr_rate_30;
proc sort data = ehr_rate nodupkey; by pid; run;

*merging 30 days ehvisit rate and ehrdg data set*;
proc sql;
create table ehrdg as select a.*,b.* 
from ehrdig a left join ehr_rate b
on a. pid = b. pid;
quit;


*create 60 days ehr visit rate*;
data ehr_rate; set ehrdig; proc sort; by pid; run;
data ehr_rate; set ehr_rate; by pid;
    retain ehr_rate_60;
      if first.pid then ehr_rate_60 = ehrvisit_60;
      else ehr_rate_60 = ehrvisit_60 + ehr_rate_60;
      if last.pid;
run;

data ehr_rate; set ehr_rate; keep pid ehr_rate_60;
proc sort data = ehr_rate nodupkey; by pid; run;

*merging 30 days ehvisit rate and ehrdg data set*;
proc sql;
create table ehrdg as select a.*,b.* 
from ehrdg a left join ehr_rate b
on a. pid = b. pid;
quit;

*create 30 days ehr visit rate*;
data ehr_rate; set ehrdig; proc sort; by pid; run;
data ehr_rate; set ehr_rate; by pid;
    retain ehr_rate_90;
      if first.pid then ehr_rate_90 = ehrvisit_90;
      else ehr_rate_90 = ehrvisit_90 + ehr_rate_90;
      if last.pid;
run;

data ehr_rate; set ehr_rate; keep pid ehr_rate_90;
proc sort data = ehr_rate nodupkey; by pid; run;

*merging 30 days ehvisit rate and ehrdg data set*;
proc sql;
create table ehrdg as select a.*,b.* 
from ehrdg a left join ehr_rate b
on a. pid = b. pid;
quit;


data ehrdgv; set ehrdg; keep pid ehr_rate_30 ehr_rate_60 ehr_rate_90;
proc sort data = ehrdgv nodupkey; by pid; run;

*merging 30 days ehvisit rate and ehrdg data set*;
proc sql;
create table ehrdig as select a.*,b.* 
from ehrdig a left join ehrdgv b
on a. pid = b. pid;
quit;


%retcsv (ehrdig, ehrdig);
%retcsv (hospit, hospit);


*AiCgol and LDLgol 90, 180, 360 days after index days data set*;
data goal; set hospit;keep pid dischrg_date admit_date hvisit90 hvisit180 hvisit360; *48996*;
hvisit90 = dischrg_date + 90;
hvisit180 = dischrg_date + 180;
hvisit360 = dischrg_date + 360;
      format hvisit90 mmddyy10.;
      format hvisit180 mmddyy10.; 
      format hvisit360 mmddyy10.;
run; 

proc sql;
create table aiccho as select a.*,b.* 
from aiccho a left join goal b
on a. pid = b. pid;
quit;

data aiccho; set aiccho; 

if a1cgol=1 & admit_date <= hvisit90 then a1cgol_90 = 1; else a1cgol_90 = 0;
if a1cgol=1 & admit_date <= hvisit180 then a1cgol_180 = 1; else a1cgol_180 = 0;
if a1cgol=1 & admit_date <= hvisit360 then a1cgol_360 = 1; else a1cgol_360 = 0;

if ldlgol=1 & admit_date <= hvisit90 then ldlgol_90 = 1; else ldlgol_90 = 0;
if ldlgol=1 & admit_date <= hvisit180 then ldlgol_180 = 1; else ldlgol_180 = 0;
if ldlgol=1 & admit_date <= hvisit360 then ldlgol_360 = 1; else ldlgol_360 = 0;

run;


*bpgol and LDLgol 90, 180, 360 days after index days data set*;
data goalv; set goal; 
proc sort data = goalv nodupkey; by pid; run;

proc sql;
create table demogr as select a.*,b.* 
from demogr a left join goalv b
on a. pid = b. pid;
quit;

data demogr; set demogr; 

if bpgol=1 & admit_date <= hvisit90 then bpgol_90 = 1; else bpgol_90 = 0;
if bpgol=1 & admit_date <= hvisit180 then bpgol_180 = 1; else bpgol_180 = 0;
if bpgol=1 & admit_date <= hvisit360 then bpgol_360 = 1; else bpgol_360 = 0;

run;

*Saving the data sets*;
%retcsv (demogr, demogr);
%retcsv (histor, histor);
%retcsv (report, report);
%retcsv (aiccho, aiccho);
%retcsv (ehrdig, ehrdig);
%retcsv (hospit, hospit);
%retcsv (pcpenc, pcpenc);
%retcsv (prescrip, prescrip);


*before merging the data sets*;
data visits; set hospit; keep pid hvisit_30 hvisit_60 hvisit_90 visit_rate_30 visit_rate_60 visit_rate_90; 
proc sort data = visits nodupkey; by pid; run; *obs 719*;

data ehrvis; set ehrdig; keep pid ehrillness ehrvisit_30 ehrvisit_60 ehrvisit_90 ehr_rate_30 ehr_rate_60 ehr_rate_90; 
proc sort data = ehrvis nodupkey; by pid; run; *obs 83*;

data aich; set aiccho; keep pid a1cgol ldlgol a1cgol_90 a1cgol_180 a1cgol_360 ldlgol_90 ldlgol_180 ldlgol_360;
proc sort data = aich nodupkey; by pid; run; *obs 1015*;

data demogv; set demogr; keep pid date_of_service group mtm age agegr sex nrace ethngr map bp bpgol bpgol_90 bpgol_180 bpgol_360;
proc sort data = demogv nodupkey; by pid; run; *obs 1059*;

data encou; set pcpenc; keep pid pcpvity;
proc sort data = encou nodupkey; by pid; run; *obs 1059*;

data repor; set report; keep pid payer;
proc sort data = repor nodupkey; by pid; run; *obs 1057*;

data histor; set histor; keep pid behav;
proc sort data = histor nodupkey; by pid; run; *obs 1059*;


/* merging data sets */ 

*merging demographic and insurance data set*;
proc sql;
create table mtmdat as select a.*,b.* 
from demogv a left join repor b
on a. pid = b. pid;
quit;

*merging mtmdat and pcp encounter data set*;
proc sql;
create table mtmdat as select a.*,b.* 
from mtmdat a left join encou b
on a. pid = b. pid;
quit;

*merging mtmdat and a1c ldl data set*;
proc sql;
create table mtmdat as select a.*,b.* 
from mtmdat a left join aich b
on a. pid = b. pid;
quit;

*merging mtmdat and hospitalization data set*;
proc sql;
create table mtmdat as select a.*,b.* 
from mtmdat a left join visits b
on a. pid = b. pid;
quit;

*merging mtmdat and ehr data set*;
proc sql;
create table mtmdat as select a.*,b.* 
from mtmdat a left join ehrvis b
on a. pid = b. pid;
quit;

*merging mtmdat and histor data set*;
proc sql;
create table mtmdat as select a.*,b.* 
from mtmdat a left join histor b
on a. pid = b. pid;
quit;


* address missing*;
proc stdize data = mtmdat
	out = mtmdat
	reponly method = mean;
run;

%retcsv (mtmdat, mtmdat);

%impcsv (mtmdatf.csv, mtmdat);

**********************************************************;
*Propensity Score Matching*
**********************************************************;

*greedy ps matching*;
options orientation = landscape;
ods csv file = "D:/arinzeproject/data/dat/tabpsgrdymch.csv" style = Vasstables;
title "PROC PSMATCH FOR PROPENSITY SCORES";

ods graphics on;
proc psmatch data = mtmdat region = treated(extend(stat = ps mult = one) = 0.025);
 	class group sex;

 	psmodel group(treated = '1') = age sex nrace ethngr payer pcpvity ehrillness behav;

	match method = greedy(k = 1) exact = sex caliper = 0.6;

	assess ps lps var = (age sex nrace ethngr payer pcpvity ehrillness behav) / varinfo plots = all weight = none;

	output out(obs = match) = OutEx4 matchid = _MatchID;

run;

%retcsv (OutEx4, OutEx4);

%impcsv (greedy.csv, greedy);


*merging aicch and followup data set*;
proc sql;
create table aiccho as select a.*,b.* 
from aiccho a left join followp b
on a. pid = b. pid;
quit;

* address missing*;
proc stdize data = aiccho
	out = aiccho
	reponly method = mean;
run;

data aiccho; set aiccho;

timevtvis1 = (_1st_visit_date - dischrg_date);
timevtvis2 = (_2nd_visit_date - dischrg_date);
timevtvis3 = (_3rd_visit_date - dischrg_date);
timevtvis4 = (_4th_visit_date - dischrg_date);

run;

data h; set aiccho; keep pid timevtvis1 timevtvis2 timevtvis3 timevtvis4;
proc sort data = h nodupkey; by pid; run; *obs 1059*;

*merging greedy and h data set*;
proc sql;
create table greedy as select a.*,b.* 
from greedy a left join h b
on a. pid = b. pid;
quit;

* address missing*;
proc stdize data = greedy
	out = greedy
	reponly method = mean;
run;

%retcsv (aiccho, aiccho);
%retcsv (greedy, greedy);


%impcsv (greedy.csv, greedy);


**********************************************************;
*Descriptive Analysis*
**********************************************************;

* Creating newyear *;
data df; set greedy; newyear = date_of_service;format newyear year4.;overall=1;run;

* data formatting *;
proc format;

value yesno_ 1 = '   Yes'
0 = '   No';  
value sex_ 1 = '   Male'
0 = '   Female';     
value agegr_ 1 = '   24 - 35'
2 = '   36 - 45'   
3 = '   46 - 55'
4 = '   56 - 65'
5 = '   66 - 75'
6 = '   76 - 85'  
7 = '   86 & plus';    
value nrace_ 1 = '   Black'
2 = '   White'      
3 = '   Asian'  
4 = '   American Indian or Alaska Native & Others'   
5 = '   Refused or Undefined';      
value ethngr_ 1 = '   Hispanic or Latino'
2 = '   Not Hispanic or Latino'   
3 = '   Refused or Undefined';    
value payer_ 1 = '   Self-Pay'
2 = '   Commercial'  
3 = '   Medicaid'   
4 = '   Medicare'   
5 = '   Charity'   
6 = '   Full Pay';   
value pcpvity_ 1 = '   Annual'
2 = '   Chiropractic'
3 = '   Coumadin Man' 
4 = '   Humphrey Visit' 
5 = '   Immunization' 
6 = '   Injection Only' 
7 = '   Laboratory' 
8 = '   Mammogram' 
9 = '   Mental Health' 
10 = '   Mobile Medication' 
11 = '   Office Visit' 
12 = '   Optical Mate' 
13 = '   Optometry Visit' 
14 = '   Physicals' 
15 = '   Retinal Scan' 
16 = '   Telephonic' 
17 = '   Transition' 
18 = '   Virtual' 
19 = '   Women Health' 
20 = '   Xray Only'; 
value ehrillness_ 1 = '   Acute Ischemic'
2 = '   Acute Myrocard'    
3 = '   Angina Pectori'      
4 = '   Hyperlipidemia'      
5 = '   Hypertension'      
6 = '   Other IHD';      
value behav_ 1 = '   Alcohol Use'
2 = '   Light Alcohol Use'     
3 = '   No Alcohol Use'      
4 = '   Drug Use'      
5 = '   No Drug Use'      
6 = '   Tobacco Use'      
7 = '   No Tobacco Use'      
8 = '   Caffeine Use'      
9 = '   No Caffeine Use'      
10 = '   Cancer Issue'      
11 = '   Family Problems'      
12 = '   Financial Problems'      
13 = '   Marital status'      
14 = '   Nutrition'      
15 = '   Housing'      
16 = '   Work Status'      
17 = '   Education'      
18 = '   Health Screening'      
19 = '   Exercise'      
20 = '   Culture & Language'      
21 = '   Sexual Preference'      
22 = '   Other';
value group_ 1 = '   Intervention Group'
0 = '   Control Group';
value mtm_ 1 = '   Post-Intervention'
0 = '   Pre-Intervention';
value overall 1='   Total cohort';
value age;
value visit_rate_30; 
value visit_rate_60; 
value visit_rate_90;
value ehr_rate_30; 
value ehr_rate_60; 
value ehr_rate_90;
picture pctfmt(round)low-high='   009.9)' (prefix='(');

run;

* create a ‘journal style’ template *;
proc template;

	define style Styles.Vasstables;
		parent = Styles.Default;
		STYLE SystemTitle /
			FONT_FACE = "Times New Roman, Helvetica, sans-serif"
			FONT_SIZE = 8
			FONT_WEIGHT = bold
			FONT_STYLE = roman
			FOREGROUND = white
			BACKGROUND = white;
		STYLE SystemFooter /
			FONT_FACE = "Times New Roman, Helvetica, sans-serif"
			FONT_SIZE = 2
			FONT_WEIGHT = bold
			FONT_STYLE = italic
			FOREGROUND = white
			BACKGROUND = white;
		STYLE Header /
			FONT_FACE = "Times New Roman, Helvetica, sans-serif"
			FONT_SIZE = 4
			FONT_WEIGHT = medium
			FONT_STYLE = roman
			FOREGROUND = white
			BACKGROUND = white;
		STYLE Data /
			FONT_FACE = "Times New Roman, Helvetica, sans-serif"
			FONT_SIZE = 2
			FONT_WEIGHT = medium
			FONT_STYLE = roman
			FOREGROUND = black
			BACKGROUND = white;
		STYLE Table /
			FOREGROUND = black
			BACKGROUND = white
			CELLSPACING = 0
			CELLPADDING = 3
			FRAME = HSIDES
			RULES = NONE;
		STYLE Body /
			FONT_FACE = "Times New Roman, Helvetica, sans-serif"
			FONT_SIZE = 3
			FONT_WEIGHT = medium
			FONT_STYLE = roman
			FOREGROUND = black
			BACKGROUND = white;
		STYLE SysTitleAndFooterContainer /
			CELLSPACING=0;
	end;

run;

/******************* TABLE 1 in TEXT *************************************************/
* Labeling Categorical Variables*;

data tab1;
set df;
label nrace = 'Race';
label agegr = 'Age Group';
label sex = 'Gender';
label ethngr = 'Ethnicity Group'; 
label payer = 'Insurance Group';
label pcpvity = 'PCP Visit Types';
label ehrillness = 'Emergency Room Disease Type';
label behav = 'Health Behavior'; 
label age = 'Age';
label a1cgol = 'A1C Goal'; 
label a1cgol_90 = 'A1C Goal three months'; 
label a1cgol_180 = 'A1C Goal six months'; 
label a1cgol_360 = 'A1C Goal one year'; 
label ldlgol = 'LDL Goal';
label ldlgol_90 = 'LDL Goal three months';
label ldlgol_180 = 'LDL Goal six months';
label ldlgol_360 = 'LDL Goal one year';
label bpgol = 'Blood Pressure Goal';
label bpgol_90 = 'Blood Pressure Goal three months';
label bpgol_180 = 'Blood Pressure Goal six months';
label bpgol_360 = 'Blood Pressure Goal one year';
label hvisit_30 = '30-day Hospital Visit'; 
label hvisit_60 = '60-day Hospital Visit';
label hvisit_90 = '90-day Hospital Visit';
label ehrvisit_30 = '30-day EHR Visit'; 
label ehrvisit_60 = '60-day EHR Visit';
label ehrvisit_90 = '90-day Hospital Visit';
label visit_rate_30 = 'Rate of 30-day Hospital Visit'; 
label visit_rate_60 = 'Rate of 60-day Hospital Visit';
label visit_rate_90 = 'Rate of 90-day Hospital Visit';
label ehr_rate_30 = 'Rate of Emergency Room Visit'; 
label ehr_rate_60 = 'Rate of Emergency Room Visit'; 
label ehr_rate_90 = 'Rate of Emergency Room Visit'; 
label overall = 'Total cohort';

* Creating table 1*;

options orientation=landscape;

ods csv file= 'D:/arinzeproject/data/dat/table1.csv' style=karamtables;

title1 "Clinical and Socioeconomic Characteristic of IHD Patients";

proc tabulate data=tab1 missing order=formatted;
	class group agegr sex nrace ethngr payer pcpvity ehrillness behav hvisit_30 hvisit_60 hvisit_90 ehrvisit_30 ehrvisit_60 ehrvisit_90  
		bpgol a1cgol ldlgol  bpgol_90 bpgol_180 bpgol_360 a1cgol_90 a1cgol_180 a1cgol_360 ldlgol_90 ldlgol_180 ldlgol_360 overall;
	classlev agegr sex nrace ethngr payer pcpvity ehrillness behav hvisit_30 hvisit_60 hvisit_90 ehrvisit_30 ehrvisit_60 ehrvisit_90  
		bpgol a1cgol ldlgol  bpgol_90 bpgol_180 bpgol_360 a1cgol_90 a1cgol_180 a1cgol_360 ldlgol_90 ldlgol_180 ldlgol_360 /style=[cellwidth=3in asis=on];
	table agegr sex nrace ethngr payer pcpvity ehrillness behav hvisit_30 hvisit_60 hvisit_90 ehrvisit_30 ehrvisit_60 ehrvisit_90  
		bpgol a1cgol ldlgol  bpgol_90 bpgol_180 bpgol_360 a1cgol_90 a1cgol_180 a1cgol_360 ldlgol_90 ldlgol_180 ldlgol_360,
	overall = ''*(n*f=4.0 colpctn='(%)'*f=pctfmt.)
	group = 'group'*(n*f=4.0 colpctn='(%)'*f=pctfmt.)/misstext='0' rts=15;
	format group group_. nrace nrace_. sex sex_. ethngr ethngr_. payer payer_. agegr agegr_. pcpvity pcpvity_. ehrillness ehrillness_. 
	behav behav_. hvisit_30 yesno_. hvisit_60 yesno_. hvisit_90 yesno_. ehrvisit_30 yesno_. ehrvisit_60 yesno_. ehrvisit_90 yesno_. bpgol yesno_. 
	a1cgol yesno_. ldlgol yesno_. bpgol_90 yesno_. bpgol_180 yesno_. bpgol_360 yesno_. a1cgol_90 yesno_. a1cgol_180 yesno_. a1cgol_360 yesno_. 
	ldlgol_90 yesno_. ldlgol_180 yesno_. ldlgol_360 yesno_. overall overall.;
run;

/******************* TABLE 2 in TEXT *************************************************/
* Labeling Categorical Variables*;

* Creating table 2;
options orientation=portrait;

ods csv file= "D:/arinzeproject/data/dat/table2.csv" style=Vasstables;

title1 "Chisquare Test for Demographic and Socioeconomic Characteristic of Patients";

proc freq data=tab1 order=formatted;

	tables (group)*(agegr sex nrace ethngr payer pcpvity ehrillness behav hvisit_30 hvisit_60 hvisit_90 ehrvisit_30 ehrvisit_60 ehrvisit_90  
		bpgol a1cgol ldlgol  bpgol_90 bpgol_180 bpgol_360 a1cgol_90 a1cgol_180 a1cgol_360 ldlgol_90 ldlgol_180 ldlgol_360)/ chisq measures;
	format group group_. nrace nrace_. sex sex_. ethngr ethngr_. payer payer_. agegr agegr_. pcpvity pcpvity_. ehrillness ehrillness_. 
	behav behav_. hvisit_30 yesno_. hvisit_60 yesno_. hvisit_90 yesno_. ehrvisit_30 yesno_. ehrvisit_60 yesno_. ehrvisit_90 yesno_. bpgol yesno_. 
	a1cgol yesno_. ldlgol yesno_. bpgol_90 yesno_. bpgol_180 yesno_. bpgol_360 yesno_. a1cgol_90 yesno_. a1cgol_180 yesno_. a1cgol_360 yesno_. 
	ldlgol_90 yesno_. ldlgol_180 yesno_. ldlgol_360 yesno_. overall overall.;

run;


*descriptive for continuous variables*;
data df; set df; ehr_hosp_30d = visit_rate_30 + ehr_rate_30; run;


%macro vprean (input1, input2);

* Labeling continuous Variables*;

data tab1;
set df;
label visit_rate_30 = 'Rate of 30-day Hospital Visit'; 
label visit_rate_60 = 'Rate of 60-day Hospital Visit';
label visit_rate_90 = 'Rate of 90-day Hospital Visit';
label ehr_rate_30 = 'Rate of Emergency Room 30-day Visit'; 
label ehr_rate_60 = 'Rate of Emergency Room 60-day Visit'; 
label ehr_rate_90 = 'Rate of Emergency Room 90-day Visit'; 
label ehr_hosp_30d = '30-day Rate of Emergency Room & hospital Visit'; 
label age = 'Age';

options orientation = portrait;
ods csv file = "D:/arinzeproject/data/dat/table3.csv" style = Vasstables;
title1 "Statistics of the MTM Patients Data";

*Produce descriptive statistics;
proc means data = &input1 n nmiss mean std stderr median min max qrange maxdec = 4;
class group;
var &input2;
run;
 
*Test for normality and produce confidence intervals on the median;
proc univariate data = &input1 normal cipctldf;
class group;
var &input2;
histogram &input2 /normal;
qqplot /normal (mu = est sigma = est);
run;
 
*Produce boxplots;
proc sgplot data = &input1;
title 'Boxplot number of &input2 by treatment';
vbox &input2 /category = group;
run;
 
*Perform the Mann-Whitney U Test;
proc npar1way data = &input1 wilcoxon;
class group;
var &input2;
run;

%mend vprean;

%vprean(df, age);
%vprean(df, visit_rate_30);
%vprean(df, visit_rate_60);
%vprean(df, visit_rate_90);
%vprean(df, ehr_rate_30);
%vprean(df, ehr_rate_60);
%vprean(df, ehr_rate_90);
%vprean(df, ehr_hosp_30d);


%impcsv (greedy.csv, df);

* Test analysis on age Variables*;
* Creating table 2;
%macro ttest (input1, input2);
options orientation = portrait;
ods csv file= "D:/arinzeproject/data/dat/tabttest.csv" style = Vasstables;
title1 "Chisquare Test for Demographic and Socioeconomic Characteristic of Patients";

proc ttest data = &input1 plots(unpack) = summary;
 class group;
 var &input2;
run;

%mend ttest;

%ttest(df, age);
%ttest(df, visit_rate_30);
%ttest(df, ehr_rate_30);
%ttest(df, nvisit_rate_30);
%ttest(df, nehr_rate_30);
%ttest(dat, znvisit_rate_30);
%ttest(dat, znehr_rate_30);
%ttest(dat, lnvisit_rate_30);
%ttest(dat, lnehr_rate_30);


* Addressing Outliers*;
* Outlier 30-days visit *;
data df; set df; 
nvisit_rate_30 = visit_rate_30;
nehr_rate_30 = ehr_rate_30;
if group = 0 & nvisit_rate_30 > 139.5 then nvisit_rate_30 = 139.5;
if group = 1 & nvisit_rate_30 > 138.75 then nvisit_rate_30 = 138.75;
if group = 0 & nehr_rate_30 > 8138 then nehr_rate_30 = 8138;
if group = 1 & nehr_rate_30 > 1931.25 then nehr_rate_30 = 1931.25;
run;


* Standardizing Outcome variables*;
data dat; set df; 
znvisit_rate_30 = nvisit_rate_30; 
znehr_rate_30 = nehr_rate_30;
run;

proc sort data = dat; by group; run; *obs 1059*;
proc standard data = dat mean = 0 std = 1 out = dat;
  by group;
  var znvisit_rate_30 znehr_rate_30;
run;

* log normalizing Outcome Variables *;
proc sort data = dat; by group; run; *obs 1059*;
data dat; set dat;
by group;
lnvisit_rate_30 = log(nvisit_rate_30); 
lnehr_rate_30 = log(nehr_rate_30);
run;

data dat; set dat;
if lnvisit_rate_30 = ' ' then lnvisit_rate_30 = 0; 
if lnehr_rate_30 = ' ' then lnehr_rate_30 = 0;
run;

%retcsv (dat, greedy);

%impcsv (greedy.csv, df);


*********************************************************************;
*Data Analytics* age, timevtvis1, timevtvis2, timevtvis3, timevtvis4*
********************************************************************;

data bvar; set df; keep group ps; run;  

*Cox proportional using time_to_event*;
%macro coxpr (wtstring =,modeltype =, outcomevar = );

options orientation=landscape;
ods csv file= "D:/arinzeproject/data/dat/tabphv1.csv" style = Vasstables;
options linesize = 80;

ods graphics on;
proc phreg data = df plot(overlay) = survival;
class group (ref='0');
model timevtvis2*&outcomevar(1) = group/rl ;
baseline covariates = bvar out = _null_;
assess ph/resample;

run;

%mend coxpr;

%coxpr(wtstring =, modeltype = ADJUSTED, outcomevar = bpgol);
%coxpr(wtstring =, modeltype = ADJUSTED, outcomevar = a1cgol);
%coxpr(wtstring =, modeltype = ADJUSTED, outcomevar = ldlgol);

*Cox proportional using follow-up with covariate separeted*;

ods graphics on;
proc phreg data = dg plot(overlay) = survival;
   model time_to_event*bpgol(1) = group group1;
   baseline covariates = bvar out = _null_;
run;

proc phreg data = dg;
   model time_to_event*bpgol(1) = group ps;
   ps = group*(log(time_to_event) - 5.4);
run;


*Cox proportional using follow-up*;
%macro coxprv (wtstring =,modeltype =, outcomevar = );

options orientation=landscape;
ods csv file= "D:/arinzeproject/data/dat/tabphv2.csv" style = Vasstables;
options linesize=80;

proc phreg data = dg plots = survival;
class group (ref='0');
model followup*&outcomevar(1) = group ps/rl ;
assess ph/resample;

run;

%mend coxprv;

%coxprv(wtstring =, modeltype = ADJUSTED, outcomevar = bpgol);
%coxprv(wtstring =, modeltype = ADJUSTED, outcomevar = a1cgol);
%coxprv(wtstring =, modeltype = ADJUSTED, outcomevar = ldlgol);


*Cox proportional using constrained follow-up*;
%macro coxprs (wtstring =,modeltype =, outcomevar = );

options orientation=landscape;
ods csv file= "D:/arinzeproject/data/dat/tabphv3.csv" style = Vasstables;
options linesize=80;

proc phreg data = dg plot(overlay) = survival;
group2 = group*(followup >= 2);
class group (ref='0');
model followup*&outcomevar(1) = group group2 ps/ rl;

contrast ">= 2 visits" group 1 group2 1 /
estimate = exp;

assess ph/resample;

run;

%mend coxprs;

%coxprs(wtstring =, modeltype = ADJUSTED, outcomevar = bpgol);
%coxprs(wtstring =, modeltype = ADJUSTED, outcomevar = a1cgol);
%coxprs(wtstring =, modeltype = ADJUSTED, outcomevar = ldlgol);



**********************************************************;
*Difference-In-Difference Analysis*
**********************************************************;

*continuous outcomes, diff-in-diff immediately after mtm onset*;
%macro didv (wtstring =,modeltype =, outcomevar = );

options orientation=landscape;
ods csv file= "D:/arinzeproject/data/dat/tabdifv1.csv" style = Vasstables;
title1 "DiD with Control";

proc genmod data = df descending;
weight ps;
class pid group (order = formatted ref='0') / param=ref ;
model &outcomevar. = group|time / dist = tweedie type3;
&wtstring;

estimate 'RR:time befoe-after' time 1 /exp;
estimate 'RR:mtm interventions' group 1 /exp;
estimate 'RRR:(time befoe-after)*(mtm interventions)' time*group 1 /exp;

TITLE1 "Random intercept: pre/post mtm intervention &outcomevar. BY Provider group";
TITLE2 "&modeltype";

run;

%mend didv;

%didv(wtstring =, modeltype = ADJUSTED, outcomevar = visit_rate_30);
%didv(wtstring =, modeltype = ADJUSTED, outcomevar = nvisit_rate_30);
%didv(wtstring =, modeltype = ADJUSTED, outcomevar = znvisit_rate_30);
%didv(wtstring =, modeltype = ADJUSTED, outcomevar = lnvisit_rate_30);

%didv(wtstring =, modeltype = ADJUSTED, outcomevar = ehr_rate_30);
%didv(wtstring =, modeltype = ADJUSTED, outcomevar = nehr_rate_30);
%didv(wtstring =, modeltype = ADJUSTED, outcomevar = znehr_rate_30);
%didv(wtstring =, modeltype = ADJUSTED, outcomevar = lnehr_rate_30);


*continuous outcomes, diff-in-diff 90 days before mtm onset*;
%macro didv (wtstring =,modeltype =, outcomevar = );

options orientation=landscape;
ods csv file= "D:/arinzeproject/data/dat/tabdifv2.csv" style = Vasstables;
title1 "DiD with Control";

proc genmod data = df descending;
weight ps;
class pid group (order = formatted ref='0') / param=ref ;
model &outcomevar. = group|timebefore90d / dist = tweedie type3;
&wtstring;

estimate 'RR:time befoe-after' timebefore90d 1 /exp;
estimate 'RR:mtm interventions' group 1 /exp;
estimate 'RRR:(time befoe-after)*(mtm interventions)' timebefore90d*group 1 /exp;

TITLE1 "Random intercept: pre/post mtm intervention &outcomevar. BY Provider group";
TITLE2 "&modeltype";

run;

%mend didv;

%didv(wtstring =, modeltype = ADJUSTED, outcomevar = visit_rate_30);
%didv(wtstring =, modeltype = ADJUSTED, outcomevar = nvisit_rate_30);
%didv(wtstring =, modeltype = ADJUSTED, outcomevar = znvisit_rate_30);
%didv(wtstring =, modeltype = ADJUSTED, outcomevar = lnvisit_rate_30);

%didv(wtstring =, modeltype = ADJUSTED, outcomevar = ehr_rate_30);
%didv(wtstring =, modeltype = ADJUSTED, outcomevar = nehr_rate_30);
%didv(wtstring =, modeltype = ADJUSTED, outcomevar = znehr_rate_30);
%didv(wtstring =, modeltype = ADJUSTED, outcomevar = lnehr_rate_30);


*continuous outcomes, diff-in-diff 90 days after mtm onset*;
%macro didv (wtstring =,modeltype =, outcomevar = );

options orientation=landscape;
ods csv file= "D:/arinzeproject/data/dat/tabdifv3.csv" style = Vasstables;
title1 "DiD with Control";

proc genmod data = df descending;
weight ps;
class pid group (order = formatted ref='0') / param=ref ;
model &outcomevar. = group|timeafter90d / dist = tweedie type3;
&wtstring;

estimate 'RR:time befoe-after' timeafter90d 1 /exp;
estimate 'RR:mtm interventions' group 1 /exp;
estimate 'RRR:(time befoe-after)*(mtm interventions)' timeafter90d*group 1 /exp;

TITLE1 "Random intercept: pre/post mtm intervention &outcomevar. BY Provider group";
TITLE2 "&modeltype";

run;

%mend didv;

%didv(wtstring =, modeltype = ADJUSTED, outcomevar = visit_rate_30);
%didv(wtstring =, modeltype = ADJUSTED, outcomevar = nvisit_rate_30);
%didv(wtstring =, modeltype = ADJUSTED, outcomevar = znvisit_rate_30);
%didv(wtstring =, modeltype = ADJUSTED, outcomevar = lnvisit_rate_30);

%didv(wtstring =, modeltype = ADJUSTED, outcomevar = ehr_rate_30);
%didv(wtstring =, modeltype = ADJUSTED, outcomevar = nehr_rate_30);
%didv(wtstring =, modeltype = ADJUSTED, outcomevar = znehr_rate_30);
%didv(wtstring =, modeltype = ADJUSTED, outcomevar = lnehr_rate_30);


**************************************************************************************************************************************
Testings;
**************************************************************************************************************************************


*categorical outcomes*;
%macro didc (wtstring =,modeltype =, outcomevar = );

options orientation=landscape;
ods csv file= "D:/arinzeproject/data/dat/tabdifv1.csv" style = Vasstables;
title1 "DiD with Control";

proc genmod data = df descending;
weight ps;
class pid group (order = formatted ref='0') / param=ref ;
model &outcomevar. = group|time / dist = binomial type3;
&wtstring;

estimate 'RR:time befoe-after' time 1 /exp;
estimate 'RR:mtm interventions' group 1 /exp;
estimate 'RRR:(time befoe-after)*(mtm interventions)' time*group 1 /exp;

TITLE1 "Random intercept: pre/post mtm intervention &outcomevar. BY Provider group";
TITLE2 "&modeltype";

run;

%mend didc;

%didc(wtstring =, modeltype = ADJUSTED, outcomevar = bpgol);
%didc(wtstring =, modeltype = ADJUSTED, outcomevar = a1cgol);
%didc(wtstring =, modeltype = ADJUSTED, outcomevar = ldlgol);



*categorical outcomes*;
%macro didv (wtstring =,modeltype =, outcomevar = );

options orientation=landscape;
ods csv file= "D:/arinzeproject/data/dat/tabdifv2.csv" style = Vasstables;
title1 "DiD with Control";

proc logistic data = df outest=betas covout;
weight ps ;
class time group (order = formatted ref='0');
model &outcomevar.(event='1') = group time group*time;  / slentry=0.3
                  slstay=0.35
                  details
                  lackfit;
&wtstring;
output out = pred p = phat lower = lcl upper = ucl
          predprob = (individual crossvalidate);
ods output Association = Association;

run;

%mend didv;

%didv(wtstring =, modeltype = ADJUSTED, outcomevar = bpgol);
%didv(wtstring =, modeltype = ADJUSTED, outcomevar = a1cgol);
%didv(wtstring =, modeltype = ADJUSTED, outcomevar = ldlgol);


%macro didglim (wtstring =,modeltype =, outcomevar = );

options orientation=landscape;
ods csv file= "D:/arinzeproject/data/dat/tabdifglm1.csv" style = Vasstables;
title1 "DiD with Control";

proc glimmix data = df;
	weight ps;
	class time group;
	model &outcomevar. = group time group*time / dist = binary;
	lsmeans group*time / slicediff = time oddsratio ilink;
run;

%mend didglim;

%didglim(wtstring =, modeltype = ADJUSTED, outcomevar = bpgol);
%didglim(wtstring =, modeltype = ADJUSTED, outcomevar = a1cgol);
%didglim(wtstring =, modeltype = ADJUSTED, outcomevar = ldlgol);


**********************************************************;
*Difference-In-Difference Analysis*
**********************************************************;


%macro didlv (wtstring =,modeltype =, outcomevar = );

options orientation=landscape;
ods csv file= "D:/arinzeproject/data/dat/tabdifglm1.csv" style = Vasstables;
title1 "DiD with Control";

proc logistic data = df;
	weight ps;
	class time group / param = glm;
	model &outcomevar. (event = "1") = time group time*group;
    oddsratio group / at(time = '1');
    lsmeans time*group / ilink oddsratio diff;
    slice time*group / sliceby(time = '1') diff oddsratio;
    lsmestimate time*group 'A vs C complicated' 1 0 -1 / exp;
    estimate 'A vs C in complicated' group 1 0 -1
           time*group 1 0 -1 0 0 0 / exp;
    contrast 'A vs C in complicated' group 1 0 -1
   		    time*group 1 0 -1 0 0 0 / estimate = exp;
run;

%mend didlv;

%didlv(wtstring =, modeltype = ADJUSTED, outcomevar = bpgol);
%didlv(wtstring =, modeltype = ADJUSTED, outcomevar = a1cgol);
%didlv(wtstring =, modeltype = ADJUSTED, outcomevar = ldlgol);
