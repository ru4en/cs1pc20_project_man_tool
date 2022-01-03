#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <dirent.h>

void void_it() {} // chucks unwanted outputs to the emptness of void

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
    sprintf(apnd, "/%s", dirs);
    sprintf(apnds, "%s%s", apnds, apnd);
    sprintf(config_file, "%s/%s", apnds, find);

    if (access(config_file, F_OK) == 0) {
      stpcpy(config_file2, config_file);
      return config_file2;
    }
    dirs = strtok(NULL, "/");
  }
  return "Not Found";
}

char* help()
{
  return "\
        usage: pm [-v] [-h]\n\
                  <command> [<args>]\n\
\n\
These are common pm commands used in various situations:\n\n\
\tinit\t\t\tCreate an genaric layout for programing projects.\n\
\tfeature [<args>]\tManage Featues (Check bellow for functanalitys)\n\
\tmake\t\t\trun makefile from anyware in the project diroctory\n\
\tpg\t\t\tproduc\n\
\n\
Options that can be called to intaract with features: pm feature [<args>]\n\n\
\tadd\tadd a new feature\n\
\tmv\tMove or rename a feature\n\
\trm\tRemove a feature \n";
}

int main(int argc, char ** argv) // main function takes in arguments
{
  char* ERROR = "\033[1;31m ERROR:\033[0m";
  char * df_location = search_parent(".pmd"); // check if .pmd exists within the parrent folders (if they do it means that a project was alredy iniciated and the program should exit)

  if (argv[1] == NULL)
  {
    printf(help());
    return 1;
  }
  
  else if (strcmp(argv[1], "init") == 0) // if any of the arguments are "init" do ...
  {
    if (strcmp(df_location, "Not Found") == 0) { // this is done to prevent problems with git and loging to config in genral
      int init_status = system("bash /lib/pm/init init");
      return 0;
    } else // exit the program and print out an error msg
    {
      printf("%s Existing project found in parrent diroctory %s.\n", ERROR, df_location);
      return 1;
    }
  } else if (strcmp(argv[1], "feature") == 0) {

    if (strcmp(df_location, "Not Found") == 0) 
    {
      printf("%s Project dotfile not detected, please try using init to iniciate new project...\n\n%s", ERROR, help());
      return 1;
    }

    if (argc <= 3)
    {
      printf("%s Feature name not stated... \n\n %s", ERROR , help());
      return 0;
    }

    if (argv[2] == NULL)
    {
      printf("%s Not enough arguments passed for features, Choose from add, mv and rm... \n\n %s", ERROR, help());
    } else if (strcmp(argv[2], "add") == 0) {
      char add_f[256];
      sprintf(add_f, "bash /lib/pm/feature add_f %s %s", argv[3], df_location);
      int init_status = system(add_f);
    } else if (strcmp(argv[2], "mv") == 0) {
      printf("move Feature: %s\n", argv[3]);
    } else {
      printf("%s Unknowned option '%s' for feature. add, mv and rm are the only options you can use... \n\n %s", ERROR, argv[2], help());
    } 

  } else if (argv[1][0] == '-') // test argumet only to be used during devolopement. REMOVE BEFORE SUBMITION
  {
    switch (argv[1][1]) {
    case ('h'):
      printf(help());
      return 0;

    case ('v'):
      printf("pm version 0.2 Alfa\n");
      return 0;

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
