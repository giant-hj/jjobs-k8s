#!/bin/bash

if [ -e "/install/$INSTALL_FILE" ]; then
  echo "installer file exist."
else
  echo "installer file(/install/$INSTALL_FILE) not exist."
  exit 1;
fi

echo /install/$INSTALL_FILE \
 --base_path $JJOBS_BASE  \
 --install_kind A  \
 --install_mode I  \
 --svr_service_web_port $SERVER_WEB_PORT \
 --agnt_svr_group 1 \
 --agnt_group $AGENT_GROUP_ID \
 --agnt_startup_svc_domain $JJOBS_SERVER_IP \
 --agnt_startup_svc_port $SERVER_WEB_PORT

echo y | /install/$INSTALL_FILE \
 --base_path $JJOBS_BASE  \
 --install_kind A  \
 --install_mode I  \
 --svr_service_web_port $SERVER_WEB_PORT \
 --agnt_svr_group 1 \
 --agnt_group $AGENT_GROUP_ID \
 --agnt_startup_svc_domain $JJOBS_SERVER_IP \
 --agnt_startup_svc_port $SERVER_WEB_PORT