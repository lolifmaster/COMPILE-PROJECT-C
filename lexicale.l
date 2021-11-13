%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "syntaxique.tab.h"
#include "ts.h"
extern yylineo;
extern Col;
extern YYSTYPE yylval;
%}
lettre [a-zA-Z]
lettreM [A-Z]
chiffre [0-9]
idf {lettreM}({lettre}|{chiffre})*
const_entier [+-]?{chiffre}+
const_reel [+-]?{chiffre}+"."{chiffre}+
const_ch [']({lettre}|{chiffre})?[']
const_str ["][^"]*["]
deb "/*"
ffin "*/"
commentaire  {deb}([^"/*"]|\n)*?{ffin}
blanc [\t]
Sl [\n]
%%
Programme       { rechercher (yytext,"Mot cle "," ",0, 1); Col = Col + yyleng; return mc_pgm;}
VAR             { rechercher (yytext,"Mot cle "," ",0, 1); Col = Col + yyleng; return mc_var;}
PROCESS         { yylval.str=strdup(yytext); rechercher (yytext,"Mot cle "," ",0, 1); Col = Col + yyleng; return mc_proc;}
ARRAY           { yylval.str=strdup(yytext); rechercher (yytext,"Mot cle "," ",0, 1); Col = Col + yyleng; return mc_array;}
LOOP            { yylval.str=strdup(yytext); rechercher (yytext,"Mot cle "," ",0, 1); Col = Col + yyleng; return mc_loop;}
READ            { rechercher (yytext,"Mot cle "," ",0, 1); Col = Col + yyleng; return mc_read;}
WRITE           { rechercher (yytext,"Mot cle "," ",0, 1); Col = Col + yyleng; return mc_write;}
WHILE           { rechercher (yytext,"Mot cle "," ",0, 1); Col = Col + yyleng; return mc_while;}
EXECUT          { rechercher (yytext,"Mot cle "," ",0, 1); Col = Col + yyleng; return mc_execut;}
IF              { rechercher (yytext,"Mot cle "," ",0, 1); Col = Col + yyleng; return mc_if;}
ELSE            { rechercher (yytext,"Mot cle "," ",0, 1); Col = Col + yyleng; return mc_else;}
END_IF          { rechercher (yytext,"Mot cle "," ",0, 1); Col = Col + yyleng; return mc_end_if;}
EG              { rechercher (yytext,"Mot cle "," ",0, 1); Col = Col + yyleng; return mc_eg;}
SUP             { rechercher (yytext,"Mot cle "," ",0, 1); Col = Col + yyleng; return mc_sup;}
SUPE            { rechercher (yytext,"Mot cle "," ",0, 1); Col = Col + yyleng; return mc_supe;}
DIFF            { rechercher (yytext,"Mot cle "," ",0, 1); Col = Col + yyleng; return mc_diff;}
INF             { rechercher (yytext,"Mot cle "," ",0, 1); Col = Col + yyleng; return mc_inf;}
INFE            { rechercher (yytext,"Mot cle "," ",0, 1); Col = Col + yyleng; return mc_infe;}
INTEGER         { yylval.str=strdup(yytext); rechercher (yytext,"Mot cle "," ",0, 1); Col = Col + yyleng; return mc_entier;}
REAL            { yylval.str=strdup(yytext); rechercher (yytext,"Mot cle "," ",0, 1); Col = Col + yyleng; return mc_reel;}
STRING          { yylval.str=strdup(yytext); rechercher (yytext,"Mot cle "," ",0, 1); Col = Col + yyleng; return mc_str;}
CHAR            { yylval.str=strdup(yytext); rechercher (yytext,"Mot cle "," ",0, 1); Col = Col + yyleng; return mc_char;}
CONST           { yylval.str=strdup(yytext); rechercher (yytext,"Mot cle "," ",0, 1); Col = Col + yyleng; return mc_const;}
"/*"            { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return commo;}
"*/"            { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return commf;}
"//"            { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return sep;}
"$"             { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return fin;}
"{"             { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return acco;}
"}"             { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return accf;}
"("             { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return paro;}
")"             { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return parf;}
"\""            { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return dcot;}
"\'"            { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return cot;}
"+"             { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return addition;}
"-"             { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return soustraction;}
"/"             { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return division;}
"*"             { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return multiple;}
"="             { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return egale;}
":="            { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return affect;}
"##"            { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return dhg;}
"::"            { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return dpt;}
"["             { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return croo;}
"]"             { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return crof;}
"|"             { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return pip;}
"@"             { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return adr;}
";"             { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return entier;}
"%"             { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return flt;}
"?"             { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return str;}
"&"             { rechercher (yytext,"Separateur",0,0, 2); Col = Col + yyleng; return chara;}
{idf} { 
        yylval.str=strdup(yytext);
        rechercher (yytext,"IDF "," ",0, 0); 
        Col = Col + yyleng; 
        if(yyleng > 10)
		printf("Erreur lexicale, ligne %d, Colone %d : %s",yylineo,Col,yytext);
       	else
                return idf;
       }
{const_reel} {
        yylval.real = atof(yytext);
        Col = Col + yyleng; 
        if(atof(yytext) > -32769. && atof(yytext) < 32769.){
                if(atof(yytext) >= 0)       
                        rechercher (yytext,"Cst reel ","Reel",atof(yytext), 0);
                else
                         rechercher ((yytext),"Cst reel ","Reel",atof(yytext), 0);
                return const_reel;
        }
        else 
                printf("Erreur lexicale, ligne %d, Colone %d : %s",yylineo,Col,yytext);
        }
{const_entier} {
        rechercher (yytext,"Cst entiere ","Entier",atof(yytext), 0); 
        yylval.entier = atoi(yytext);
        Col = Col + yyleng;
	if(atoi(yytext) > -32769 && atoi(yytext) < 32769)
                return const_entier;
        else
                printf("Erreur lexicale, ligne %d, Colone %d : %s",yylineo,Col,yytext);
}
{const_str}     { yylval.str=strdup(yytext); rechercher (yytext,"Cst str ","String",atof(yytext), 0);  Col = Col + yyleng; return const_str;}
{const_ch}      { yylval.car=strdup(yytext); rechercher (yytext,"Cst car ","Char",atof(yytext), 0);  Col = Col + yyleng; return const_ch;}
{commentaire}   {int nb=0;while(yytext[nb]!='\0'){if(yytext[nb]=='\n'){Col=1;yylineo++;}else {Col++;}nb++;}return commentaire;}
{blanc} {Col = Col + yyleng ;}  
{Sl} {yylineo++; Col = 1;}
[.] {printf("Erreur lexicale, ligne %d, Colone %d : %s",yylineo,Col,yytext);}
%%