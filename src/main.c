#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <dirent.h>

void void_it() {} // chucks unwanted outputs to the emptness of void

/*--------------------------------Search in parrent folder------------------------------------*/


char * search_parent(char * find) // this function searches for .pmd files in the parrent folders
{
  DIR * dir = opendir(".");
  char buff[FILENAME_MAX];

  char * pwd = getenv("PWD"); // get an array of parrent folders
  char * dirs = strtok(pwd, "/");

  char apnd[65];
  char apnds[650] = "";
  char config_file[650];
  char * config_file2 = malloc(sizeof(char) * 256);

  while (dirs != NULL) {
    sprintf(apnd, "/%s", dirs); // string formating 
    sprintf(apnds, "%s%s", apnds, apnd);
    sprintf(config_file, "%s/%s", apnds, find);

    if (access(config_file, F_OK) == 0) { // check if file exists
      stpcpy(config_file2, config_file);
      return config_file2;
    }
    dirs = strtok(NULL, "/");
  }
  return "Not Found"; // if file not found return "Not Found"
}


/*--------------------------------Help------------------------------------*/

char* help() // Help function to print out what the program can do
{
  return "\
        usage: pm [-v] [-h]\n\
                  <command> [<args>]\n\
\n\
These are common pm commands used in various situations:\n\n\
\tinit\t\t\tCreate an generic layout for programing projects.\n\
\tfeature [<args>]\tManage Featues (Check bellow for functionality)\n\
\ttest [<args>]\tManage Tests (Check bellow for functionality)\n\
\tmake\t\t\trun makefile from anyware in the project directory\n\
\tmake\t\t\trun makefile from anyware in the project directory\n\
\tweb\t\t\tstart a web interface to view project details\n\
\tgantt\t\t\tGenerate gantt chart\n\
\n\
Options that can be called to interact with features tests: pm feature [<args>] or pm test [<args>] \n\n\
\tls\tlist all feature or tests\n\
\tadd\tadd a new feature or tests\n\
\tmv\tMove a feature and its contents from one folder into another\n\
\trm\tRemove a feature or tests\n";
}
/*-----------------------------Main---------------------------------------*/

