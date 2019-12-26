#!/bin/bash
#
# Created by Uruncle @ https://adage.app Cardano Stake Pool
#
# Disclaimer:
#
#  The following use of shell script is for demonstration and understanding
#  only, it should *NOT* be used at scale or for any sort of serious
#  deployment, and is solely used for learning how the node and blockchain
#  works, and how to interact with everything.
#
### CONFIGURATION
export PATH=$PATH:/home/uruncle/.cargo/bin
JCLI="jcli"
JCLI_PORT=8443
LAST_BLOCK=""
START_TIME=$SECONDS
RESTART_GT=360

while true
do
    TIME=$(date '+%Y-%m-%d %H:%M:%S')
    LATEST_BLOCK=$($JCLI rest v0 node stats get --host "http://127.0.0.1:${JCLI_PORT}/api" | grep lastBlockHeight | awk '{print $2}')

    if [ "$LATEST_BLOCK" > 0 ]; then
        if [ "$LATEST_BLOCK" != "$LAST_BLOCK" ]; then
            START_TIME=$(($SECONDS))
            echo "${TIME} New block height: ${LATEST_BLOCK}"
            LAST_BLOCK="$LATEST_BLOCK"
        else
            ELAPSED_TIME=$(($SECONDS - $START_TIME))
            echo "${TIME} Current block height: ${LATEST_BLOCK} - No new block for ${ELAPSED_TIME} sec."
            if [ "$ELAPSED_TIME" -gt "$RESTART_GT" ]; then
                echo ""
                echo "${TIME} Restarting jormungandr"
                jcli rest v0 shutdown get --host "http://127.0.0.1:${JCLI_PORT}/api"
                echo "Sleeping for 5 sec."
                sleep 5
                echo "Sending restart command to screen"
                screen -S ada -X stuff "./jmg_start_pool.sh^M"
                #screen -S ada -X stuff "./jmg_start_node.sh^M"
                LAST_BLOCK="$LATEST_BLOCK"
                echo "Sleeping for 60 sec."
                sleep 60
            fi
        fi
    else
        echo "No block height"
        # Reset time
        START_TIME=$(($SECONDS))
    fi
    sleep 20
done

exit 0