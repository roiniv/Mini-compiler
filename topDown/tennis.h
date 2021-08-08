#ifndef TENNIS

// yylex returns 0 when EOF is encountered
enum token {
     TITLE=1,
     NAME,
     COMMA,
     WIMBLEDON,
     AUSTRALIAN_OPEN,
     HYPHEN,
     GENDER,
     NUM,
     PLAYER_GENDER,
     PLAYER_NAME
};

char *token_name(enum token token);

struct winner {
     int wincount;  /* -1  means irrelevant */
     char name[30];
};

union _lexVal {
struct winner _winner;
char gender[5];
int year;
};

extern union _lexVal lexicalValue;
#endif
