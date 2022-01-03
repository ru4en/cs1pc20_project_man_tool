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


    cat .pmd | jq '.features |= . + [                                                                                                                                                                         98% █ ─╯
    {
        "name": "'$f_name'",
        "short hand": "'$short_h'",
        "parrent": "'${PWD%/*} | rev | cut -d'/' -f-1 | rev'",
        "summery": "'$feature_sum"
        }
    ]'

    echo $all_projs
    mkdir $fileloc/src/$1
    touch $fileloc/docs/$1.md

    echo "Adding $f_name to $fileloc"
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