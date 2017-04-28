#!/bin/bash
localPATH=`pwd`                                         # path of current directory
sep='---------------'                                   
for d in */; do
  echo $sep"Processing" $d$sep
  d=`echo $d | sed s#/##`                               # remove trailing forward slash
  remoteRepo="https://github.com/hackreactor/$d.git"    # location of remote repo
  git -C $localPATH/$d remote add upstream $remoteRepo  # add remote repo as upstream
  git -C $localPATH/$d checkout master                  # checkout master branch in current $d
  firstCommit=`git -C $localPATH/$d rev-list HEAD | tail -n 1`  # identify the first commit in master
  git -C $localPATH/$d checkout $firstCommit            # checkout first commit
  git -C $localPATH/$d branch solution                  # create a solution branch if not present
  git -C $localPATH/$d checkout solution                # checkout solution branch
  git -C $localPATH/$d pull upstream solution           # pull from remote into solution
  git -C $localPATH/$d checkout master                  # checkout master branch
  echo -e "\n"
done
