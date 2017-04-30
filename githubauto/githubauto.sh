#!/bin/bash

# path of current script directory
localPATH="/script"

# remote repository of the script
remoteRepo="https://github.com/ZeroneVu/shell.git"

# determine hostname
hostName=$(hostname)

if [ ! `git -C $localPATH branch --list $hostName `]
then
   hostName="master"
fi

git -C $localPATH remote add upstream $remoteRepo
git -C $localPATH fetch origin
git -C $localPATH checkout $hostName

newCommitID=$(git -C $localPATH log $hostName..origin/$hostName --oneline | awk {'print $1'})

if [[ ! -z $newCommitID ]]; then
  echo "has new commit for branch \""$hostName"\""
  git -C $localPATH reset --hard origin/$hostName
  supervisorctl restart minicheck
else
  echo "nothing"
fi