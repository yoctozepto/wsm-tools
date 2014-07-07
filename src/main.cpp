#include <stdio.h>

extern int parse_dct(FILE*);
extern FILE *yyin;
extern int parse_wsm(void);

int main(int argc, char **argv) {
    if (argc != 3) {
        printf("Call me with 2 parameters!\n");
        return 0x10;
    }

    FILE *dct = fopen(argv[1], "r");
    if (!dct) {
        printf("I can't read that DCT file!\n");
        return 0x11;
    }

    yyin = fopen(argv[2], "r");
    if (!yyin) {
        printf("I can't read that WSM file!\n");
        return 0x12;
    }

    if (parse_dct(dct)) {
        printf("I can't parse that DCT file! It is in invalid format.\n");
        return 0x13;
    }
    fclose(dct);

    return parse_wsm();
}
