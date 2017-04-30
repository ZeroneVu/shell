#!/bin/bash

# path of current script directory
localPATH="/script"

# remote repository of the script
remoteRepo="https://github.com/ZeroneVu/shell.git"

git -C $localPATH remote add upstream $remoteRepo
git -C $localPATH fetch origin
git -C $localPATH checkout master

newCommitID=$(git -C $localPATH log master..origin/master --oneline | awk {'print $1'})

if [[ ! -z $newCommitID ]]; then
  echo "has something"
else
  echo "nothing"
fi


#git -C $localPATH reset --hard origin/master

sep='---------------'                                   
for d in $localPATH/*; do
  echo $sep"Processing" $d$sep
  
  # git -C $d remote add upstream $remoteRepo
  # git -C $d fetch origin
  #git -C $d log HEAD..origin/master --oneline
  
done
