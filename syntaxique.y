%{
        int yylineo = 1;
        int Col = 1 ;
        int yylex();
        char type[20];
        int aaa;
        char saveName[20] , var[20];
        int taille = 0 , op = 0 , val , t;
        float val2 ;
%}
%union{
  float real;
  char* str;
  int entier;
  char car;
}
%token mc_pgm mc_var <str> mc_proc <str> mc_array <str> mc_loop mc_read mc_write mc_while mc_execut mc_if mc_else mc_end_if mc_eg mc_sup mc_supe mc_inf mc_infe mc_const 

%token commo commf sep fin acco accf paro parf dcot cot dpt <str> mc_entier <str> mc_reel <str> mc_str <str> mc_char addition soustraction division multiple egale affect dhg <str> idf <entier> const_entier <real> const_reel <str> const_str <car> const_ch crof croo pip mc_diff adr entier flt str chara phrase commentaire

%left mc_sup mc_supe mc_eg mc_diff mc_infe mc_inf

%left addition soustraction

%left multiple division

%start S

%%

S: LIST_BIB mc_pgm idf acco DECLARATION PGM accf {printf("programme syntaxiquement correcte \n"); YYACCEPT;}
;

COMMENTAIRE: commentaire
;

LIST_BIB: dhg BIB fin LIST_BIB
        |
;

BIB:  mc_array{
        if(doubleDeclarationBiblio($1) == -1)
          printf("Erreur semantique a la ligne %d a la colonne %d : double declaration des bibliotheque \n",yylineo,Col);
        else
          insert_biblio($1);
    }
    | mc_proc{
        if(doubleDeclarationBiblio($1) == -1)
          printf("Erreur semantique a la ligne %d a la colonne %d : double declaration des bibliotheque \n",yylineo,Col);
        else
          insert_biblio($1);
    }
    | mc_loop{
        if(doubleDeclarationBiblio($1) == -1)
          printf("Erreur semantique a la ligne %d a la colonne %d : double declaration des bibliotheque \n",yylineo,Col);
        else
          insert_biblio($1);
    }
;

PGM: AFFECTATION PGM
   | BOUCLE PGM
   | RW PGM
   | CONDITION_IF PGM
   | COMMENTAIRE PGM
   |
;

DECLARATION: mc_var DEC mc_const DEC_CST
           | mc_const DEC_CST mc_var DEC
           | mc_var DEC
           | mc_const DEC_CST
           |
;

DEC_CST: TYPE dpt LIST_DEC_CONST fin DEC_CST
       |
;

LIST_DEC_CONST: idf egale CONSTANTE sep LIST_DEC_CONST{
                        if(doubleDeclarationCste($1) == -1)
                          printf("Erreur semantique a la ligne %d a la colonne %d : double declaration constante \n",yylineo,Col);
                        else{
                              insert_cste($1);
                              if(compatibiliteTypeCst($1,aaa) == -1)
                                printf("Erreur semantique a la ligne %d a la colonne %d : incompatibilite de type de la variable dans affectation \n",yylineo,Col);
                }
             }
              | idf egale CONSTANTE{
                        if(doubleDeclarationCste($1) == -1)
                          printf("Erreur semantique a la ligne %d a la colonne %d : double declaration constante \n",yylineo,Col);
                        else{
                            insert_cste($1);
                            if(compatibiliteTypeCst($1,aaa) == -1)
                              printf("Erreur semantique a la ligne %d a la colonne %d : incompatibilite de type de la variable dans affectation \n",yylineo,Col);}
              }
;

DEC: TYPE dpt LIST_DEC fin DEC
   |
;

