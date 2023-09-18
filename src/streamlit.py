# write directly to the app
import streamlit as st
st.title("Hello Snowflake - Streamlit Edition")
st.write("Data is from accounts table, queried by Streamlit")

# get/show tabular data from view
from snowflake.snowpark.context import get_active_session
session = get_active_session()

data_frame = session.sql("SELECT * FROM code_schema.accounts_view;")
queried_data = data_frame.to_pandas()
st.dataframe(queried_data, use_container_width=True)