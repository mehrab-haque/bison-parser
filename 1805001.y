%{

#define YYSTYPE SymbolInfo*

#include<iostream>
#include<cstdlib>
#include<cstring>
#include<cmath>
#include<fstream>
#include "1805001_SymbolInfo.h"

using namespace std;

int yyparse(void);
int yylex(void);
extern FILE *yyin;

int lineCount=1;

ofstream logFile;



void yyerror(char *s)
{
	//write your code
}

void log(string rule,SymbolInfo *symbolInfo){
	logFile<<"Line "<<lineCount<<" : "<<symbolInfo->getType()<<" : "<<rule<<endl<<endl<<symbolInfo->getName()<<endl<<endl;
}


%}

%token ID ELSE LPAREN RPAREN SEMICOLON COMMA LCURL RCURL INT FLOAT VOID LTHIRD CONST_INT RTHIRD FOR IF WHILE PRINTLN RETURN ASSIGNOP RELOP ADDOP MULOP NOT CONST_FLOAT INCOP DECOP  

%left RELOP LOGICOP
%left ADDOP
%left MULOP

%nonassoc ELSE


%%

start : program
	{
		//write your code in this block in all the similar blocks below
	}
	;

program : program unit
	{
		$$=new SymbolInfo($1->getName()+"\n"+$2->getName(),"program");
		log("program unit",$$);
	}
	| unit
	{
		$$=new SymbolInfo($1->getName(),"program");
		log("unit",$$);
	}
	;
	
unit : var_declaration
	 {
		$$=new SymbolInfo($1->getName(),"unit");
		log("var_declaration",$$);
	 }
	 | func_declaration
	 {
		 $$=new SymbolInfo($1->getName(),"unit");
		log("func_declaration",$$);
	 }
     ;

var_declaration : type_specifier declaration_list SEMICOLON
     {
		$$=new SymbolInfo($1->getName()+" "+$2->getName()+$3->getName(),"var_declaration");
		log("type_specifier declaration_list SEMICOLON",$$);
	 }
 	 ;

declaration_list : declaration_list COMMA ID
	{
		$$=new SymbolInfo($1->getName()+$2->getName()+$3->getName(),"declaration_list");
		log("declaration_list COMMA ID",$$);	
	}
	| declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
	{
		$$=new SymbolInfo($1->getName()+$2->getName()+$3->getName()+$4->getName()+$5->getName()+$6->getName(),"declaration_list");
		log("declaration_list COMMA ID LTHIRD CONST_INT RTHIRD",$$);
	}
	| ID
	{
		$$=new SymbolInfo($1->getName(),"declaration_list");
		log("ID",$$);
	}
	| ID LTHIRD CONST_INT RTHIRD
	{
		$$=new SymbolInfo($1->getName()+$2->getName()+$3->getName()+$4->getName(),"declaration_list");
		log("ID LTHIRD CONST_INT RTHIRD",$$);
	}
	;
     
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON
		{
			$$=new SymbolInfo($1->getName()+" "+$2->getName()+$3->getName()+$4->getName()+$5->getName()+$6->getName(),"func_declaration");
			log("type_specifier ID LPAREN parameter_list RPAREN SEMICOLON",$$);
		}
		| type_specifier ID LPAREN RPAREN SEMICOLON
		{
			$$=new SymbolInfo($1->getName()+" "+$2->getName()+$3->getName()+$4->getName()+$5->getName(),"func_declaration");
			log("type_specifier ID LPAREN RPAREN SEMICOLON",$$);
		}
		;

parameter_list  : parameter_list COMMA type_specifier ID
		{
			$$=new SymbolInfo($1->getName()+$2->getName()+$3->getName()+" "+$4->getName(),"parameter_list");
			log("parameter_list COMMA type_specifier ID",$$);
		}
		| parameter_list COMMA type_specifier
		{
			$$=new SymbolInfo($1->getName()+$2->getName()+$3->getName(),"parameter_list");
			log("parameter_list COMMA type_specifier",$$);
		}
 		| type_specifier ID
		 {
			$$=new SymbolInfo($1->getName()+" "+$2->getName(),"parameter_list");
			log("type_specifier ID",$$);
		 }
		| type_specifier
		{
			$$=new SymbolInfo($1->getName(),"parameter_list");
			log("type_specifier",$$);
		}
 		;

 		 
type_specifier	: INT
		{
			$$=new SymbolInfo($1->getName(),"type_specifier");
			log("INT",$$);
		}
 		| FLOAT
		{
			$$=new SymbolInfo($1->getName(),"type_specifier");
			log("FLOAT",$$);
		}
 		| VOID 
		{
			$$=new SymbolInfo($1->getName(),"type_specifier");
			log("FLOAT",$$);
		}
 		;

 

%%
int main(int argc,char *argv[])
{

	FILE *fp;

	if((fp=fopen(argv[1],"r"))==NULL)
	{
		printf("Cannot Open Input File.\n");
		exit(1);
	}

	logFile.open("1805001_log.txt");

	yyin=fp;
	yyparse();
	

	fclose(fp);
	logFile.close();
	
	return 0;
}

