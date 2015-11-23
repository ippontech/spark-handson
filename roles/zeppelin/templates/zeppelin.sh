#!/bin/bash -e
# description: Zeppelin
# processname: zeppelin
# chkconfig: 234 20 80
#
# App 8 start/stop/status init.d script
# Initially forked from: https://gist.github.com/valotas/1000094
# @author: Miglen Evlogiev <bash@miglen.com>
#
# Release updates:
# Updated method for gathering pid of the current proccess
# Added usage of APP_BASE
# Added coloring and additional status
# Added check for existence of the app user
# Added termination proccess

#APP_USER is the default user of the app
export APP_USER={{user}}

#APP_USAGE is the message if this script is called without any options
APP_USAGE="Usage: $0 {\e[00;32mstart\e[00m|\e[00;31mstop\e[00m|\e[00;31mkill\e[00m|\e[00;32mstatus\e[00m|\e[00;31mrestart\e[00m}"
 
#SHUTDOWN_WAIT is wait time in seconds for java proccess to stop
SHUTDOWN_WAIT=20
 
app_pid() {
  echo `ps -fe | grep $APP_BASE | grep -v grep | tr -s " "|cut -d" " -f2`
}
 
start() {
  pid=$(app_pid)
  if [ -n "$pid" ]
  then
    echo -e "\e[00;31mApp is already running (pid: $pid)\e[00m"
  else
    # Start app
    echo -e "\e[00;32mStarting app\e[00m"
    if [ `user_exists $APP_USER` = "0" ]
    then
      echo echo -e "\e[00;31mUser $APP_USER does not exist\e[00m"
      exit 1
    fi
    /bin/su $APP_USER -c 'export SPARK_HOME={{spark_dir}} && export JAVA_HOME=/usr/lib/jvm/java-7-oracle/ && nohup {{zeppelin_dir}}/bin/zeppelin-daemon.sh start'
    status
  fi
  return 0
}
 
status(){
  pid=$(app_pid)
  if [ -n "$pid" ]; then echo -e "\e[00;32mApp is running with pid: $pid\e[00m"
  else echo -e "\e[00;31mApp is not running\e[00m"
  fi
}
 
terminate() {
  echo -e "\e[00;31mTerminating App\e[00m"
  kill -9 $(app_pid)
}
 
stop() {
  pid=$(app_pid)
  if [ -n "$pid" ]
  then
    echo -e "\e[00;31mStoping App\e[00m"
    #/bin/su -p -s /bin/sh $APP_USER
    kill $(app_pid)
 
    let kwait=$SHUTDOWN_WAIT
    count=0;
    until [ `ps -p $pid | grep -c $pid` = '0' ] || [ $count -gt $kwait ]
    do
      echo -n -e "\n\e[00;31mwaiting for processes to exit\e[00m";
      sleep 1
      let count=$count+1;
    done
 
    if [ $count -gt $kwait ]; then
      echo -n -e "\n\e[00;31mkilling processes didn't stop after $SHUTDOWN_WAIT seconds\e[00m"
      terminate
    fi
  else
    echo -e "\e[00;31mApp is not running\e[00m"
  fi
 
  return 0
}
 
user_exists(){
  if id -u $1 >/dev/null 2>&1; then
    echo "1"
  else
    echo "0"
  fi
}
 
case $1 in
  start)
    start
  ;;
  stop)  
    stop
  ;;
  restart)
    stop
    start
  ;;
  status)
    status
  ;;
  kill)
    terminate
  ;;    
  *)
    echo -e $APP_USAGE
  ;;
esac    
exit 0