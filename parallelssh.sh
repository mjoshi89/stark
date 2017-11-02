#!/usr/bin/env bash

pid_file="/tmp/pid.txt"
log_file_path="/tmp/"
count=1
#Making sure the temporary file is empty
> ${pid_file}


usage() {
  echo "Usage $0 -s Hostnames/servernames(comma separated) as the parameter, [-p Number of servers the script should execute in parallel]" ;
  exit 1;
}

wait_for_pids() {
  while read pid
  do
    echo "wait ${pid}"
    wait ${pid}
  done < ${pid_file}
}
# parse command line
if [ $# -eq 0 ]; then #  must be at least one arg
    usage
    exit 1 ;
fi

while getopts s:p: OPT; do
    case $OPT in
    s)  servername=$OPTARG ;;
    p)  batchnumber=$OPTARG ;;
    *)  usage
    esac
done

if [ -z ${batchnumber} ] || [ ${batchnumber} -lt 1 ]
then
  echo "Number of servers in which script should execute is not provided or is less than 1. Defaulting it to 10"
  BATCHNUMBER=10
fi

read -p "what command you want to execute: " command

export IFS=","
for server in ${servername}; do
  server_name="$(echo -e "${server}" | tr -d '[:space:]')"
  echo "****Sending command for $server_name *******"
  mv -f ${log_file_path}/${server_name}.log ${log_file_path}/${server_name}.log.bkp
  ssh -o ServerAliveInterval=60 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ${server_name} "${command}" >> ${log_file_path}/${server_name}.log &
  echo -e "$!" >> ${pid_file}
#Local testing
# "$command" >> ${log_file_path}/$server.log &

  if [ ${count} -lt ${batchnumber} ]
  then
    ((count+=1));
  else
    echo "Count is greater than no. of parallel connections allowed, so waiting now"
    wait_for_pids
    >${pid_file}
    count=1
  fi
done
#Wait for the len(servername)%batchnumber
wait_for_pids

#Can do something with logfiles here
