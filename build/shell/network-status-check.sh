#!/bin/bash
# Get JDBC Host and Port
db_host=$(echo $JDBC_URL | sed -E 's/jdbc:[a-z]+:\/\/([^:/]+).*/\1/')
db_port=$(echo $JDBC_URL | sed -E 's/jdbc:[a-z]+:\/\/[^:/]+:([0-9]+).*/\1/')

#check network status from manager/server to db
if [ "$INSTALL_KIND" == "M" ] || [ "$INSTALL_KIND" == "S" ] || [ "$INSTALL_KIND" == "F" ]
then
    if [ "$ON_BOOT" == "yes" ] || [ "$ON_BOOT" == "y" ] || [ "$ON_BOOT" == "exceptagent" ]
    then
        while true; do
            if timeout 3 bash -c "echo > /dev/tcp/$db_host/$db_port"; then
                echo "$(TZ="Asia/Seoul" date +'%Y-%m-%d %T') Database connection is available."
                break
            else
                echo "$(TZ="Asia/Seoul" date +'%Y-%m-%d %T') Database connection failed. Retrying in 5 seconds..."
                sleep 5
            fi
        done
    fi
fi
#check network status from agent to server
if [ "$INSTALL_KIND" == "A" ]
then
    if [ "$ON_BOOT" == "yes" ] || [ "$ON_BOOT" == "y" ]
    then
        while true; do
            if timeout 3 bash -c "echo > /dev/tcp/$JJOBS_SERVER_IP/$SERVER_WEB_PORT"; then
                echo "$(TZ="Asia/Seoul" date +'%Y-%m-%d %T') jjob-server is available."
                break
            else
                echo "$(TZ="Asia/Seoul" date +'%Y-%m-%d %T') jjob-server status check failed. Retrying in 5 seconds..."
                sleep 5
            fi
        done
    fi
fi