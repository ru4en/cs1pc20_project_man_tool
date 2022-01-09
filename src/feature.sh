#!/bin/bash
ERROR="\033[1;31m ERROR:\033[0m"
WARNNING="\033[1;33m WARRNING:\033[0m"
DEBUG="\033[0;102m \033[1;30m DEBUG:\033[0m"

function add_f
{
    f_name=$1    
    fileloc="${2%%.*}"
    src_location=${2%%.*}src/$1

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

    let "f_id = $feature_count + 1"

    json_file=$(jq '.features += [
    {
        "id": '$f_id',
        "name": "'$f_name'",
        "short hand": "'$shd_key'",
        "src location": "'$src_location'",
        "summery": "'$feature_sum'"
    }
    ]' $2)

    echo -e $DEBUG $json_file
    echo $json_file > $2
    
    mkdir $fileloc/src/$1
    touch $fileloc/docs/$1.md

    echo "Added $f_name to $src_location."

    git_repo=$(cat $2 | jq -r '."Git Repo"')
    echo $git_repo
    if [ $git_repo != "n" ]; then
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

function ls_f
{
    echo -e "\n\033[1;34mShort Hand\\t\\tFeature Name\\t\\tFile Location \033[m"
    feature_count=$(cat $1 | jq '.features | length')
    for i in $(seq 0 $feature_count); do
    echo -e $(cat .pmd | jq -r '.features['$i'] | "\(.id)\t\\t\\t\\t\(.name)\t\\t\\t\\t\(."src location")"')
    done
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
elif  [[ $1 == "ls_f" ]]; then ls_f $2
elif  [[ $1 == "rm_f" ]]; then rm_f
elif  [[ $1 == "rm_f" ]]; then rm_f
fi