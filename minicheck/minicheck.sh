#!/bin/bash


INTERVAL=30

# this godlike function is copied from http://stackoverflow.com/a/3211182/2540986
killtree() {
    local _pid=$1
    local _sig=${2:--TERM}
    
    # needed to stop quickly forking parent from producing children between child killing and parent killing
    # very much explanation come from this http://www.pervasivecode.com/blog/2010/04/03/unix-tip-kill-stop-and-kill-cont/
    # to make it short ... cease/freeze all functions of process with ($_pid) that ID
    kill -stop ${_pid}
    
    # recursive call of kill
    for _child in $(ps -o pid --no-headers --ppid ${_pid}); do
        killtree ${_child} ${_sig}
    done
    kill -${_sig} ${_pid}
}

isGood(){
  # unset all variables for better memory ... maybe
  unset retval
  
  # bash shell condition will understand 0 as success/true/good/correct and 1 for oposite 
  local retval=1
  
  # Condition to return good status.
  # Make sure the command inside if (command) always return 0 or 1
  # Example:
  # if (return $(curl -s 'http://localhost:8001/health/shallow' | awk 'match($0, /.*"status":"good".*/){ print 0;exit}{print 1}')); then
  #	retval=0
  # fi	  
  if (return 0); then
  	retval=0
  fi
  
  return $retval
}

doRescue(){

  # search and destroy. let's kill the old stuck up processes
  ps aux | grep name_of_victim | grep -v grep | awk '{ print $1}' |
    while read PID; do
      # TODO better print out information of killed processes and store it to log   
      killtree $PID 9
    done

  # trigger the necessary services
  # Example:
  # cd $GOPATH/src/github.com/Comcast/rulio/ && nohup ./bin/startengine.sh > /dev/null 2>&1 &
  echo 'services restarted'
}

while true
do 
  
  # okei i'm not feeling alright
  if ! isGood; then
    doRescue
  else
    # TODO providing a better log logic
    echo "{\"status\":\"good\",\"time\":\"`date "+%Y-%m-%d %H:%M:%S"`\"}"
  fi   
  
  # Sleepless nights. From here to eternity
  sleep $INTERVAL
done