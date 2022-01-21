#!/bin/bash
function pm_tree {
    fileloc="${1%%.*}"
    tmp=$(mktemp)

    tree_code=$(tree $fileloc --dirsfirst --noreport | iconv -f utf-8 -t us-ascii//TRANSLIT | sed -e '1d' -e 's/|/+/' -e 's/|/+/' -e 's/--/_/' -e 's/ //g' -e 's/_/ /g' -e 's/^/+/' )
    echo "
    @startwbs
    + $(basename $fileloc)
    $tree_code
    @endwbs
    " > $fileloc/docs/treeuml.txt
    treeuml_loc=$fileloc"docs/"
    echo $treeuml_loc
    plantuml $fileloc/docs/treeuml.txt --overwrite -o $treeuml_loc
    echo "Created tree diagram at "$treeuml_loc
}

function pm_web {
    pm_tree $1
    fileloc="${1%%.*}"
    treeuml=$fileloc/docs/treeuml.png
    ganttuml=$fileloc/docs/SDLCgantt.png
    tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
    echo $tmp_dir
    cp $treeuml $tmp_dir/treeuml.png
    cp $ganttuml $tmp_dir/SDLCgantt.png
    ls $tmp_dir
    python3 /lib/pm/webapp.py $1 $tmp_dir
    
    rm -rf $tmp_dir
}

function pm_addusr {
    json_file=$(jq '.users += [ "'$1'" ]' $2)
    echo "Added $1 to this project."
    echo $json_file > $2
    }

function pm_rmusr {
    json_file=$(jq '.users -= [ "'$2'" ]' $1)
}

function genarate_gantt {
    fileloc="${1%%.*}"
    gnatt_file=$fileloc"docs/SDLCgantt.txt"
    img_file=$fileloc"docs/"
    echo $gnatt_file
    while true; do
    echo "1) Waterfall Modle"
    read -p "Choose one of the following SDLC modles: " SDLC_modles

    if [[ $SDLC_modles -eq 1 ]]; then

    declare -a waterfall_phases=("Requirement Gathering and analysis"  "System Design" "Implementation" "Deployment" "Maintenance")

    echo "@startuml" > $gnatt_file
    echo "Please use YYYY-MM-DD format"
    read -p "When will/did the project start : " project_start
    if [[ $project_start == [0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ]] ; then echo "Project starts $project_start" >> $gnatt_file ; else echo "Invalid dates use YYYY-MM-DD format" && break; fi
    for phases in "${waterfall_phases[@]}"; do
        echo -e "\n---$phases Phase---"
        read -p "When will the $phases phase start : " phase_start
        read -p "When will the $phases phase end : " phase_end
        date "+%Y-%m-%d" -d "$d" > /dev/null  2>&1
        if [[ $phase_start == [0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ]] &&  [[ $phase_end == [0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ]]; then echo "valid dates"; else echo "Invalid dates" && break; fi
            read -p "$phases phase will start on $phase_start and end on $phase_end? [Yn]: " conform_phase
            case $conform_phase in
            [Yy]* ) echo "[$phases phase] starts $phase_start" >> $gnatt_file && echo "[$phases phase] ends $phase_end" >> $gnatt_file && continue;;
            [Nn]* ) break;;
            * ) echo "Please answer Yes or No using [Y/n]." && break;;
            esac
    done
    fi
    echo "@enduml" >> $gnatt_file
    plantuml $gnatt_file --overwrite -o $img_file
    echo "Gantt Chart genarated at $img_file/SDLCgantt.png"
    break;
    done
}

if [[ $1 == "tree" ]]; then pm_tree $2
elif [[ $1 == "web" ]]; then pm_web $2
elif [[ $1 == "addusr" ]]; then pm_addusr $2 $3
elif [[ $1 == "gantt" ]]; then genarate_gantt $2
fi