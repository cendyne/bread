#include <stdio.h>
int main() {
    int i = 0;
    while(++i) {
        if (i%15 == 0) {
            printf("Bread Baguette\n");
        }
        else if ((i%3) == 0) {
            printf("Bread\n");
        }
        else if ((i%5) == 0) {
            printf("Baguette\n");
        }
        else {
            printf("Mow\n", i);
        }
    }
    return 0;
}