int main(int argc, char ** argv) // main function takes in arguments
{
  char* ERROR = "\033[1;31m ERROR:\033[0m";
  char * df_location = search_parent(".pmd"); // check if .pmd exists within the parrent folders (if they do it means that a project was already initiated and the program should exit)

  if (argv[1] == NULL)
  {
    printf(help());
    return 1;
  }
/*--------------------------------pm init------------------------------------*/

  else if (strcmp(argv[1], "init") == 0) // if any of the arguments are "init" do ...
  {
    if (strcmp(df_location, "Not Found") == 0) { // this is done to prevent problems with git and loging to config in general
      int init_status = system("bash /lib/pm/init init");
      return 0;
    } else // exit the program and print out an error msg
    {
      printf("%s Existing project found in %s.\n", ERROR, df_location); // print error msg if project already exists
      return 1;
    }
/*-----------------------------pm feature < xxxxx >-------------------------------------*/
  } else if ((strcmp(argv[1], "feature") == 0) & (argv[2] != NULL)) { // if user choses feature and the next argv is not empty run the folling if statements 

    if (strcmp(df_location, "Not Found") == 0) // catch if features run without inition.
    {
      printf("%s Project dotfile not detected, please try using init to initiate new project...\n\n%s", ERROR, help());
      return 1;
    }
    if (strcmp(argv[2], "ls") == 0) { // list features 
      char ls_f[256];
      sprintf(ls_f, "bash /lib/pm/feature ls_f %s", df_location); // string formating for bash command
      int init_status = system(ls_f); // run ^^ in terminal 
      return 0;
    } else if ((strcmp(argv[2], "add") == 0) & (argv[3] != NULL)) { // add new feature
      char add_f[256];
      sprintf(add_f, "bash /lib/pm/feature add_f %s %s", argv[3], df_location);
      int init_status = system(add_f);
    } else if (strcmp(argv[2], "mv") == 0) { // move feature
      char mv_f[256];
      sprintf(mv_f, "bash /lib/pm/feature mv_f %s", df_location);
      int init_status = system(mv_f);
      return 0;
    } else if (strcmp(argv[2], "rename") == 0) { // rename feature
      char rename_f[256];
      sprintf(rename_f, "bash /lib/pm/feature rename_f %s", df_location);
      int init_status = system(rename_f);
      return 0;
    }else if (strcmp(argv[2], "rm") == 0) {  // remove feature
      char rm_f[256];
      sprintf(rm_f, "bash /lib/pm/feature rm_f %s", df_location);
      int init_status = system(rm_f);
      return 0;
    } else {
      printf("%s Unknown option '%s' for feature. add, mv and rm are the only options you can use... \n\n %s", ERROR, argv[2], help());
    }
    }
    
/*-----------------------------pm test < xxxxx >-------------------------------------*/
    
    else if ((strcmp(argv[1], "test") == 0) & (argv[2] != NULL)) { // if user choses test and the next argv is not empty run the folling if statements 
    
    if (strcmp(df_location, "Not Found") == 0) // catch if test command run without inition.
    {
      printf("%s Project dotfile not detected, please try using init to initiate new project...\n\n%s", ERROR, help());
      return 1;
    }
    if (strcmp(argv[2], "ls") == 0) { // list tests 
      char ls_f[256];
      sprintf(ls_f, "bash /lib/pm/test ls %s", df_location); // string formating for bash command
      int init_status = system(ls_f); // run ^^ in terminal 
      return 0;
    } else if ((strcmp(argv[2], "add") == 0)) { // add new test
      char add_f[256];
      sprintf(add_f, "bash /lib/pm/test add %s", df_location);
      int init_status = system(add_f);
    }else if (strcmp(argv[2], "rm") == 0) {  // remove test
      char rm_f[256];
      sprintf(rm_f, "bash /lib/pm/test rm %s", df_location);
      int init_status = system(rm_f);
      return 0;
    } else {
      printf("%s Unknown option '%s' for test. ls, add or rm are the only options you can use... \n\n %s", ERROR, argv[2], help());
    }
  }

/*-----------------------------pm tree-------------------------------------*/
  else if (strcmp(argv[1], "tree") == 0) {
    char tree[256];
    sprintf(tree, "bash /lib/pm/utls tree %s", df_location);
    int init_status = system(tree);
    return 0;
  }
  
/*-----------------------------pm web-------------------------------------*/
  else if (strcmp(argv[1], "web") == 0) {
    char tree[256];
    sprintf(tree, "bash /lib/pm/utls web %s", df_location);
    int init_status = system(tree);
    return 0;
  }
/*-----------------------------user-------------------------------------*/
    else if ((strcmp(argv[1], "addusr") == 0) & (argv[2] != NULL)) {
    char adduser[256];
    sprintf(adduser, "bash /lib/pm/utls addusr %s %s",argv[2], df_location);
    int init_status = system(adduser);
    return 0;
  }
  /*-----------------------------Gantt chart-------------------------------------*/
    else if (strcmp(argv[1], "gantt") == 0) {
    char gantt[256];
    sprintf(gantt, "bash /lib/pm/utls gantt %s", df_location);
    int init_status = system(gantt);
    return 0;
  }
  
/*-----------------------------Switch for -h and -v-------------------------------------*/
  
  else if (argv[1][0] == '-') // test argument only to be used during devolvement. REMOVE BEFORE SUBMITION
  {
    switch (argv[1][1]) { // switch statements for -h and -v
    case ('h'): // -h is for help 
      printf(help());
      return 0;

    case ('v'): // -v is to check what version pm is
      printf("pm version 0.2 Alfa\n");
      return 0;
// if arg 1 is empty print help and exit VVVV
    default:
    printf(help());
      break;
    }
  }
  else {
    printf(help());
    return 1;
  }
  return 0;
}
