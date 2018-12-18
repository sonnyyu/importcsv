#!/bin/bash

# show commands being executed, per debug

set -x

exec > >(sudo tee install.log)
exec 2>&1


# define database connectivity
_db="csv_imports"
_db_user="root"
_db_password="Pass2w0rd~"
mysql -u${_db_user} -p${_db_password}  -e "DROP DATABASE IF EXISTS ${_db}"
mysql -u${_db_user} -p${_db_password}  -e "CREATE DATABASE ${_db}"
mysql -u${_db_user} -p${_db_password} -e "GRANT ALL PRIVILEGES ON ${_db}.* TO ${_db}@localhost IDENTIFIED BY '${_db_password}'"
rm -rf /var/lib/mysql-files/*
cp  /opt/splunk/etc/apps/Splunk_Security_Essentials/lookups/* /var/lib/mysql-files/
# define directory containing CSV files
#_csv_directory="/opt/splunk/etc/apps/Splunk_Security_Essentials/lookups"
_csv_directory="/var/lib/mysql-files"
# go into directory
cd $_csv_directory

# get a list of CSV files in directory
_csv_files=`ls -1 *.csv`

# loop through csv files
for _csv_file in ${_csv_files[@]}
do

  # remove file extension
  _csv_file_extensionless=`echo $_csv_file | sed 's/\(.*\)\..*/\1/'`

  # define table name
  _table_name="${_csv_file_extensionless}"

  # get header columns from CSV file
  _header_columns=`head -1 $_csv_directory/$_csv_file | tr ',' '\n' | sed 's/^"//' | sed 's/"$//' | sed 's/ /_/g'`
  _header_columns_string=`head -1 $_csv_directory/$_csv_file | sed 's/ /_/g' | sed 's/"//g'`

  # ensure table exists
  mysql -u $_db_user -p$_db_password $_db << eof
    CREATE TABLE IF NOT EXISTS \`$_table_name\` (
      id int(11) NOT NULL auto_increment,
      PRIMARY KEY  (id)
    ) ENGINE=MyISAM DEFAULT CHARSET=latin1
eof

  # loop through header columns
  for _header in ${_header_columns[@]}
  do

    # add column
    mysql -u $_db_user -p$_db_password $_db --execute="alter table \`$_table_name\` add column \`$_header\` text"

  done

  # import csv into mysql
  mysqlimport --fields-enclosed-by='"' --fields-terminated-by=',' --lines-terminated-by="\n" --columns=$_header_columns_string -u $_db_user -p$_db_password $_db $_csv_directory/$_csv_file

done
exit
