CREATE OR REPLACE package body WAG.job_next_dates is

  type days_t is table of boolean index by binary_integer;

procedure debug (message in varchar2)
is

begin
  dbms_output.put_line ( message);
end debug;

function time_in_minutes (hchar in varchar2)
return number
--Accepts a 24-hour string like 09:45
--Returns number of minutes past midnight
is
  hno number;
  hrs number;
  mins number;
begin
  if hchar not like '__:__'
  then
    return -1;
  else
    hno := to_number(to_char(to_date(hchar,'hh24:mi'),'sssss'))/60 ;
   end if;
   return hno;
exception
  when others then
    debug('Error in job_next_dates: Bad time supplied: ' || hchar);
    debug('Time must be in format HH24:MI');
    return -1;
end time_in_minutes;

function weekly (Sun in boolean, Mon in boolean, Tue in boolean,
  Wed in boolean, Thu in boolean, Fri in boolean, Sat in boolean,
  hour24 in varchar2)
return date
is

  hno number;  --number of minutes past midnight
  today_is varchar2(5);
  day_table days_t;

  next_day_to_run number := null;
  boost_index number;

  bad_time exception;
  no_day_supplied exception;

begin
  --check format of hour
  hno := time_in_minutes(hour24);
  if hno < 0 then
    raise bad_time;
  end if;

  select to_char(sysdate,'D') into today_is --day number
  from dual;

  debug(today_is);

  day_table.delete;
  day_table(1) := Mon;
  day_table(2) := Tue;
  day_table(3) := Wed;
  day_table(4) := Thu;
  day_table(5) := Fri;
  day_table(6) := Sat;
  day_table(7) := Sun;
  day_table(8) := Mon;
  day_table(9) := Tue;
  day_table(10) := Wed;
  day_table(11) := Thu;
  day_table(12) := Fri;
  day_table(13) := Sat;
  day_table(14) := Sun;


  if hno/1440+trunc(sysdate) > sysdate
  then
    boost_index := 0;
  else
    boost_index := 1;
  end if;

  for i in today_is+boost_index..today_is+boost_index+6
  loop
    if day_table(i) = true
    then
      next_day_to_run := i;
      exit;
    end if;
  end loop;

  if next_day_to_run is null then
    raise no_day_supplied;
  end if;

   return trunc(sysdate)-today_is+next_day_to_run + hno/1440 ;
exception
  when bad_time then
    debug('Error in job_next_dates.weekly');
    raise;
  when no_day_supplied then
    debug('Error in job_next_dates.weekly: No day of week supplied');
    raise;
  when others then
    debug('Error in job_next_dates.weekly');
    raise;
end weekly;

function weekly (daystring in varchar2, hour24 in varchar2)
return date
is
--daystring: Contains any of MoTuWeThFrSaSu
--eg. job_next_dates.weekly('MoTuWeSa','16:34');

  mon boolean := false;
  tue boolean := false;
  wed boolean := false;
  thu boolean := false;
  fri boolean := false;
  sat boolean := false;
  sun boolean := false;
begin
  if UPPER(daystring) like '%MO%' then
    mon := true;
  end if;

  if UPPER(daystring) like '%TU%' then
    TUE := true;
  end if;

  if UPPER(daystring) like '%WE%' then
    WED := true;
  end if;

  if UPPER(daystring) like '%TH%' then
    THU := true;
  end if;

  if UPPER(daystring) like '%FR%' then
    FRI := true;
  end if;

  if UPPER(daystring) like '%SA%' then
    SAT := true;
  end if;

  if UPPER(daystring) like '%SU%' then
    SUN := true;
  end if;

  return weekly (sun, mon, tue, wed, thu, fri, sat, hour24);

end weekly;

function friendly_date(date_string in varchar2, format_string in varchar2)
return date
is
begin

  return to_date(date_string, format_string);

exception
  when others then
    debug ('Error in job_next_dates.friendly_date: Bad date or format string');
    debug ( sqlerrm );
    raise;
end ;

function specific_dates(format_string in varchar2,
  date1 in varchar2,
  date2 in varchar2 default null,
  date3 in varchar2 default null,
  date4 in varchar2 default null,
  date5 in varchar2 default null)
