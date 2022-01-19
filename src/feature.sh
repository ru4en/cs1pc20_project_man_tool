#!/bin/bash
ERROR="\033[1;31m ERROR:\033[0m"
WARNNING="\033[1;33m WARRNING:\033[0m"
DEBUG="\033[0;102m \033[1;30m DEBUG:\033[0m"

function add_f
{
    f_name=$1
    fileloc="${2%%.*}"
    src_location=src/$1

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
    f_id=$(jq '.features | length' $2)

    read -p "Type in a shorthand code for this feature, leave it blank to set it as default [F$f_id] : " shd_key
    if [[ $shd_key == "" ]]; then
    shd_key=F$f_id
    fi


    json_file=$(jq '.features += [
    {
        "id": '$f_id',
        "name": "'$f_name'",
        "short hand": "'$shd_key'",
        "src location": "'$src_location'",
        "summery": "'$feature_sum'"
    }
    ]' $2)
    let "f_id = $f_id + 1"

    echo -e $DEBUG $json_file
    echo $json_file > $2
    
    mkdir $fileloc/src/$1
    touch $fileloc/docs/$1.md

    echo "Added $f_name to $src_location."

    git_repo=$(jq -r '."Git Repo"' $2)
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
    echo -e "\n\033[1;34mID\\t\\tShort Hand\\t\\tFeature Name\\t\\tFile Location \033[m"
    feature_count=$(expr $(jq '.features | length' $1) - 1)
    for i in $(seq 0 $feature_count); do
    echo -e $(jq -r '.features['$i'] | "\(.id)\t\\t\\t\(."short hand")\t\\t\\t\\t\(.name)\t\\t\\t\\t\(."src location")"' $1)
    done
}

function mv_f 
{
    ls_f $1
    printf "\nInput the ID number to move.\n\n"

    while [[ true ]]; do
        read -p "What feature would you like to move?: " feature_1_id
        read -p "Where would you like to move it?: " feature_2_id
        feature_1=$(jq -r '.features[] | select( .id == '$feature_1_id' )."src location"' $1 2>&1)
        feature_2=$(jq -r '.features[] | select( .id == '$feature_2_id' )."src location"' $1 2>&1)
        if [ -d "$feature_1" ] && [ -d "$feature_2" ]; then 
        break
        else 
        printf "\n$ERROR Input the ID number to move the feature. EG: 1, 2, ... 68, 69...\n\n"
        fi
        done

    echo "Moving $feature_1 to $feature_2..."

    tmp=$(mktemp)

    feature_1_jid=$(jq -r '.features[] | select( .id == '$feature_1_id' )."id"' $1)
    echo basename $feature_2
    fet_1_name=$(echo $(basename $feature_1))
    jq '.features['$feature_1_jid']."src location" = "'$feature_2'/'$fet_1_name'"' $1 > "$tmp" && mv "$tmp" $1
    mv $feature_1 $feature_2
}

function rename_f 
{
    ls_f $1
    read -p "Enter the ID of the feature that you wish to rename: " feature_id
    feature_name=$(jq -r '.features[] | select( .id == '$feature_id' )."name"' $1)
    read -p "Renaming $feature_name to :" new_feature_name

    feature_location=$(jq -r '.features[] | select( .id == '$feature_id' )."src location"' $1)
    feature_new_location=$(dirname $feature_location)/$new_feature_name
    echo "moving $feature_location to $feature_new_location..."
    mv $feature_location $feature_new_location

    tmp=$(mktemp)
    jq -c '(.features[] | select(.id=='$feature_id')| ."src location") |= "'$feature_new_location'"' $1 > "$tmp" && mv "$tmp" $1
    jq -c '(.features[] | select(.id=='$feature_id')| ."name") |= "'$new_feature_name'"' $1 > "$tmp" && mv "$tmp" $1
}

function rm_f 
{
    fileloc="${2%%.*}"
    ls_f $1
    read -p "Enter the ID of the feature that you wish to remove: " feature_id
    feature_index=$(jq '.features | map(.id == '$feature_id') | index(true)' $1)
    feature_name=$(jq '.features[] | select( .id == '$feature_id' )."name"' $1)
    feature_location=$(jq '.features[] | select( .id == '$feature_id' )."src location"' $1)
    read -p "Are you sure you wish to remove $feature_name and its contents: " yn
    

    tmp=$(mktemp)
    jq 'del(.features[] | select(.id == '$feature_id'))' $1 > "$tmp" && mv "$tmp" $1
    echo "Removing $feature_location..."
    echo $1
    rm -rf $fileloc/$feature_location
}

if [[ $1 == "add_f" ]]; then add_f $2 $3
elif  [[ $1 == "ls_f" ]]; then ls_f $2
elif  [[ $1 == "mv_f" ]]; then mv_f $2
elif  [[ $1 == "rename_f" ]]; then rename_f $2 $3
elif  [[ $1 == "rm_f" ]]; then rm_f $2 $3
fi