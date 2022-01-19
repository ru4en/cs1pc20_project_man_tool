#!/bin/bash

#defining colours
off='\033[0m'
b_green="\033[1;32m"
b_red="\033[1;31m"
b_blue='\033[44m'

is_successful () {
    if [ $1 -eq 0 ]; then
    printf "$b_green successful $off \n" # Print successful in green if successful.
    else
    printf "$b_red failed $off \n" # Print failed in red if successful.
    fi
}

install_pm () {
    if [ "$EUID" -ne 0 ] # Needs root privelages so setup exits if not ran as root.
    then printf "Please run as root.\n"
    exit
    fi

    # Desined and tested to run on debian based systems so 
    printf "$b_blue Checking if system is surported... $off"
    which apt >/dev/null 2>&1
    is_successful $?
    if [ $? -ne 0 ]; then exit; fi

    # install dependensies 
    printf "$b_blue Installing jq, gcc... $off"
    apt install jq build-essential &> /dev/null
    is_successful $?

    # seting up directory for pm
    printf "$b_blue Seting up directory... $off"
    mkdir /lib/pm &> /dev/null
    is_successful $?

    # compile main.c using gcc
    printf "$b_blue Compiling C code... $off"
    gcc -o bin/pm src/main.c -O2 &> /dev/null
    is_successful $?

    # copy binary to root bin so pm can be exicuted to run the program from anyware
    printf "$b_blue Copying binaries... $off"
    cp bin/pm /usr/bin/pm &> /dev/null
    is_successful $?

    # copy the bash "librarie" files to root lib
    printf "$b_blue Copying Libraries... $off"
    cp src/init.sh /lib/pm/init &> /dev/null
    cp src/feature.sh /lib/pm/feature &> /dev/null
    is_successful $?

    # note for user
    printf "\n\n Type 'pm' to see what it can do.\n pm can be removed using './setup.sh -r' \n\n"
}

remove_pm () { # uninstall function for convineance
    printf "$b_blue Removing pm tool... $off"
    rm -rf /usr/bin/pm /lib/pm
    is_successful $?
}

# logic for arguments 
if  [[ -z "$1" ]]; then install_pm
elif  [[ $1 -eq "-r" ]]; then remove_pm
fi