#!/bin/bash

function init() {
    echo -n "What would you like to call the"
}

init



init()
  ask project name
  ask git url
  check if project config exist in parrent folders
  if not
    then create folders [src, docs, bin, test, lib]
    create folder [main] in [src]
    init git
    ask git url
    git remote add
    log folder structure to configfile
  if true
    exit with msg