LIST_DEC: idf sep LIST_DEC{
        if(doubleDeclarationVar($1) == -1)
          printf("Erreur semantique a la ligne %d a la colonne %d : double declaration de la variable \n",yylineo,Col);
        else
          insertIdfVar($1,type);
        }
        | idf{
                if(doubleDeclarationVar($1) == -1)
                  printf("Erreur semantique a la ligne %d a la colonne %d : double declaration de la variable \n",yylineo,Col);
                else
                  insertIdfVar($1,type);
        }
        | idf affect CONSTANTE sep LIST_DEC{
                if(doubleDeclarationVar($1) == -1)
                  printf("Erreur semantique a la ligne %d a la colonne %d : double declaration de la variable \n",yylineo,Col);
                else{
                    insertIdfVar($1,type);
                    if(compatibiliteTypeVar($1,aaa) == -1)
                      printf("Erreur semantique a la ligne %d a la colonne %d : incompatibilite de type de la variable dans affectation \n",yylineo,Col);}
        }
        | idf affect CONSTANTE{
                if(doubleDeclarationVar($1) == -1)
                  printf("Erreur semantique a la ligne %d a la colonne %d : double declaration de la variable \n",yylineo,Col);
                else{
                    insertIdfVar($1,type);
                    if(compatibiliteTypeVar($1,aaa) == -1)
                      printf("Erreur semantique a la ligne %d a la colonne %d : incompatibilite de type de la variable dans affectation \n",yylineo,Col);}
        }
        | idf croo const_entier crof sep LIST_DEC{
                if(tester_biblio_dec("ARRAY") == -1)
                        printf("Erreur semantique a la ligne %d a la colonne %d : la bibliotheque ARRAY n'est pas declarer \n",yylineo,Col);
                else{
                  if(doubleDeclaration($1) == -1)
                    printf("Erreur semantique a la ligne %d a la colonne %d : double declaration tableau \n",yylineo,Col);
                  else{
                    insertIdfTab($1,$3,type);
                    if(tester_tab($3) == -1)
                      printf("Erreur semantique a la ligne %d a la colonne %d : la taille de tableau ne doit pas etre negative \n",yylineo,Col);
                  }
                }
        }
        | idf croo const_entier crof{
                 if(tester_biblio_dec("ARRAY") == -1)
                        printf("Erreur semantique a la ligne %d a la colonne %d : la bibliotheque ARRAY n'est pas declarer \n",yylineo,Col);
                else{
                  if(doubleDeclaration($1) == -1)
                    printf("Erreur semantique a la ligne %d a la colonne %d : double declaration tableau \n",yylineo,Col);
                  else{
                    insertIdfTab($1,$3,type);
                    if(tester_tab($3) == -1)
                      printf("Erreur semantique a la ligne %d a la colonne %d : la taille de tableau ne doit pas etre negative \n",yylineo,Col);
                  }
                }
        }
;

TYPE: mc_entier{
                strcpy(type,$1);
        }
    | mc_reel{
                strcpy(type,$1);
        }
    | mc_char{
                strcpy(type,$1);
        }
    | mc_str{
                strcpy(type,$1);
        }
;

AFFECTATION: idf affect EXP fin{
          strcpy(saveName,$1);
          if(rechercher_idf_cste($1) == 0 && rechercher_idf_var($1) == 0){
            printf("Erreur semantique a la ligne %d a la colonne %d : une variable n'est pas declarer \n",yylineo,Col);}
          else{
            if(rechercher_idf_cste($1) == -1)
              printf("Erreur semantique a la ligne %d a la colonne %d : une constante ne change pas \n",yylineo,Col);
            }
        }
           | idf croo const_entier crof affect EXP fin{
                strcpy(saveName,$1);
                if(rechercher_idf_tab($1,$3) == 1)
                  printf("Erreur semantique a la ligne %d a la colonne %d : indice de tableau doit etre inferieur a la taille maximale \n",yylineo,Col);
                else{
                  if(rechercher_idf_tab($1,$3) == 0)
                    printf("Erreur semantique a la ligne %d a la colonne %d : un tableau n'est pas declarer \n",yylineo,Col);
                }
           }
;

EXP: LIST_IIDF OPERATEUR EXP{
        if(tester_biblio_dec("PROCESS") == -1)
          printf("Erreur semantique a la ligne %d a la colonne %d : la bibliotheque PROCESS n'est pas declarer \n",yylineo,Col);
        else{
            if(t == 0)
            {
                      if(op == 3){
                        if(val == 0)
                          printf("Erreur semantique a la ligne %d a la colonne %d : division par zero \n",yylineo,Col);
                      }
                      else{
                          if(compatibiliteTypeVar(saveName,aaa) == -1)
                            printf("Erreur semantique a la ligne %d a la colonne %d : incompatibilite de type de la variable dans affectation \n",yylineo,Col);}
                                  }
            if(t == 1){
                if(compatibiliteTypeVarB(saveName,var) == -1)
                    printf("Erreur semantique a la ligne %d a la colonne %d : incompatibilite de type de la variable dans affectation \n",yylineo,Col);}
            }
           }
    | LIST_IIDF{
          if(t == 0)
                {
                  if(op == 3){
                    if(val == 0)
                      printf("Erreur semantique a la ligne %d a la colonne %d : division par zero \n",yylineo,Col);
                      }
                    else{
                      if(compatibiliteTypeVar(saveName,aaa) == -1)
                        printf("Erreur semantique a la ligne %d a la colonne %d : incompatibilite de type de la variable dans affectation \n",yylineo,Col);}
                }
                if(t == 1){
                    if(compatibiliteTypeVarB(saveName,var) == -1)
                        printf("Erreur semantique a la ligne %d a la colonne %d : incompatibilite de type de la variable dans affectation \n",yylineo,Col);}
        }
      | paro EXP parf OPERATEUR EXP
      | paro EXP parf
