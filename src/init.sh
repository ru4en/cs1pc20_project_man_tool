#!/bin/bash
ERROR="\033[1;31m ERROR:\033[0m"
WARNNING="\033[1;33m WARRNING:\033[0m"
DEBUG="\033[44m ERROR:\033[0m"


function create_dotfile
{
    touch .pmd

    while getopts n:a:g:l: flag
    do
        case "${flag}" in
            n) project_name=${OPTARG};;
            a) author=${OPTARG};;
            g) GITR=${OPTARG};;
            l) fileloc=${OPTARG};;
        esac
    done

    echo '{
  "Project Name": "'$project_name'",
  "Author(s)": [
    "'$author'"
  ],
  "Git Repo": "'$GITR'",
  "File Root": "'$fileloc'",
  "users": [
    "'$author'"
  ],
  "features": [
    {
      "id": 1,
      "name": "main",
      "short hand": "main",
      "src location": "'$fileloc/src/main'",
      "summery": "This is the main diroctory"
    }
  ],
  "tests": [
    {
      "id": 1,
      "name": "test1",
      "short hand": "T1",
      "summery": "First test",
      "result": "Test if pm sucessfuly inicilised",
      "pass fail": true
    }
  ]
}' | jq > .pmd
}

function init
{
    while true; do
        read -p "What would you like to call the project? " project_name
        if [[ $project_name == "" ]]; then
            echo -e "$ERROR Please set a valid name for your project."
        else
            echo "Creating project $project_name..."
            break
        fi
    done

    while true; do
        read -p "Would you like to configure git? [URL/n], If so input the remote: " gitR
        if [[ $gitR == "n" ]] || [[ $gitR == "N" ]]; then
            echo "Git not set..."
            break
        elif [[ $gitR != "" ]]; then
            echo "initialising Git..."
            git init -q
            echo "Adding $gitR to remote..."
            git remote add origin $gitR
            break
        fi
    done

    dirs="src docs bin tests lib"
    for dir in $dirs;do
        echo "Creating $dir directory..."
        mkdir $dir
    done

    mkdir $fileloc/src/main

    touch docs/main.md
    touch README.md
    
    create_dotfile -n $project_name -a $USER -g $gitR -l $(pwd)
}

if [[ $1 == "init" ]]; then init
fi
