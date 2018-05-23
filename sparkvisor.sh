#!/bin/bash
# service to monitor (required parameter)
service=
# check interval in seconds (default=30)
interval=30
# number of seconds to wait before restarting service (default=10)
wait=10
# number of attempts to restart the service (default=5)
attempts=5
# more verbose output for testing purposes
verbose=0
# log file location
log="./error.log"

# output message to a log file
create_log (){
    echo $message >> $log;
}
# Check if the service is running and restart it if needed
# Enable -v argument to see output in the console
# Log every restart attempt for debugging purposes
check_service() {
    # will output 0 if the service is not running
    state="$(pgrep -x $service | wc -l)";
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    # print to console if -v flag is set
    if (( $verbose != "0" )); then
        printf "$dt : [Verbose] Service $service running [wait=$wait] [interval=$interval]\n"
    fi
    # check if service is not running and restart if attempts threshold is not reached
    if (( $state == "0" )); then
        if (( $times < $attempts )); then
            message="$dt : Service [$service] not running, restarting ... #$times";
            printf "$message \n";
            create_log $message;
            service $service restart;
            ((times++))
        else
            # attempts exceeded, exit from the script
            printf "Service failed to start after $times attempts, exiting...! \n"
            times=1
            exit 1
        fi
    else 
        # service running - reset attempts
        times=1
    fi
}

# Main function running in specified interval
supervise () {
    start=$(date '+%d/%m/%Y %H:%M:%S');
    printf "$start : Started supervising $service service  \n"
    # Calling check_services according to wait interval
    times=1;
    while true;
    do
        check_service;
        sleep $wait;
    done
}

# Check command line parameters and parse them to variables
while [ "$1" != "" ]; do
    case $1 in
        -a ) shift
        attempts=$1;;
        -s ) shift
        service=$1;;
        -i ) shift
        interval=$1;;
        -w ) shift
        wait=$1;;
        -v ) shift
        verbose=$1;;
        -l ) shift
        log=$1;;
    esac
    shift
done

# Exit main process if the service name is not provided
if [ -z $service ]; then
    printf "Service name must be provided! (-s flag is required)\n"
    exit 1
else
    # Call main function according to interval argument
    while true;
    do
        supervise $service $wait $attempts $interval
        sleep $interval;
    done
fi

# some of the native Linux services that can be checked
# acpid, ligthdm, uuidd

# EXAMPLE COMMAND
# Check mysql daemon process every 30 seconds, try to restart every 5 seconds for 10 times, output log and console
# sudo ./sparkvisor.sh -s mysqld -i 30 -w 5 -a 10 -v 1 -l myslqd.log