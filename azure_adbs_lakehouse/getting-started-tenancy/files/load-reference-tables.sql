-- Creates and loads the reference tables from the Azure Blob container.
-- Called as LAKE_DEMO by provision_lake_demo.sql.

declare
  l_count pls_integer;
begin
  select count(*) into l_count
  from user_tables
  where table_name in ('GENRE', 'CUSTOMER_EXTENSION', 'CUSTOMER_SEGMENT');
  if l_count > 0 then
    raise_application_error(-20001,
      'Reference tables already exist. Use a new dedicated LAKE_DEMO schema; do not overwrite an existing schema.');
  end if;
end;
/

create table genre (
  genre_id number,
  name     varchar2(32767)
);

begin
  dbms_cloud.copy_data(
    table_name      => 'GENRE',
    credential_name => 'AZURE_BLOB_CRED',
    file_uri_list   => 'https://&blob_host/&blob_container/data/genre.csv',
    field_list      => q'["GENRE_ID" CHAR, "NAME" CHAR(32767)]',
    format          => q'~{
      "delimiter" : ",", "ignoremissingcolumns" : true,
      "ignoreblanklines" : true, "blankasnull" : true,
      "trimspaces" : "lrtrim", "quote" : "\"", "characterset" : "AL32UTF8",
      "enablelogs" : false, "skipheaders" : 1, "rejectlimit" : 10000000,
      "recorddelimiter" : "X'0A'"
    }~'
  );
end;
/

create table customer_extension (
  cust_id                number,
  last_name              varchar2(32767),
  first_name             varchar2(32767),
  email                  varchar2(32767),
  age                    number,
  commute_distance       number,
  credit_balance         number,
  education              varchar2(32767),
  full_time              varchar2(32767),
  gender                 varchar2(32767),
  household_size         number,
  income                 number,
  income_level           varchar2(32767),
  insuff_funds_incidents number,
  job_type               varchar2(32767),
  late_mort_rent_pmts    number,
  marital_status         varchar2(32767),
  mortgage_amt           number,
  num_cars               number,
  num_mortgages          number,
  pet                    varchar2(32767),
  rent_own               varchar2(32767),
  segment_id             number,
  work_experience        number,
  yrs_current_employer   number,
  yrs_residence          number
);

begin
  dbms_cloud.copy_data(
    table_name      => 'CUSTOMER_EXTENSION',
    credential_name => 'AZURE_BLOB_CRED',
    file_uri_list   => 'https://&blob_host/&blob_container/data/customer-extension.csv',
    field_list      => q'[
      "CUST_ID" CHAR, "LAST_NAME" CHAR(32767), "FIRST_NAME" CHAR(32767),
      "EMAIL" CHAR(32767), "AGE" CHAR, "COMMUTE_DISTANCE" CHAR,
      "CREDIT_BALANCE" CHAR, "EDUCATION" CHAR(32767), "FULL_TIME" CHAR(32767),
      "GENDER" CHAR(32767), "HOUSEHOLD_SIZE" CHAR, "INCOME" CHAR,
      "INCOME_LEVEL" CHAR(32767), "INSUFF_FUNDS_INCIDENTS" CHAR,
      "JOB_TYPE" CHAR(32767), "LATE_MORT_RENT_PMTS" CHAR,
      "MARITAL_STATUS" CHAR(32767), "MORTGAGE_AMT" CHAR, "NUM_CARS" CHAR,
      "NUM_MORTGAGES" CHAR, "PET" CHAR(32767), "RENT_OWN" CHAR(32767),
      "SEGMENT_ID" CHAR, "WORK_EXPERIENCE" CHAR,
      "YRS_CURRENT_EMPLOYER" CHAR, "YRS_RESIDENCE" CHAR]',
    format          => q'~{
      "delimiter" : ",", "ignoremissingcolumns" : true,
      "ignoreblanklines" : true, "blankasnull" : true,
      "trimspaces" : "lrtrim", "quote" : "\"", "characterset" : "AL32UTF8",
      "enablelogs" : false, "skipheaders" : 1, "rejectlimit" : 10000000,
      "recorddelimiter" : "X'0A'"
    }~'
  );
end;
/

create table customer_segment (
  segment_id number,
  name       varchar2(32767),
  short_name varchar2(32767)
);

begin
  dbms_cloud.copy_data(
    table_name      => 'CUSTOMER_SEGMENT',
    credential_name => 'AZURE_BLOB_CRED',
    file_uri_list   => 'https://&blob_host/&blob_container/data/customer_segment.csv',
    field_list      => q'["SEGMENT_ID" CHAR, "NAME" CHAR(32767), "SHORT_NAME" CHAR(32767)]',
    format          => q'~{
      "delimiter" : ",", "ignoremissingcolumns" : true,
      "ignoreblanklines" : true, "blankasnull" : true,
      "trimspaces" : "lrtrim", "quote" : "\"", "characterset" : "AL32UTF8",
      "enablelogs" : false, "skipheaders" : 1, "rejectlimit" : 10000000,
      "recorddelimiter" : "X'0A'"
    }~'
  );
end;
/

-- Stop if an import produced an empty reference table.
declare
  l_genre number;
  l_extension number;
  l_segment number;
begin
  select count(*) into l_genre from genre;
  select count(*) into l_extension from customer_extension;
  select count(*) into l_segment from customer_segment;
  if l_genre = 0 or l_extension = 0 or l_segment = 0 then
    raise_application_error(-20002, 'One or more reference tables are empty. Review the import before continuing.');
  end if;
end;
/

select 'GENRE' as table_name, count(*) as row_count from genre
union all
select 'CUSTOMER_EXTENSION', count(*) from customer_extension
union all
select 'CUSTOMER_SEGMENT', count(*) from customer_segment;
