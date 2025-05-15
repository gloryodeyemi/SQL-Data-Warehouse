docker run \
  -e "ACCEPT_EULA=1" \
  -e "MSSQL_SA_PASSWORD=YourPasswordHere!" \
  -e "MSSQL_PID=Developer" \
  -e "MSSQL_USER=SA" \
  -p 1433:1433 \
  # -v sqlvolume:/var/opt/mssql \
  -v /Users/new/Downloads/Tutorials/Projects/Data_Engineering/SQL_Data_Warehouse/datasets:/data \
  -d \
  --name=sql \
  mcr.microsoft.com/azure-sql-edge