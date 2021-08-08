%code {

#include <stdio.h>
#include <string.h>
extern int yylex (void);
void yyerror (const char *s);
struct winner;
int year;
char gender[5];

}

%code requires {
    struct winner {
         int wincount;  /* -1  means irrelevant */
         char name[30];
    };
}

%union {

   struct winner _winner;
   char gender[5];
   int year;
}

%token TITLE NAME COMMA WIMBLEDON AUSTRALIAN_OPEN HYPHEN GENDER
%token <year> NUM
%token <gender> PLAYER_GENDER
%token <_winner.name> PLAYER_NAME

%type <year> optional_wimbledon optional_australian_open  list_of_years year_spec
%type <_winner> list_of_players player

%error-verbose

%%
input: TITLE list_of_players{
   if ($2.wincount == -1)
        printf ("no most win for anyone\n");
   else
       printf(" Player with most wins at Wimbledon: %s (%d wins)\n",$2.name, $2.wincount);
};

list_of_players: list_of_players player{
                                 if($1.wincount > $2.wincount)
                                    {
                                   $$=$1;
                                    }
                                 else
                                 {
                                   $$=$2;
                                 }

                                       };
list_of_players: %empty{
                        strcpy($$.name,"");
                        $$.wincount = -1;
                       };

player: NAME PLAYER_NAME GENDER PLAYER_GENDER optional_wimbledon optional_australian_open{
  if(strcmp($4,"Man")==0){
    strcpy($$.name,$2);
    $$.wincount=$5;
  }
  else{
    strcpy($$.name,"");
    $$.wincount = -1;
  }
} ;

optional_wimbledon: WIMBLEDON list_of_years{$$=$2;}
                              |%empty{$$=-1;};


optional_australian_open: AUSTRALIAN_OPEN list_of_years{$$=$2;}
                          | %empty{$$=-1;};

list_of_years: list_of_years COMMA year_spec{$$=($1+$3);};
list_of_years: year_spec{$$=$1;};
year_spec: NUM{$$=1;}
           | NUM HYPHEN NUM{$$=($3-$1)+1;} ;

%%

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

  yyparse ();

  fclose (yyin);
  return 0;
}

void yyerror (const char *s)
{
printf("error with %s\n",s);
}
