CREATE APPLICATION ROLE app_public;

-- create core schema+proc
CREATE SCHEMA core;
GRANT USAGE ON SCHEMA core
  TO APPLICATION ROLE app_public;

CREATE PROCEDURE CORE.HELLO()
  RETURNS STRING
  LANGUAGE SQL
  EXECUTE AS OWNER
  AS BEGIN RETURN 'Hello Snowflake!'; END;
GRANT USAGE ON PROCEDURE core.hello()
  TO APPLICATION ROLE app_public;

-- create versioned schema + view
CREATE OR ALTER VERSIONED SCHEMA code_schema;
GRANT USAGE ON SCHEMA code_schema
  TO APPLICATION ROLE app_public;

CREATE VIEW code_schema.accounts_view
  AS SELECT ID, NAME, VALUE
  FROM shared_data.accounts;
GRANT SELECT ON VIEW code_schema.accounts_view
  TO APPLICATION ROLE app_public;

-- add inline Python code
CREATE FUNCTION code_schema.addone(i int)
  RETURNS INT
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  HANDLER = 'addone_py'
AS $$
def addone_py(i): return i+1
$$;
GRANT USAGE ON FUNCTION code_schema.addone(int)
  TO APPLICATION ROLE app_public;

-- add external Python module
CREATE FUNCTION code_schema.multiply(num1 float, num2 float)
  RETURNS float
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  IMPORTS = ('/src/functions.py')
  HANDLER='functions.multiply';
GRANT USAGE ON FUNCTION code_schema.multiply(FLOAT, FLOAT)
  TO APPLICATION ROLE app_public;

-- add Streamlit object
CREATE STREAMLIT code_schema.hello_snowflake_streamlit
  FROM '/src'
  MAIN_FILE = '/streamlit.py';
GRANT USAGE ON STREAMLIT code_schema.hello_snowflake_streamlit
  TO APPLICATION ROLE app_public;