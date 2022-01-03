

char* search_parent(char* find) // this function searches for .config files in the parrent folders
{
    DIR *dir = opendir("."); 
    char buff[FILENAME_MAX];
 
    char *pwd = getenv("PWD"); // get an array of parrent folders
    char* dirs = strtok(pwd, "/");

    char apnd[65];
    char apnds[650] = "";
    char config_file[650];
    char *config_file2 = malloc(sizeof(char) * 256); 


    while (dirs != NULL) {
        sprintf(apnd, "/%s", dirs);
        sprintf(apnds, "%s%s", apnds, apnd);
        sprintf(config_file, "%s/%s", apnds, find);

        if( access(config_file, F_OK ) == 0 ) {
          stpcpy(config_file2, config_file);
          return  config_file2;
        }
        dirs = strtok(NULL, "/");
    }
    return "Not Found";
}