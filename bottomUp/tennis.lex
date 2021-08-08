%{
#include "tennis.tab.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

extern int atoi (const char *);
%}

%option noyywrap


%%

\*\*([^\\"\n]|\\.)*\*\* { return TITLE;}
[0-9]{4}   {yylval.year = atoi(yytext); return NUM; }
[\n\t ]+  /* skip white space and commas */
"," {return COMMA;}
"-" {return HYPHEN;}
[ ]*\"[a-zA-Z]+[ ]*[a-zA-Z]*\"  {strtok(yytext, "\""); strcpy(yylval._winner.name , strtok(NULL, "\"")); return PLAYER_NAME; }
"<name>" {return NAME;}
"<gender>" {return GENDER;}
"<Wimbledon>" {return WIMBLEDON;}
"<Australian Open>" {return AUSTRALIAN_OPEN;}
"Woman"|"Man" {strcpy( yylval.gender, yytext); return PLAYER_GENDER; }
.          { fprintf (stderr, "unrecognized token %c\n", yytext[0]); }

%%
