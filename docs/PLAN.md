

setup()


log()
  climb up the dirs and find .config
  if .config found
    
<<<<<<< HEAD

=======
help()
  
>>>>>>> 695fe02 (uploading all before my computer gives up)

init()
  ask project name
  ask git url
  check if project config exist in parrent folders
  if not
    then create folders [src, docs, bin, test, lib]
    create folder [main] in [src]
    init git
    ask git url
    git remote add
    log folder structure to configfile
  if true
    exit with msg
 
add feature()
  climb branch and search for .configfile
  check if feature exist in config
  if not
    add folder to [src, lib] name=input()
    add new feature to configfile save info[name, location]
    git branch new feature
  if true 
    exit with msg

