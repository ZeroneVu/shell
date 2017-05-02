#!/bin/bash

# path of current script directory
localPATH="/script"

# remote repository of the script
remoteRepo="https://github.com/ZeroneVu/shell.git"

git -C $localPATH remote add upstream $remoteRepo
git -C $localPATH fetch origin

# determine hostname
hostName=$(hostname)

# if remote doesn't has branch same name with host name
if [ ! `git -C $localPATH ls-remote --heads $remoteRepo $hostName|awk -v p="\/$hostName$" '{if(match($2,p)){print 0;}}'` ];then
  hostName="master"
else
  # checking that local git branch has $hostName branch or not
  if [ ! `git -C $localPATH branch --list $hostName|awk '{if ($0) print 0;}'` ];then
    # if $hostName branch doesn't existed on local yet ... create it with -b 
    git -C $localPATH checkout -b $hostName
  fi
fi

git -C $localPATH checkout $hostName

newCommitID=$(git -C $localPATH log $hostName..origin/$hostName --oneline | awk {'print $1'})

if [[ ! -z $newCommitID ]]; then
  echo "has new commit for branch \""$hostName"\""
  git -C $localPATH reset --hard origin/$hostName
  supervisorctl restart minicheck
else
  echo "nothing"
fi