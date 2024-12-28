use role sysadmin;
create database if not exists admin_db;
create schema if not exists git_integration;

create or replace secret git_secret
    type = password
    username = 'mysha-mahi'
    password = 'myshamahi@123';

create or replace api integration git_api_integration
    api_provider = git_https_api
    api_allowed_prefixes = ('https://github.com/mysha-mahi')
    allowed_authentication_secrets = (git_secret)
    enabled = true;

grant usage on integration git_api_integration to role sysadmin;

use role sysadmin;
create or replace git repository sf_de
    api_integration = git_api_integration
    git_credentials = git_secret
    origin = 'https://github.com/mysha-mahi/sf_de.git';


alter git repository SF_DE fetch;
--show git branches in SF_DE;
--ls @sf_de/branches/main;
ls @sf_de/branches/main;
