DROP APPLICATION IF EXISTS native_app CASCADE;
DROP APPLICATION PACKAGE IF EXISTS native_package;

-- create app package
CREATE APPLICATION PACKAGE IF NOT EXISTS native_package;
SHOW APPLICATION PACKAGES;
USE APPLICATION PACKAGE native_package;

-- create data to share through a view
CREATE SCHEMA IF NOT EXISTS shared_data;
GRANT USAGE ON SCHEMA shared_data TO SHARE
   IN APPLICATION PACKAGE native_package;

CREATE TABLE IF NOT EXISTS accounts
    (ID INT, NAME VARCHAR, VALUE VARCHAR);
INSERT INTO accounts VALUES
    (1, 'Nihar', 'Snowflake'),
    (2, 'Frank', 'Snowflake'),
    (3, 'Benoit', 'Snowflake'),
    (4, 'Steven', 'Acme');
GRANT SELECT ON TABLE accounts TO SHARE
   IN APPLICATION PACKAGE native_package;

-- create stage and load app files
CREATE SCHEMA IF NOT EXISTS native_schema;
USE SCHEMA native_schema;

CREATE STAGE IF NOT EXISTS native_stage
    directory = (enable = true)
    file_format = (type = 'CSV' field_delimiter = None record_delimiter = None);
REMOVE @native_stage pattern='.*';

PUT file://C:\Projects\native-app\manifest.yml @native_stage
    overwrite=true auto_compress=false;
PUT file://C:\Projects\native-app\readme.md @native_stage
    overwrite=true auto_compress=false;
PUT file://C:\Projects\native-app\src\* @native_stage/src
    overwrite=true auto_compress=false;
LIST @native_stage;

-- create app
CREATE APPLICATION native_app
    FROM APPLICATION PACKAGE native_package
    USING @native_stage
    DEBUG_MODE = true;
SHOW APPLICATIONS;