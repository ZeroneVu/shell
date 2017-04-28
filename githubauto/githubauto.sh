#!/bin/bash

# path of current script directory
localPATH="/script"

# remote repository of the script
remoteRepo="https://github.com/ZeroneVu/shell.git"

sep='---------------'                                   
for d in $localPATH/*; do
  echo $sep"Processing" $d$sep
  
  git -C $d remote add upstream $remoteRepo
  git -C $d fetch origin
  git -C $d log HEAD..origin/master --oneline
  
done
