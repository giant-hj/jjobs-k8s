#!/bin/sh

echo "properties,log setting"
HOSTNAME=`hostname`

if [ "$INSTALL_KIND" == "A" ] || [ "$INSTALL_KIND" == "F" ] ; then
        echo "agent log setting - resource.properties"

        sed -i 's@log.file.base_path=.*$@log.file.base_path='"$LOGS_BASE/agent/\$AGENT_NAME/logs"'@g' $JJOBS_BASE/agent/app/META-INF/resource.properties
        sed -i 's@log.file.keep.backup_path=.*$@log.file.keep.backup_path='"$LOGS_BASE/agent/\$AGENT_NAME/backup"'@g' $JJOBS_BASE/agent/app/META-INF/resource.properties
        sed -i 's@log.file.keep.date_cnt=.*$@log.file.keep.date_cnt='"$LOG_KEEP_DATE"'@g' $JJOBS_BASE/agent/app/META-INF/resource.properties
        sed -i 's@log.file.keep.backup_delete_yn=.*$@log.file.keep.backup_delete_yn='"$LOG_DELETE_YN"'@g' $JJOBS_BASE/agent/app/META-INF/resource.properties

        cp $WORKING_DIR/agent-healthcheck.sh $JJOBS_BASE/agent/healthcheck.sh
        mkdir -p $JJOBS_BASE/agent/.bin

        if [ -n "$AGENT_CACHE_DIR" ] ; then
                rm -rf $JJOBS_BASE/agent/ctrl
                mkdir -p $AGENT_CACHE_DIR/$HOSTNAME/ctrl
                ln -s $AGENT_CACHE_DIR/$HOSTNAME/ctrl $JJOBS_BASE/agent/ctrl
        fi
fi

if [ "$INSTALL_KIND" == "S" ] || [ "$INSTALL_KIND" == "F" ] ; then
        echo "unwar..."
        unzip $JJOBS_BASE/server/webapps/jjob-server.war -d $JJOBS_BASE/server/webapps/jjob-server

        echo "server log setting"
        sed -i "52d" $JJOBS_BASE/server/webapps/jjob-server/WEB-INF/classes/properties/log4j2.xml
        sed -i "7d" $JJOBS_BASE/server/webapps/jjob-server/WEB-INF/classes/properties/log4j2.xml
        sed -i '/<AppenderRef ref="console/d' $JJOBS_BASE/server/webapps/jjob-server/WEB-INF/classes/properties/log4j2.xml
        sed -i 's@<!--@@g' $JJOBS_BASE/server/webapps/jjob-server/WEB-INF/classes/properties/log4j2.xml
        sed -i 's@-->@@g' $JJOBS_BASE/server/webapps/jjob-server/WEB-INF/classes/properties/log4j2.xml
        sed -i 's/\/logs001\/jjobs\/server/\/logs001\/jjobs\/server\/'"$HOSTNAME"'/g' $JJOBS_BASE/server/webapps/jjob-server/WEB-INF/classes/properties/log4j2.xml

        if [ "$USE_DB_ENCRYPT" == "Y" ] && [ -n "$ENCRYPTED_DB_USER" ] && [ -n "$ENCRYPTED_DB_PASSWD" ] ; then
                echo "meta db encryption setting"
                sed -i 's/org\.apache\.commons\.dbcp2\.BasicDataSource/jjob.common.api.common.datasource.SecureDataSource/g' $JJOBS_BASE/server/webapps/jjob-server/WEB-INF/classes/spring/context-datasource.xml
                sed -i '18d'  $JJOBS_BASE/server/webapps/jjob-server/WEB-INF/classes/spring/context-datasource.xml
                sed -i '18i    <property name="username" value='\"$ENCRYPTED_DB_USER\"'/>' $JJOBS_BASE/server/webapps/jjob-server/WEB-INF/classes/spring/context-datasource.xml
                sed -i '19d'  $JJOBS_BASE/server/webapps/jjob-server/WEB-INF/classes/spring/context-datasource.xml
                sed -i '19i    <property name="password" value='\"$ENCRYPTED_DB_PASSWD\"'/>' $JJOBS_BASE/server/webapps/jjob-server/WEB-INF/classes/spring/context-datasource.xml

        fi

        echo "edit start_server.sh"

        str=$HOSTNAME
        id=${str:(-1):1}
        INT=$((id))
        SERVER_ID=$(($INT + 1))
        sed -i 's@export JJOB_SERVER_ID=.*$@export JJOB_SERVER_ID=1-'"$SERVER_ID"'@g' $JJOBS_BASE/start_server.sh
        sed -i 's@tail -f /engn001/jjobs/server/logs/catalina.out$@tail -f /logs001/jjobs/server/server.log@g' $JJOBS_BASE/start_server.sh

        if [ -z "$JJOB_SERVICE_NAME" ]; then
          echo "skip to set the JJOB_SERVER_IP"
        else
          sed -i '3iexport JJOB_SERVER_IP='"$HOSTNAME"'.'"$JJOB_SERVICE_NAME"'' $JJOBS_BASE/start_server.sh
        fi

        echo "Download AWS JDBC Driver.."
        wget https://github.com/awslabs/aws-advanced-jdbc-wrapper/releases/download/2.0.0/aws-advanced-jdbc-wrapper-2.0.0.jar -P $JJOBS_BASE/server/webapps/jjob-server/WEB-INF/lib

