/* BOUSSOURA Mohamed Cherif 181832022492 - FAZEZ Said Massinissa 181831029050 - L3 ACAD A3/3.2 */
/****************CREATION DE LA TABLE DES SYMBOLES ******************/
/*******************************Step 1: Definition des structures de données*********************************/
#include <stdio.h>
#include <stdlib.h>
typedef struct
{
  char type[20];
  char name[20];
  int taille;
}idf_tab;
typedef struct
{
  char type[20];
  char name[20];
}idf_var;
typedef struct
{
  char name[20];
}biblio_tab;
typedef struct
{
  char name[20];
  char type[20];
}cst_tab;
typedef struct
{
   int state;
   char name[20];
   char code[20];
   char type[20];
   float val;
 } element;

typedef struct
{ 
   int state; 
   char name[20];
   char type[20];
} elt;

element tab[1000];
elt tabs[40],tabm[40]; 
idf_tab tab_idf[1000]; /// tableau des variables tableau
int biblio_tab_i = 0; /// la taille d'un tableau des bilbiotheques
biblio_tab tab_biblio[1000]; /// tableau des bibliotheques
int idf_tab_i = 0; /// la taille d'un tableau des varibales tableau
idf_var tab_var[1000]; /// tableau des variables
int idf_var_i = 0; /// la taille d'un tableau des varibales
int idf_cste_i = 0; /// la taille d'un tableau des constantes
cst_tab idf_cste[1000]; /// tableau des constantes
extern char sav[20];

/***Step 2: initialisation de l'état des cases des tables des symbloles***/
/*0: la case est libre    1: la case est occupée*/

void initialisation()
{
  int i;
  for (i=0;i<1000;i++)
    tab[i].state=0;

  for (i=0;i<40;i++)
    {tabs[i].state=0;
    tabm[i].state=0;}

}


/***Step 3: insertion des entititées lexicales dans les tables des symboles ***/

void inserer (char entite[], char code[],char type[],float val,int i,int y)
{
  switch (y)
 { 
   case 0:/*insertion dans la table des IDF et CONST*/
       tab[i].state=1;
       strcpy(tab[i].name,entite);
       strcpy(tab[i].code,code);
       strcpy(tab[i].type,type);
       tab[i].val=val;
     break;

   case 1:/*insertion dans la table des mots clés*/
       tabm[i].state=1;
       strcpy(tabm[i].name,entite);
       strcpy(tabm[i].type,code);
       break; 
    
   case 2:/*insertion dans la table des séparateurs*/
      tabs[i].state=1;
      strcpy(tabs[i].name,entite);
      strcpy(tabs[i].type,code);
      break;
 }

}

