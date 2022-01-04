#!/bin/bash

function add_f
{
    f_name=$1    
    fileloc="${2%%.*}"

    for row in $(cat $2 | jq '.features' | jq -r '.[] | @base64'); do
    _jq() {
        echo ${row} | base64 --decode | jq -r ${1}
        }
        if [[ $(_jq '.name') == $f_name ]]; then 
        {
            echo "$f_name alredy exists try again with a diffrent name."
            return 1
            }
        fi
    done

    feature_count=$(cat .pmd | jq '.features | length')

    read -p "Type in a shorthand code for this feature, leave it blank to set it as default [F$feature_count] : " shd_key
    if [[ $shd_key == "" ]]; then
    shd_key=F$feature_count
    fi

    json_file=$(jq '.features += [
    {
        "name": "'$f_name'",
        "short hand": "'$shd_key'",
        "parrent": "'$parret_f'",
        "summery": "'$feature_sum'"
    }
    ]' $2)

    echo $json_file
    echo $json_file > $2
    
    mkdir $fileloc/src/$1
    touch $fileloc/docs/$1.md

    echo "Added $f_name to $fileloc."

    git_repo=$(cat .pmd | jq '.features | length')
    if [[ git_repo != "n" ]]; then
    while true; do
    read -p "Would you like to creat a new branch for $f_name? [Y/n]: " new_f_branch
    case $new_f_branch in
        [Yy]* ) git checkout -b $f_name; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer Yes or No using [Y/n].";;
        esac
    done
    fi
}

function mv_f 
{
    echo "Move\n"
}

function rm_f 
{
    echo "Remove\n"
}

if [[ $1 == "add_f" ]]; then add_f $2 $3
elif  [[ $1 == "mv_f" ]]; then mv_f
elif  [[ $1 == "rm_f" ]]; then rm_f
fi