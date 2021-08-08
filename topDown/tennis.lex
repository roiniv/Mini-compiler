%{
#include "tennis.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

extern int atoi (const char *);
union _lexVal lexicalValue;
%}
%option noyywrap

%%

\*\*([^\\"\n]|\\.)*\*\* { return TITLE;}
[0-9]{4}   {lexicalValue.year = atoi(yytext); return NUM; }
[\n\t ]+  /* skip white space and commas */
"," {return COMMA;}
"-" {return HYPHEN;}
[ ]*\"[a-zA-Z]+[ ]*[a-zA-Z]*\"  {strtok(yytext, "\""); strcpy(lexicalValue._winner.name , strtok(NULL, "\"")); return PLAYER_NAME; }
"<name>" {return NAME;}
"<gender>" {return GENDER;}
"<Wimbledon>" {return WIMBLEDON;}
"<Australian Open>" {return AUSTRALIAN_OPEN;}
"Woman"|"Man" {strcpy(lexicalValue.gender, yytext); return PLAYER_GENDER; }
.          { fprintf (stderr, "unrecognized token %c\n", yytext[0]); }

%%
