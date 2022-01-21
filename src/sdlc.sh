#!/bin/bash

function genarate_gant {
    file="SDLC.txt"
    while true; do
    echo "1) Waterfall Modle"
    read -p "Choose one of the following SDLC modles: " SDLC_modles

    if [[ $SDLC_modles -eq 1 ]]; then

    declare -a waterfall_phases=("Requirement Gathering and analysis"  "System Design" "Implementation" "Deployment" "Maintenance")

    echo "@startuml" > $file
    echo "Please use YYYY-MM-DD format"
    read -p "When will/did the project start : " project_start
    if [[ $project_start == [0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ]] ; then echo "Project starts $project_start" >> $file ; else echo "Invalid dates use YYYY-MM-DD format" && break; fi
    for phases in "${waterfall_phases[@]}"; do
        echo -e "\n---$phases Phase---"
        read -p "When will the $phases phase start : " phase_start
        read -p "When will the $phases phase end : " phase_end
        date "+%Y-%m-%d" -d "$d" > /dev/null  2>&1
        if [[ $phase_start == [0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ]] &&  [[ $phase_end == [0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ]]; then echo "valid dates"; else echo "Invalid dates" && break; fi
            read -p "$phases phase will start on $phase_start and end on $phase_end? [Yn]: " conform_phase
            case $conform_phase in
            [Yy]* ) echo "[$phases phase] starts $phase_start" >> $file && echo "[$phases phase] ends $phase_end" >> $file && continue;;
            [Nn]* ) break;;
            * ) echo "Please answer Yes or No using [Y/n]." && break;;
            esac
    done
    fi
    echo "@enduml" >> $file
    cat $file
    break;
    done
}
genarate_gant
