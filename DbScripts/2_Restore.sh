echo "in custom script"
if [ -f "/pgdata_back/latest.psql.gz" ]; then
  echo "try to restore db"
  gunzip -c /pgdata_back/latest.psql.gz | psql --dbname=postgresql://postgres:psw@127.0.0.1:5432/postgres
  rm -f /pgdata_back/latest.psql.gz
#else
  #cat 1_CreateTables.sql | psql --dbname=postgresql://postgres:psw@127.0.0.1:5432/postgres
fi
