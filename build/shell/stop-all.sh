$JJOBS_BASE/stop_agent.sh &
sleep 10
$JJOBS_BASE/stop_server.sh &
sleep 10
$JJOBS_BASE/stop_manager.sh &