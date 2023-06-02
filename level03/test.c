#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int arc, char **arv){

    if (arv[2]-arv[1] > 0x15){
        printf("Good job bro\n");
    }
    else{
        printf("Try again bro\n");
    }
    return 0;
}