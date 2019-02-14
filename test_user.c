#include "types.h"
#include "user.h"

int main (int argc, char *argv[]){
   printf(1, "\n\n Herro from the user space! \n");
   setpriority(1);
   exit();
   return 0;

}
