#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tennis.h"

extern enum token yylex (void);
int lookahead;

struct winner;
int year;
char gender[5];

struct winner list_of_players() ;
struct winner player();
void input();
int wimbledon();
int australian_open();
int list_of_years();
int year_spec();


void match(int expectedToken)
{
    if (lookahead == expectedToken)
        lookahead = yylex();
    else {
        printf("Wrong token\n");
        exit(1);
    }
}

void parse()
{
    lookahead = yylex();
    input();
    if (lookahead != 0) {  // 0 means EOF
        printf("Excepted end of file!\n");
        exit(1);
    }
}

void input()
{
    match(TITLE);
    struct winner w = list_of_players();
    if (w.wincount == -1)
        printf ("no relevant player\n");
    else
        printf (" Player with most wins at Wimbledon: %s (%d wins)\n",
                w.name, w.wincount);
}

struct winner list_of_players()
{
    struct winner _winner = {-1," "};
    while (lookahead == NAME) {
        struct winner w = player();
        if(w.wincount>_winner.wincount){
          _winner=w;
        }

    }
    return _winner;
}

struct winner player()
{
    match(NAME);
    char name[30];
    strcpy(name,lexicalValue._winner.name);
    match(PLAYER_NAME);
    match(GENDER);
    char gender[5];
    strcpy(gender,lexicalValue.gender);
    match(PLAYER_GENDER);
    int numOfWins;
    if(lookahead==WIMBLEDON){
      numOfWins=wimbledon();
    }
    else
      numOfWins=-1;
    if(lookahead==AUSTRALIAN_OPEN){
      australian_open();
    }
    struct winner player;
    strcpy(player.name,name);
    if (strcmp(gender,"Man")==0)
        player.wincount=numOfWins;
    else
        player.wincount=-1;
    return player;
}

int wimbledon()
{
    match(WIMBLEDON);
    int numOfWins=list_of_years();
    return numOfWins;
}

int australian_open()
{
    match(AUSTRALIAN_OPEN);
    int numOfWins=list_of_years();
    return numOfWins;
}

int list_of_years()
{
  int num=0;
  while (lookahead == NUM) {
    num+=year_spec();
    if(lookahead==COMMA){
      match(COMMA);
    }
  }
    return num;
}

int year_spec()
{
  int num=0;
  num=lexicalValue.year;
  match(NUM);

  if(lookahead==HYPHEN){
    match(HYPHEN);
    num=lexicalValue.year-num+1;
    match(NUM);
  }
  else
    num=1;
  return num;
}

int main (int argc, char **argv)
{
    extern FILE *yyin;
    if (argc != 2) {
       fprintf (stderr, "Usage: %s <input-file-name>\n", argv[0]);
	   return 1;
    }
    yyin = fopen (argv [1], "r");
    if (yyin == NULL) {
       fprintf (stderr, "failed to open %s\n", argv[1]);
	   return 2;
    }
    parse();
    fclose (yyin);
    return 0;
}