return date
is
  -- Specify up to five unrelated dates, all with same format string,
  -- in any order, for the job to run
  next_date date := null;
  curr_date date;
  currtime date;
begin

  currtime := sysdate + 1/100000;
  curr_date := to_date(date1,format_string);
  if curr_date > currtime then
    next_date := curr_date;
  end if;
  curr_date := to_date(date2,format_string);
  if curr_date > currtime and curr_date < next_date then
    next_date := curr_date;
  end if;
  curr_date := to_date(date3,format_string);
  if curr_date > currtime and curr_date < next_date then
    next_date := curr_date;
  end if;
  curr_date := to_date(date4,format_string);
  if curr_date > currtime and curr_date < next_date then
    next_date := curr_date;
  end if;
  curr_date := to_date(date5,format_string);
  if curr_date > currtime and curr_date < next_date then
    next_date := curr_date;
  end if;

  return next_date;
exception
  when others then
    debug ('Error in job.next_dates.specific_date: ');
    debug ( sqlerrm );
    raise;
end specific_dates;

function specific_dates(format_string in varchar2,
  date1 in varchar2,
  date2 in varchar2 default null,
  date3 in varchar2 default null,
  date4 in varchar2 default null,
  date5 in varchar2 default null,
  hour24 varchar2)
return date
is
  -- Specify up to five unrelated dates, all with same format string,
  -- in any order, for the job to run
  -- PLUS, for convenience, specify an amount of time in hours (up to 23:59)
  -- to add to each date.  This makes it easier to enter.
  -- Example :
  -- job_next_dates.specific_dates('MM/DD/YYYY','12/23/2003',
  --  '12/15/2003','12/22/2003', hour24 => '02:34');
  retval date;
  hno number;
begin
  hno := time_in_minutes(hour24);
  retval := specific_dates (format_string,
    date1, date2, date3, date4, date5) + hno/1440 ;
  return retval;
exception
  when others then
    debug ('Error in job.next_dates.specific_dates: ');
    debug ( sqlerrm );
    raise;
end specific_dates;

function every_day(hour24 in varchar2)
return date
is
  -- Return tomorrow at hour24 o'clock
begin

  return trunc(sysdate+1) + time_in_minutes(hour24)/1440 ;

exception
  when others then
    debug ('Error in job.next_dates.tomorrow: ');
    debug ( sqlerrm );
    raise;
end every_day;

function monthly_first_working
return date
is
curr_date date;
next_date date := null;
begin

SELECT MIN(DATES) INTO curr_date FROM
(
    SELECT TRUNC(TO_DATE(sysdate,'DD-MON-RRRR'),'MM')+ROWNUM -1 DATES FROM
    (
    SELECT 1
    FROM Dual
    GROUP BY CUBE (2, 2, 2, 2, 2)
    )
    WHERE ROWNUM <= ADD_MONTHS(TRUNC(TO_DATE(sysdate,'DD-MON-RRRR'),'MM'),1) - TRUNC(TO_DATE(sysdate,'DD-MON-RRRR'),'MM')
)
WHERE TO_CHAR( DATES, 'DY') NOT IN ('SAT','SUN');

--
SELECT MIN(DATES) INTO next_date FROM
(
    SELECT TRUNC(TO_DATE(add_months(sysdate,1),'DD-MON-RRRR'),'MM')+ROWNUM -1 DATES FROM
    (
    SELECT 1
    FROM Dual
    GROUP BY CUBE (2, 2, 2, 2, 2)
    )
    WHERE ROWNUM <= ADD_MONTHS(TRUNC(TO_DATE(add_months(sysdate,1),'DD-MON-RRRR'),'MM'),1) - TRUNC(TO_DATE(add_months(sysdate,1),'DD-MON-RRRR'),'MM')
)
WHERE TO_CHAR( DATES, 'DY') NOT IN ('SAT','SUN');
--

IF curr_date > trunc(sysdate)
THEN return trunc(curr_date);
ELSIF curr_date < trunc(sysdate)
THEN
return next_date;
END IF;
--
end monthly_first_working;
end job_next_dates;
/

