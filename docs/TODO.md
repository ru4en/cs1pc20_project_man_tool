# TODO

## Must (up to 10% for each top level feature)

[x] Be able to create basic file structure for project
[x] Abort if requested project/feature name already exists under 'root' folder.  Here 'root' does not mean the / root of the file system, but the folder from which the program  is run.
    [x] Requires checking existing file system for matching name
    [x] Requires using branching (if) to exit program if necessary
[x] Initialise git repository
    [x] Should set up CSGitLab project etc.
[x] Initialise git repository
    [x] Should set up CSGitLab project etc.
[x] Feature management
    [x] Must implement a method of having a shorthand code for feature e.g. F1, F2.1..., stored in a file.
    [x] Must implement lookup to facilitate getting path from shorthand code
    [x] Should include setting up git branch as appropriate

## Should (up to 10% for each top level feature)

[ ] Include mechanism for renaming features (subtrees)
[ ] Include mechanism for moving feature to new location in tree (folder hierarchy)
[ ] Output tree diagram - PBS or WBS (svg, using plantuml)
    [ ] Requires tree walk (iterative or recursive)
    [ ] Must exclude folders that start with a '.'
    [ ] Should use the plantuml tool
    [ ] Could implement from scratch (much harder, more marks)
[ ] Time/workload estimate information stored in files in subfolders
    [ ] Should have mechanisms for adding these from the program not just editing the files
    [ ] Should include subtrees costs in parent tree total
[ ] Time/workload added to output diagram
    [ ] Could also produce Gantt chart (using plantuml)


## Could (up to 10% for each top level feature)

[ ] Output diagram includes links (when used in browser, for example)
    [ ] Should use plantuml to do this
[ ] Dependencies information across tree branches
    [ ] Must identify relevant other paths in tree to do this

## Elite challenges ("Won't do" in MoSCoW terms) (up to 20% for each top level feature)

[ ] Guided work breakdown wizard (Slightly advanced, would require interactive questions/answer handling)
    [ ] Needs a number of sub-features, such as minimum time allocation threshold, user input parsing
[ ] Multi-user (Advanced, would require some form of permissions model)
    [ ] may be best done using a traditional SQL database, but can use flat files.  Complex task.
[ ] Available as web application (Advanced, probably easiest creating a simple embedded server)
    [ ] sample code for simple communications between applications will be covered
[ ] GOAP recommendation of suitable pathway (Advanced, can use existing GOAP library, however)
    [ ] GOAP uses a 'heap' data structure