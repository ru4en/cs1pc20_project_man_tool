function help
{
    printf "
usage: pm [--version] [--help]
           <command> [<args>]

These are common pm commands used in various situations:
   init              Create an genaric layout for programing projects.
   feature [<args>]  Manage Featues (Check bellow for functanalitys)
   make              run makefile from anyware in the project diroctory
   pg                produc

feature
   add               add a new feature
   mv                Move or rename a feature
   rm                Remove a feature
"
}
function version
{
    printf "pm version 0.2 Alfa"
}