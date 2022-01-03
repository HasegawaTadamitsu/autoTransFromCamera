#!/bin/sh
#set -x
set -eu

export INTERVAL_PING_SLEEP_SEC=10
export INTERVAL_GET_FILES_SLEEP_SEC=60
export LOCK_FILE=/tmp/lock_file.`basename $0`_$IP.lock_file

check_ip(){
    echo "check ${IP}"
    while true
    do
	for i in `seq 0 360`
	do
	    set +e
	    ping -c 1 -w 1 $IP  >/dev/null
	    ret=$?
	    set -e
	    if [ $ret -eq 0 ];then 
		#  alive
		return
	    fi
#	    echo "not alive.sleep ${INTERVAL_PING_SLEEP_SEC}"
	    sleep $INTERVAL_PING_SLEEP_SEC
	done
	echo  " not found ${IP}"
    done
}
check_lock(){
    if [ -e $LOCK_FILE ]; then
	echo " lock file find `echo $LOCK_FILE`"
	echo " cat lock file. `cat $LOCK_FILE`"
	echo " exit "
	exit 1
    fi
    echo "start date:"  >  $LOCK_FILE
    date                >> $LOCK_FILE
    echo "pid:"         >> $LOCK_FILE
    echo $$             >> $LOCK_FILE
}

delete_lock(){
    rm -rf  $LOCK_FILE
}
check_lock
while true
do
    check_ip
    echo "now " `date`
    stdbuf -oL -eL /home/webalbum/.rbenv/shims/ruby trans_file.rb $cp_dist $IP
    echo "now " `date`
    echo "sleeping $INTERVAL_GET_FILES_SLEEP_SEC ."
    sleep $INTERVAL_GET_FILES_SLEEP_SEC
done


delete_lock
