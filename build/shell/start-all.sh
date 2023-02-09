$JJOBS_BASE/start_manager.sh &
sleep 30
$JJOBS_BASE/start_server.sh &
sleep 60
$JJOBS_BASE/start_agent.sh &