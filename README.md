# cardano-scripts
Bash scripts for Cardano stake pool operators.

## Get stuck nodes unstuck
`stuck_node_mon.sh` restarts stuck jormungandr v0.8.5 (and below) nodes. Hopefully it will soon 
become obsolete :-) 

stuck_node_mon.sh monitors jormungander blocks. If jormungandr is running and there are no new 
blocks for +360 seconds the script will restart jormungandr. The script is running in an infinite loop.

The script is tailored to my own environment, but it can easily be altered.  

I use linux screen to run jormungandr in the background. The screen I use to run jormungandr is simply 
called "ada". jcli is used to shut down jormungandr cleanly. jormungandr (in the 
"ada" screen) is then restarted by calling the bash script I use to start the 
pool: `screen -S ada -X stuff "./jmg_start_pool.sh^M"`  

### Configuration
```
export PATH=$PATH:/home/uruncle/.cargo/bin
JCLI="jcli"
JCLI_PORT=3100
LAST_BLOCK=""
RESTART_GT=360
```

### My pool
If you find this useful please support my pool: https://adage.app