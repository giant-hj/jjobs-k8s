#!/bin/bash

if [ -e "/install/$INSTALL_FILE" ]; then
  echo "installer file exist."
else
  echo "installer file(/install/$INSTALL_FILE) not exist."
  exit 1;
fi

if [ "$DB_TYPE" == "postgres" ]; then
  export USE_DB_TYPE="use_postgresql"
elif [ "$DB_TYPE" == "oracle" ]; then
  export USE_DB_TYPE="use_oracle"
elif [ "$DB_TYPE" == "mariadb" ]; then
  export USE_DB_TYPE="use_mariadb"
elif [ "$DB_TYPE" == "mysql" ]; then
  export USE_DB_TYPE="use_mysql"
else
  export USE_DB_TYPE="use_postgresql"
fi


echo /install/$INSTALL_FILE  \
        --base_path $JJOBS_BASE  \
        --install_kind $INSTALL_KIND  \
        --install_mode I  \
        --$USE_DB_TYPE  \
        --jdbc_url $JDBC_URL \
        --dbms_user $DB_USER  \
        --dbms_pswd $DB_PASSWD  \
        --man_web_port $MANAGER_WEB_PORT  \
        --svr_service_web_port $SERVER_WEB_PORT \
        --svr_cotrol_base_port $SERVER_TCP_PORT \
        --agnt_svr_group 1 \
        --agnt_group $AGENT_GROUP_ID \
        --agnt_startup_svc_protocol http \
        --agnt_startup_svc_context jjob-server \
        --agnt_startup_svc_domain $JJOBS_SERVER_IP \
        --agnt_startup_svc_port $SERVER_WEB_PORT

echo y | /install/$INSTALL_FILE  \
        --base_path $JJOBS_BASE  \
        --install_kind $INSTALL_KIND  \
        --install_mode I  \
        --$USE_DB_TYPE  \
        --jdbc_url $JDBC_URL \
        --dbms_user $DB_USER  \
        --dbms_pswd $DB_PASSWD  \
        --man_web_port $MANAGER_WEB_PORT  \
        --svr_service_web_port $SERVER_WEB_PORT \
        --svr_cotrol_base_port $SERVER_TCP_PORT \
        --agnt_svr_group 1 \
        --agnt_group $AGENT_GROUP_ID \
        --agnt_startup_svc_protocol http \
        --agnt_startup_svc_context jjob-server \
        --agnt_startup_svc_domain $JJOBS_SERVER_IP \
        --agnt_startup_svc_port $SERVER_WEB_PORT