fi

if [ "$INSTALL_KIND" == "M" ] || [ "$INSTALL_KIND" == "F" ] ; then
        echo "unwar..."
        unzip $JJOBS_BASE/manager/webapps/jjob-manager.war -d $JJOBS_BASE/manager/webapps/jjob-manager

        echo "manager log setting"
        sed -i "26d" $JJOBS_BASE/manager/webapps/jjob-manager/WEB-INF/classes/properties/log4j2.xml
        sed -i "7d" $JJOBS_BASE/manager/webapps/jjob-manager/WEB-INF/classes/properties/log4j2.xml
        sed -i '/<AppenderRef ref="console/d' $JJOBS_BASE/manager/webapps/jjob-manager/WEB-INF/classes/properties/log4j2.xml
        sed -i 's@<!--@@g' $JJOBS_BASE/manager/webapps/jjob-manager/WEB-INF/classes/properties/log4j2.xml
        sed -i 's@-->@@g' $JJOBS_BASE/manager/webapps/jjob-manager/WEB-INF/classes/properties/log4j2.xml
        sed -i 's/\/logs001\/jjobs\/manager/\/logs001\/jjobs\/manager\/'"$HOSTNAME"'/g' $JJOBS_BASE/manager/webapps/jjob-manager/WEB-INF/classes/properties/log4j2.xml

        if [ "$USE_REDIS_SESSION_CLUSTERING" == "Y" ] && [ -n "$REDIS_NAMESPACE" ] && [ -n "$REDIS_HOST" ] && [ -n "$REDIS_PORT" ]; then
                echo "manager xml setting for redis"
                cp $WORKING_DIR/web_redis.xml $JJOBS_BASE/manager/webapps/jjob-manager/WEB-INF/web.xml
                cp $WORKING_DIR/context-manager_redis.xml $JJOBS_BASE/manager/webapps/jjob-manager/WEB-INF/classes/spring/context-manager.xml
                sed -i 's/$REDIS_NAMESPACE/'"$REDIS_NAMESPACE"'/g' $JJOBS_BASE/manager/webapps/jjob-manager/WEB-INF/classes/spring/context-manager.xml
                sed -i 's/$REDIS_HOST/'"$REDIS_HOST"'/g' $JJOBS_BASE/manager/webapps/jjob-manager/WEB-INF/classes/spring/context-manager.xml
                sed -i 's/$REDIS_PORT/'"$REDIS_PORT"'/g' $JJOBS_BASE/manager/webapps/jjob-manager/WEB-INF/classes/spring/context-manager.xml
        fi

        if [ "$USE_DB_ENCRYPT" == "Y" ] && [ -n "$ENCRYPTED_DB_USER" ] && [ -n "$ENCRYPTED_DB_PASSWD" ] ; then
                echo "meta db encryption setting"
                sed -i 's/org\.apache\.commons\.dbcp2\.BasicDataSource/jjob.common.api.common.datasource.SecureDataSource/g' $JJOBS_BASE/manager/webapps/jjob-manager/WEB-INF/classes/spring/context-datasource.xml
                sed -i '15d'  $JJOBS_BASE/manager/webapps/jjob-manager/WEB-INF/classes/spring/context-datasource.xml
                sed -i '15i    <property name="username" value='\"$ENCRYPTED_DB_USER\"'/>' $JJOBS_BASE/manager/webapps/jjob-manager/WEB-INF/classes/spring/context-datasource.xml
                sed -i '16d'  $JJOBS_BASE/manager/webapps/jjob-manager/WEB-INF/classes/spring/context-datasource.xml
                sed -i '16i    <property name="password" value='\"$ENCRYPTED_DB_PASSWD\"'/>' $JJOBS_BASE/manager/webapps/jjob-manager/WEB-INF/classes/spring/context-datasource.xml

        fi
        
	echo "edit start_manager.sh"
	sed -i "5d" $JJOBS_BASE/start_manager.sh

        echo "Download AWS JDBC Driver.."
        wget https://github.com/awslabs/aws-advanced-jdbc-wrapper/releases/download/2.0.0/aws-advanced-jdbc-wrapper-2.0.0.jar -P $JJOBS_BASE/manager/webapps/jjob-manager/WEB-INF/lib

fi
