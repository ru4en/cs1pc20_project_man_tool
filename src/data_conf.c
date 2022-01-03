#include <stdio.h>


struct project_info {
    char title[256];
    char author[256];
    char git_url[256];
    char location[256];
}

<<<<<<< HEAD
int write_to_conf()
=======
int write_to_conf(project_info.title)
>>>>>>> 695fe02 (uploading all before my computer gives up)
{
    config = fopen(".config", "w");
    fprintf(config, "[Info]\n\t Project Name:\t %s\n\t Author(s):\t %s\n\t Git Repo:\t %s\n\t File Root:\t %s\n",proj_name,getenv("USERPROFILE"), git_url);
    while ((files = readdir(dir)) != NULL)
    fprintf(config, "[Folder tree] %s\n[Feature list]\n",files->d_name);
    closedir(dir);

    fclose(config); 
}