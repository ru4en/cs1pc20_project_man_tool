# Programming in C/C++ Project Manager

Pm is a project management tool used to set up and manage programing projects.

some of the features of pm are:

- [x] Setting up a basic file structure for projects
- [x] Abort if requested project/feature name already exists in parent folder
- [x] Initialize git repository
- [x] Feature management ( add, ls, mv, rm, rename)
- [x] Generate tree diagram using Plantuml
- [ ] Time/workload estimate information for project/features
- [ ] Generate Gantt chart for features
- [ ] Simple web application interface
- [ ] Multi-user Support

## Installation

Clone the repository from gitlab.
`git clone https://csgitlab.reading.ac.uk/il021591/cs1pc20_pm.git`

cd into folder and run the installer
`cd /cs1pc20_pm`
`./setup.sh`

## Usage

Run `pm` to see available options.


usage: pm [ -v ] [ -h ]
< command > [ < args > ]

These are common pm commands used in various situations:

        init                    Create an generic layout for programing projects.
        feature [ < args > ]    Manage Features (Check bellow for functionality)
        make                    run makefile from anywhere in the project directory

Options that can be called to interact with features: pm feature [ < args > ]

        add     add a new feature
        mv      Move or rename a feature
        rm      Remove a feature 

## Remove pm

`./setup.sh -i`