;
LIST_IIDF: CONSTANTE{t=0;}
         | idf{ 
              if(rechercher_idf_cste($1) == 0 && rechercher_idf_var($1) == 0){
                  printf("Erreur semantique a la ligne %d a la colonne %d : une variable n'est pas declarer \n",yylineo,Col);}
                strcpy(var,$1);
                t=1;
          }
         | idf croo const_entier crof{
                if(rechercher_idf_tab($1,$3) == 1)
                  printf("Erreur semantique a la ligne %d a la colonne %d : indice de tableau doit etre inferieur a la taille maximale \n",yylineo,Col);
                else{
                  if(rechercher_idf_tab($1,$3) == 0)
                    printf("Erreur semantique a la ligne %d a la colonne %d : un tableau n'est pas declarer \n",yylineo,Col);
                strcpy(var,$1);
                t=1;

                }
              }
;
OPERATEUR: addition{
            op = 1;
          }
         | soustraction{
            op = 2;
          }
         | division{
            op = 3;
          }
         | multiple{
            op = 4;
          }
;
CONSTANTE: const_entier{
          aaa = 1 ;
          val = $1;
}
         | const_reel{
          aaa = 2 ;
          val2 = $1;
}
         | const_ch{
          aaa = 4 ;
}
         | const_str{
          aaa = 3 ;
}
;

BOUCLE: mc_while paro CONDITION parf acco PGM accf{
        if(tester_biblio_dec("PROCESS") == -1)
          printf("Erreur semantique a la ligne %d a la colonne %d : la bibliotheque PROCESS n'est pas declarer \n",yylineo,Col);
}
;

CNDS: mc_inf
    | mc_infe
    | mc_sup
    | mc_supe
;

RW: READ
  | WRITE 
;

READ: mc_read paro const_str pip adr IDF parf fin{
    aaa = Tester_Read($3);
    if(Tester_Read($3) == 0){
      printf("Erreur syntaxique a la ligne %d a la colonne %d : Entite doit etre d'un signe \n",yylineo,Col);
      if(compatibiliteTypeVar(saveName,aaa) == -1)
        printf("Erreur semantique a la ligne %d a la colonne %d : incompatibilite de type de la variable dans affectation \n",yylineo,Col);
      }
}
;

IDF: idf{
          strcpy(saveName,$1);
          if(rechercher_idf_cste($1) == 0 && rechercher_idf_var($1) == 0){
            printf("Erreur semantique a la ligne %d a la colonne %d : une variable n'est pas declarer \n",yylineo,Col);}
          else{
            if(rechercher_idf_cste($1) == -1)
              printf("Erreur semantique a la ligne %d a la colonne %d : une constante ne change pas \n",yylineo,Col);
          }
}
   | idf croo const_entier crof{
           strcpy(saveName,$1);
           if(rechercher_idf_tab($1,$3) == 1)
                  printf("Erreur semantique a la ligne %d a la colonne %d : indice de tableau doit etre inferieur a la taille maximale \n",$3,yylineo,Col);
            else{
                if(rechercher_idf_tab($1,$3) == 0)
                  printf("Erreur semantique a la ligne %d a la colonne %d : un tableau n'est pas declarer \n",yylineo,Col);}
   }
   | idf croo idf crof{
            strcpy(saveName,$1);
            if(rechercher_idf_tab($1,0) == 1)
                  printf("Erreur semantique a la ligne %d a la colonne %d : indice de tableau doit etre inferieur a la taille maximale \n",yylineo,Col);
            else{
                if(rechercher_idf_tab($1,0) == 0)
                  printf("Erreur semantique a la ligne %d a la colonne %d : un tableau n'est pas declarer \n",yylineo,Col);}
            if(rechercher_idf_cste($3) == 0 && rechercher_idf_var($3) == 0){
                printf("Erreur semantique a la ligne %d a la colonne %d : une variable n'est pas declarer \n",$3,yylineo,Col);}
   }
;

WRITE: mc_write paro const_str pip LIST_IDF parf fin{
    strcpy(saveName,$3);
    if(verifier_write($3) == -1)
      printf("Erreur syntaxique a la ligne %d a la colonne %d : Entite doit etre d'un signe \n",yylineo,Col);
}
;

