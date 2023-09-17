## To Run

1. psql -f setup.sql **This drops and creates my_db**
2. postgraphile -c postgres:///my_db -s app_public
