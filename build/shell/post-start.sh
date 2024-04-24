#install kind: M => Do nothing
#install kind: S && ON_BOOT: yes or y or exeptagent && RESUME_ON_STARTUP: y or yes => Server resume
#install kind: A && ON_BOOT: yes or y && RESUME_ON_STARTUP: y or yes => Agent resume
#install kind: F && ON_BOOT: yes or y && RESUME_ON_STARTUP: y or yes => Server & Agent resume 
#		 && ON_BOOT: exceptagent && RESUME_ON_STARTUP: y or yes => Server resume

if [ "$INSTALL_KIND" == "S" ] || [ "$INSTALL_KIND" == "F" ]
then
        if [ "$ON_BOOT" == "yes" ] || [ "$ON_BOOT" == "y" ] || [ "$ON_BOOT" == "exceptagent" ]
        then
                RELEASE_SERVER="Y"
        fi
fi
if [ "$INSTALL_KIND" == "F" ] || [ "$INSTALL_KIND" == "A" ]
then
        if [ "$ON_BOOT" == "yes" ] || [ "$ON_BOOT" == "y" ]
        then
                RELEASE_AGENT="Y"
        fi
fi

if [ "$RELEASE_SERVER" == "Y" ]
then
	str=$HOSTNAME
        id=${str:(-1):1}
        INT=$((id))
        realServerId=$(($INT + 1))

	while true :
	do
		#1. Server gracefully release
		#1-1. Server release
		curl -sS http://127.0.0.1:$SERVER_WEB_PORT/jjob-server/test.jsp

		if [ $? -eq 0 ]; then
			curl -X PUT \
				-H "Content-Type: application/json" \
				-H "private-token: $API_PRIVATE_TOKEN" \
				-d '{"groupId":'"$AGENT_GROUP_ID"',"serverId":'"$realServerId"',"holdWorkerYn":"N"}' \
				http://$JJOB_SERVICE_NAME:$JJOB_MANAGER_SERVICE_PORT/jjob-manager/api/v1/serversetting/server/hold
			break;
		fi

		sleep 1;
	done
fi

if [ "$RELEASE_AGENT" == "Y" ]
then
	while true :
        do
                resourceInfo=$(curl -X GET \
                        -H "Content-Type: application/json" \
                        -H "private-token: $API_PRIVATE_TOKEN" \
                        "${JJOB_MANAGER_PORT/tcp:/http:}/jjob-manager/api/v1/agentmonitor/list?agentName=$HOSTNAME" | jq -r '.list[].resourceInfo // empty')
                if [ ! -z "$resourceInfo" ]
                then
                        echo "J-Jobs Agent succesfully started"
                        echo "Time : " $(date +"%T")
                        break
                fi
                sleep 1;
        done

        #2. Agent gracefully release
        #2-1. Agent release
        curl -X POST \
        -H "Content-Type: application/json" \
        -H "private-token: $API_PRIVATE_TOKEN" \
        -d "{\"groupId\":1,\"agentGroupId\":null,\"agentName\":\"$HOSTNAME\"}" \
        ${JJOB_MANAGER_PORT/tcp:/http:}/jjob-manager/api/v1/serversetting/agent/releaseAgent
fi

sleep 30;
