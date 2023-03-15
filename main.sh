#!/bin/bash

SRCDIR=/tmp/zabbix-6.4.0
ORACLEDIR=/opt/oracle/instantclient_19_18

for FILE in ${SRCDIR}/debian/*mysql*; do
  TARGET_NAME=$(echo ${FILE} | sed "s/mysql/oracle/g")
  cp -va ${FILE} ${TARGET_NAME}

  if [[ ${TARGET_NAME} == *"zabbix-"*".service"* ]]; then
    echo "Service"
    sed -i -e "/After=mysql/d" ${TARGET_NAME}
    sed -i -e "/After=mariadb/d" ${TARGET_NAME}
  fi

  sed -i -e "s/mysql/oracle/g" ${TARGET_NAME}
  sed -i -e "s/MySQL/Oracle/g" ${TARGET_NAME}
done

cat <<EOF >> ${SRCDIR}/debian/control


Package: zabbix-server-oracle
Architecture: any
Depends: ${shlibs:Depends}, ${misc:Depends}, fping, adduser, lsb-base
Pre-Depends: debconf
Recommends: snmpd
Suggests: zabbix-frontend-php, logrotate
Conflicts: zabbix-server-mysql, zabbix-server-pgsql
Description: Zabbix network monitoring solution - server (Oracle)
 Zabbix is the ultimate enterprise-level software designed for
 real-time monitoring of millions of metrics collected from tens of
 thousands of servers, virtual machines and network devices.
 .
 This package provides the software needed to integrate a host as a Zabbix
 client. It collects information from Zabbix clients and stores it in an
 Oracle database.


Package: zabbix-proxy-oracle
Architecture: any
Depends: ${shlibs:Depends}, ${misc:Depends}, fping, adduser, lsb-base
Suggests: logrotate
Conflicts: zabbix-proxy-mysql, zabbix-proxy-pgsql, zabbix-proxy-sqlite3
Description: Zabbix network monitoring solution - proxy (Oracle)
 Zabbix is the ultimate enterprise-level software designed for
 real-time monitoring of millions of metrics collected from tens of
 thousands of servers, virtual machines and network devices.
 .
 This package provides the software needed to integrate a host as a Zabbix
 proxy. It collects information from Zabbix agents, temporarily stores it
 in a Oracle database and then passes it to a Zabbix server.
EOF

sed -e "s#/ORACLE_PATH#${ORACLEDIR}#g" $(cd $(dirname $0); pwd)/rules.patch | patch -u ${SRCDIR}/debian/rules

echo "usr/share/zabbix-sql-scripts/oracle" >> ${SRCDIR}/debian/zabbix-sql-scripts.dirs

cat <<EOF >> ${SRCDIR}/debian/zabbix-sql-scripts.install
database/oracle/server.sql usr/share/zabbix-sql-scripts/oracle
database/oracle/proxy.sql usr/share/zabbix-sql-scripts/oracle
EOF
