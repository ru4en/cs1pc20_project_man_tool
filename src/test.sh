#!/bin/bash
ERROR="\033[1;31m ERROR:\033[0m"
WARNNING="\033[1;33m WARRNING:\033[0m"
DEBUG="\033[0;102m \033[1;30m DEBUG:\033[0m"

function add_t
{
    fileloc="${1%%.*}"
    
    t_id=$(jq '.tests | length' $1)
    let "t_id = $t_id + 1"

    read -p "Whats the Objective of this test : "  test_objective
    read -p "Result of the test (leave expty if not tested) : "  test_result

    if [ -z "$test_result" ]
    then
    test_result="NULL"
    fi

    while true; do
    read -p "Did the test pass, fail or is untestested [P, F, U] : "  pass_fail
    case $pass_fail in
    [Pp]* ) pass_fail="PASS" ; break;;
    [Ff]* ) pass_fail="FAIL" ; break;;
    [Uu]* ) pass_fail="UNTESTED" ; break;;
    * ) echo "Please choose from pass, fail or is untestested [P, F, U] .";;
    esac
    done
    
    json_file=$(jq '.tests += [
    {
        "id": '$t_id',
        "objective": "'$test_objective'",
        "results": ["'$test_result'"],
        "passed_failed": "'$pass_fail'"
    }
    ]' $1)

    echo -e $DEBUG $json_file
    echo $json_file > $1
    
    echo "Saved test to log."
}

function ls_t
{
    echo -e "\n\033[1;34mID\\t\\tResult\\t\\t\\tObjective\033[m"
    test_count=$(expr $(jq '.tests | length' $1) - 1)
    for i in $(seq 0 $test_count); do
    echo -e $(jq -r '.tests['$i'] | "\(."id")\t\\t\\t\(."passed_failed")\t\\t\\t\\t\(."objective")"' $1)
    done
}

function rm_t 
{
    fileloc="${2%%.*}"
    ls_t $1
    read -p "Enter the ID of the test that you wish to remove: " test_id
    test_index=$(jq '.tests | map(.id == '$test_id') | index(true)' $1)
    test_name=$(jq '.tests[] | select( .id == '$test_id' )."name"' $1)
    test_location=$(jq '.tests[] | select( .id == '$test_id' )."src_location"' $1)
    read -p "Are you sure you wish to remove $test_name and its contents: " yn
    

    tmp=$(mktemp)
    jq 'del(.tests[] | select(.id == '$test_id'))' $1 > "$tmp" && mv "$tmp" $1
}

if [[ $1 == "add" ]]; then add_t $2
elif [[ $1 == "ls" ]]; then ls_t $2
elif [[ $1 == "rm" ]]; then rm_t $2
fi