LIST_IDF: idf sep LIST_IDF{
        if(rechercher_idf_cste($1) == 0 && rechercher_idf_var($1) == 0){
          printf("Erreur semantique a la ligne %d a la colonne %d : une variable n'est pas declarer \n",yylineo,Col);}
        else{
          if(compatibiliteTypeVar($1,saveName) == -1)
            printf("Erreur semantique a la ligne %d a la colonne %d : incompatibilite de type de la variable dans affectation \n",yylineo,Col);
        }
      }
        | idf{
                if(rechercher_idf_cste($1) == 0 && rechercher_idf_var($1) == 0){
                  printf("Erreur semantique a la ligne %d a la colonne %d : une variable n'est pas declarer \n",yylineo,Col);}
                else{
                 if(compatibiliteTypeVar($1,saveName) == -1)
                  printf("Erreur semantique a la ligne %d a la colonne %d : incompatibilite de type de la variable dans affectation \n",yylineo,Col);
                }
        }
        | idf croo const_entier crof LIST_IDF{
                if(rechercher_idf_tab($1,$3) == 1)
                  printf("Erreur semantique a la ligne %d a la colonne %d : indice de tableau doit etre inferieur a la taille maximale \n",yylineo,Col);
                else{
                  if(rechercher_idf_tab($1,$3) == 0)
                    printf("Erreur semantique a la ligne %d a la colonne %d : un tableau n'est pas declarer \n",yylineo,Col);
                  else{
                    if(compatibiliteTypeTab($1,saveName) == -1)
                      printf("Erreur semantique a la ligne %d a la colonne %d : incompatibilite de type de la variable dans affectation \n",yylineo,Col);
                }
              }
        }
        | idf croo const_entier crof{
                if(rechercher_idf_tab($1,$3) == 1)
                  printf("Erreur semantique a la ligne %d a la colonne %d : indice de tableau doit etre inferieur a la taille maximale \n",yylineo,Col);
                else{
                  if(rechercher_idf_tab($1,$3) == 0)
                    printf("Erreur semantique a la ligne %d a la colonne %d : un tableau n'est pas declarer \n",yylineo,Col);}
        }

CONDITION_IF: mc_execut PGM mc_if paro CONDITION parf mc_end_if
            | mc_execut PGM mc_if paro CONDITION parf mc_else mc_execut PGM mc_end_if
;
CONDITION: idf CNDS CONDITION{
        if(rechercher_idf_cste($1) == 0 && rechercher_idf_var($1) == 0){
          printf("Erreur semantique a la ligne %d a la colonne %d : une variable n'est pas declarer \n",yylineo,Col);}
        else{
          if(rechercher_idf_cste($1) == -1)
            printf("Erreur semantique, a la ligne %d a la colonne %d : une constante ne change pas \n",yylineo,Col);
        }
      }
       | idf croo const_entier crof CNDS CONDITION{
           if(rechercher_idf_tab($1,$3) == 1)
                  printf("Erreur semantique a la ligne %d a la colonne %d : indice de tableau doit etre inferieur a la taille maximale \n",$3,yylineo,Col);
            else{
                if(rechercher_idf_tab($1,$3) == 0)
                  printf("Erreur semantique a la ligne %d a la colonne %d : un tableau n'est pas declarer \n",yylineo,Col);}
        }
       | CONSTANTE CNDS CONDITION
       | CONSTANTE
       | idf{
        if(rechercher_idf_cste($1) == 0 && rechercher_idf_var($1) == 0){
          printf("Erreur semantique a la ligne %d a la colonne %d : une variable n'est pas declarer \n",yylineo,Col);}
        else{
          if(rechercher_idf_cste($1) == -1)
            printf("Erreur semantique, a la ligne %d a la colonne %d : une constante ne change pas \n",yylineo,Col);
        }
      }
       | idf croo const_entier crof{
           strcpy(saveName,$1);
           if(rechercher_idf_tab($1,$3) == 1)
                  printf("Erreur semantique a la ligne %d a la colonne %d : indice de tableau doit etre inferieur a la taille maximale \n",$3,yylineo,Col);
            else{
                if(rechercher_idf_tab($1,$3) == 0)
                  printf("Erreur semantique a la ligne %d a la colonne %d : un tableau n'est pas declarer \n",yylineo,Col);}
        }

;

%%
main () 
{
        initialisation();
        yyparse();
        afficher();
}
yywrap()
{}
yyerror(char*msg)
{printf("Erreur Syntaxique, ligne %d, Colone %d \n",yylineo,Col);}