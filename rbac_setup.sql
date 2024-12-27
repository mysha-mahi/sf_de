use role sysadmin;
create or replace database bakery_db;
create warehouse if not exists bakery_wh with warehouse_size = 'X-SMALL';


use role sysadmin;
use warehouse bakery_wh;
use database bakery_db;


set my_current_user = current_user();

create or replace schema bakery_db.raw_schema with managed access;
create or replace schema bakery_db.rpt_schema with managed access;

use role accountadmin;
drop role if exists bakery_full_role;
drop role if exists bakery_read_role;

use role useradmin;
create or replace role data_engineer_role;
create or replace role data_analyst_role;

create or replace role bakery_full_role;
create or replace role bakery_read_role;


use role securityadmin;

grant usage on database bakery_db to role bakery_full_role;
grant usage on schema bakery_db.raw_schema to role bakery_full_role;
grant usage on schema bakery_db.rpt_schema to role bakery_full_role;
grant all on schema bakery_db.raw_schema to role bakery_full_role;
grant all on schema bakery_db.rpt_schema to role bakery_full_role;
grant role bakery_full_role to role data_engineer_role;
grant role data_engineer_role to role sysadmin;
grant role data_engineer_role to user identifier($my_current_user);
grant usage on warehouse bakery_wh to role data_engineer_role;


grant usage on database bakery_db to role bakery_read_role;
grant usage on schema bakery_db.raw_schema to role bakery_read_role;
grant usage on schema bakery_db.rpt_schema to role bakery_read_role;
grant select on all tables in schema bakery_db.rpt_schema to role bakery_read_role;
grant select on all views in schema bakery_db.rpt_schema to role bakery_read_role;
grant select on future tables in schema bakery_db.rpt_schema to role bakery_read_role;
grant select on future views in schema bakery_db.rpt_schema to role bakery_read_role;
grant role bakery_read_role to role data_analyst_role;
grant role data_analyst_role to role sysadmin;
grant role data_analyst_role to user identifier($my_current_user);
grant usage on warehouse bakery_wh to role data_analyst_role;

use role useradmin;
create or replace role data_analyst_bread_role;
create or replace role data_analyst_pastry_role;

grant role bakery_read_role to role data_analyst_bread_role;
grant role bakery_read_role to role data_analyst_pastry_role;

use role sysadmin;

create schema if not exists bakery_db.dg_schema with managed access;
grant all on schema bakery_db.dg_schema to role bakery_full_role;

use role securityadmin;
grant role data_analyst_bread_role to role sysadmin;
grant role data_analyst_pastry_role to role sysadmin;
grant role data_analyst_bread_role to user identifier($my_current_user);
grant role data_analyst_pastry_role to user identifier($my_current_user);


use role sysadmin;
grant usage on warehouse bakery_wh to role data_analyst_bread_role;
grant usage on warehouse bakery_wh to role data_analyst_pastry_role;

use role accountadmin;
grant create row access policy on schema bakery_db.dg_schema to role data_engineer_role;
grant apply row access policy on account to role data_engineer_role;