/***Step 4: La fonction Rechercher permet de verifier  si l'entité existe dèja dans la table des symboles */
void rechercher (char entite[], char code[],char type[],float val,int y)  
{

int j,i;

switch(y) 
  {
   case 0:/*verifier si la case dans la tables des IDF et CONST est libre*/
        for (i=0;((i<1000)&&(tab[i].state==1))&&(strcmp(entite,tab[i].name)!=0);i++); 
        if(i<1000)
        {inserer(entite,code,type,val,i,0); }
        break;

   case 1:/*verifier si la case dans la tables des mots clés est libre*/
       
       for (i=0;((i<40)&&(tabm[i].state==1))&&(strcmp(entite,tab[i].name)!=0);i++); 
        if(i<40)
          inserer(entite,code,type,val,i,1);
        break; 
    
   case 2:/*verifier si la case dans la tables des séparateurs est libre*/
         for (i=0;((i<40)&&(tabs[i].state==1))&&(strcmp(entite,tab[i].name)!=0);i++); 
        if(i<40)
         inserer(entite,code,type,val,i,2);
        break;

    case 3:/*verifier si la case dans la tables des IDF et CONST est libre*/
        for (i=0;((i<1000)&&(tab[i].state==1))&&(strcmp(entite,tab[i].name)!=0);i++); 
                  
        if (i<1000)
        { inserer(entite,code,type,val,i,0); }
        break;
  }
}
/***Step 5: Les fonctions declarer pour gerer la sémantique */
/* Tester Bibliotheque si déclarer */
int tester_biblio_dec(char entite[]){
  int i=0;
  for(i=0;i<biblio_tab_i;i++){
    if(strcmp(tab_biblio[i].name,entite) == 0)
      return 1;
  }
  return -1;
}
void insert_biblio(char entite[]){
  strcpy(tab_biblio[biblio_tab_i].name,entite);
  biblio_tab_i++;
}
int doubleDeclarationBiblio(char entite[]){
  int i;
  for(i=0;i<biblio_tab_i;i++){
    if(strcmp(tab_biblio[i].name,entite) == 0)
        return -1;
  }
  return 0;
}
/* les variables tableaux */
int tester_tab(int i){
  if(i<0)
    return -1;
  else
    return 0;
}
void insertIdfTab(char entite[],int taille,char type[]){
  strcpy(tab_idf[idf_tab_i].name,entite);
  tab_idf[idf_tab_i].taille = taille;
  strcpy(tab_idf[idf_tab_i].type,type);
  idf_tab_i++;
}
int rechercher_idf_tab(char entite[],int val){
  int i; /// Si la varibale est deja declarer comme un tableau
    for(i=0;i<idf_tab_i;i++){
      if(strcmp(tab_idf[i].name,entite) == 0){
        if(tab_idf[i].taille < val)
          return 1;
        else
          return -1;
      }
    }
    return 0;
}
int doubleDeclaration(char entite[]){
  int i;
  if(rechercher_idf_var(entite) == 0 && rechercher_idf_cste(entite) == 0){
    for(i=0;i<idf_tab_i;i++){
      if(strcmp(tab_idf[i].name,entite) == 0)
          return -1;
    }
    return 0;
  }
  else
    return -1;
}
int compatibiliteTypeTab(char entite[],int a){
  int i;
  for(i=0;i<idf_var_i;i++){
    if(strcmp(tab_idf[i].name,entite) == 0)
      break;
  }
  switch (a)
  {
  case 1: /* integer */{
    if(strcmp(tab_idf[i].type,"INTEGER") == 0)
      return 0;
    }
  case 2: /* real */{
    if(strcmp(tab_idf[i].type,"REAL") == 0)
      return 0;
    }
  case 3: /* string */{
    if(strcmp(tab_idf[i].type,"STRING") == 0)
      return 0;
    }
  case 4: /* char */{
    if(strcmp(tab_idf[i].type,"CHAR") == 0)
      return 0;
    }
  }
  return -1;
}
/**** variables simple ****/
void insertIdfVar(char entite[],char type[]){
  strcpy(tab_var[idf_var_i].name,entite);
  strcpy(tab_var[idf_var_i].type,type);
  idf_var_i++;
}
int rechercher_idf_var(char entite[]){
  int i;
      for(i=0;i<idf_var_i;i++){
        if(strcmp(tab_var[i].name,entite) == 0)
          return -1;
      }
      return 0;
}
int doubleDeclarationVar(char entite[]){
  int i;
  if(rechercher_idf_cste(entite) == 0 && rechercher_idf_tab(entite,0) == 0){
    for(i=0;i<idf_var_i;i++){
      if(strcmp(tab_var[i].name,entite) == 0)
          return -1;
    }
    return 0;
  }
  return -1;
}
int compatibiliteTypeVar(char entite[],int a){
  int i;
  for(i=0;i<idf_var_i;i++){
    if(strcmp(tab_var[i].name,entite) == 0)
      break;
  }
  switch (a)
  {
  case 1: /* integer */{
    if(strcmp(tab_var[i].type,"INTEGER") == 0)
      return 0;
    }
  case 2: /* real */{
    if(strcmp(tab_var[i].type,"REAL") == 0)
      return 0;
    }
  case 3: /* string */{
    if(strcmp(tab_var[i].type,"STRING") == 0)
      return 0;
    }
  case 4: /* char */{
    if(strcmp(tab_var[i].type,"CHAR") == 0)
      return 0;
    }
  }
  return -1;
}
int compatibiliteTypeVarB(char entite1[],char entite2[]){ /* c'est pour les variables */
  int i , j ;
  i = searchPosVar(entite1);
  j = searchPosVar(entite2);
  if(strcmp(tab_var[i].type,tab_var[j].type) == 0)
    return 0;
  else
    return -1;
}
int verifier_write(char entite[]){
  if(strlen(entite) == 0)
    return -1;
  return 0;
}
/*** tableau CSTE ***/
void insert_cste(char entite[],char type[]){
  strcpy(idf_cste[idf_cste_i].name,entite);
  strcpy(idf_cste[idf_cste_i].type,type);
  idf_cste_i++;
}
int rechercher_idf_cste(char entite[]){
  int i;
      for(i=0;i<idf_var_i;i++){
        if(strcmp(idf_cste[i].name,entite) == 0)
          return -1;
      }
      return 0;
}
int doubleDeclarationCste(char entite[]){
  int i;
  if(rechercher_idf_var(entite) == 0 && rechercher_idf_tab(entite,0) == 0){
    for(i=0;i<idf_cste_i;i++){
      if(strcmp(idf_cste[i].name,entite) == 0)
          return -1;
    }
    return 0;
  }
  return -1;
}
/*** READ  / WRITE ***/
int Tester_Read(char phrase[]){
  if(strcmp(phrase,"\";\"") == 0) /* integer */
    return 1;
  if(strcmp(phrase,"\"%\"") == 0) /* real */
    return 2;
  if(strcmp(phrase,"\"?\"") == 0) /* string */
    return 3;
  if(strcmp(phrase,"\"&\"") == 0) /* char */
    return 4;
  return 0;
}
int compatibiliteTypeCst(char entite[],int a){
  int i;
  for(i=0;i<idf_cste_i;i++){
    if(strcmp(idf_cste[i].name,entite) == 0)
      break;
  }
  switch (a)
  {
  case 1: /* integer */{
    if(strcmp(idf_cste[i].type,"INTEGER") == 0)
      return 0;
    }
  case 2: /* real */{
    if(strcmp(idf_cste[i].type,"REAL") == 0)
      return 0;
    }
  case 3: /* string */{
    if(strcmp(idf_cste[i].type,"STRING") == 0)
      return 0;
    }
  case 4: /* char */{
    if(strcmp(idf_cste[i].type,"CHAR") == 0)
      return 0;
    }
  }
  return -1;
}
/* chercher position */
int searchPosVar(char entite[]){
  int i ;
  for(i=0;i<idf_var_i;i++){           /* si entite est une idf */
    if(strcmp(tab_var[i].name,entite) == 0)
      return i;
  }
  for(i=0;i<idf_tab_i;i++){           /* si entite est un tab */
    if(strcmp(tab_idf[i].name,entite) == 0)
      return i;
  }
  for(i=0;i<idf_cste_i;i++){          /* si entite est une cste */
    if(strcmp(idf_cste[i].name,entite) == 0)
      return i;
  }
  return -1 ;
}
/***Step 6 L'affichage du contenue de la table des symboles ***/

void afficher()
{int i;

printf("/***************Table des symboles IDF*************/\n");
printf("____________________________________________________________________\n");
printf("\t| Nom_Entite |  Code_Entite | Type_Entite | Val_Entite\n");
printf("____________________________________________________________________\n");

for(i=0;i<100;i++)
{ 
  
    if(tab[i].state==1)
      { 
        printf("\t|%10s |%15s | %12s | %12f\n",tab[i].name,tab[i].code,tab[i].type,tab[i].val);
         
      }
}
printf("\n/***************Table des symboles mots cles*************/\n");
printf("_____________________________________\n");
printf("\t| NomEntite |  CodeEntite | \n");
printf("_____________________________________\n");
for(i=0;i<40;i++)
    if(tabm[i].state==1)
      { 
        printf("\t|%10s |%12s | \n",tabm[i].name, tabm[i].type);        
      }
printf("\n/***************Table des symboles separateurs*************/\n");
printf("_____________________________________\n");
printf("\t| NomEntite |  CodeEntite | \n");
printf("_____________________________________\n"); 
for(i=0;i<40;i++)
    if(tabs[i].state==1)
      { 
        printf("\t|%10s |%12s | \n",tabs[i].name,tabs[i].type);        
      }
}
