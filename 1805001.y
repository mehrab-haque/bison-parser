%{

#define YYSTYPE SymbolInfo*

#include<iostream>
#include<cstdlib>
#include<cstring>
#include<cmath>
#include<fstream>
#include "1805001_SymbolInfo.h"
#include "1805001_SymbolTable.h"

using namespace std;

int yyparse(void);
int yylex(void);
extern FILE *yyin;

int lineCount=1;

ofstream logFile;

SymbolTable *symbolTable;



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

%nonassoc LOWER_THAN_ELSE
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
	 | func_definition
	 {
		$$=new SymbolInfo($1->getName(),"unit");
		log("func_definition",$$);
	 }
     ;

func_definition : type_specifier ID LPAREN {

	} parameter_list RPAREN compound_statement
	{
		$$=new SymbolInfo($1->getName()+" "+$2->getName()+$3->getName()+$4->getName()+$5->getName()+$6->getName(),"func_definition");
		log("type_specifier ID LPAREN parameter_list RPAREN compound_statement",$$);
	}
	| type_specifier ID LPAREN RPAREN compound_statement
	{
		$$=new SymbolInfo($1->getName()+" "+$2->getName()+$3->getName()+$4->getName()+$5->getName(),"func_definition");
		log("type_specifier ID LPAREN RPAREN compound_statement",$$);
	}
	;

compound_statement : LCURL statements RCURL
	{
		$$=new SymbolInfo($1->getName()+"\n"+$2->getName()+"\n"+$3->getName(),"compound_statement");
		log("LCURL statements RCURL",$$);	
	}
	| LCURL RCURL
	{
		$$=new SymbolInfo($1->getName()+$2->getName(),"compound_statement");
		log("LCURL RCURL",$$);
	}
	;

statements : statement
	{
		$$=new SymbolInfo($1->getName(),"statements");
		log("statement",$$);
	}
	| statements statement
	{
		$$=new SymbolInfo($1->getName()+"\n"+$2->getName(),"statements");
		log("statements statement",$$);
	}
	;
	   
statement : var_declaration
	{
		$$=new SymbolInfo($1->getName(),"statement");
		log("var_declaration",$$);
	}
	| expression_statement
	{
		$$=new SymbolInfo($1->getName(),"statement");
		log("expression_statement",$$);
	}
	| compound_statement
	{
		$$=new SymbolInfo($1->getName(),"statement");
		log("compound_statement",$$);
	}
	| FOR LPAREN expression_statement expression_statement expression RPAREN statement
	{
		$$=new SymbolInfo($1->getName()+$2->getName()+$3->getName()+$4->getName()+$5->getName()+$6->getName()+$7->getName(),"statement");
		log("FOR LPAREN expression_statement expression_statement expression RPAREN statement",$$);
	}
	| IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE
	{
		$$=new SymbolInfo($1->getName()+$2->getName()+$3->getName()+$4->getName()+$5->getName(),"statement");
		log("IF LPAREN expression RPAREN statement",$$);
	}
	| IF LPAREN expression RPAREN statement ELSE statement
	{
		$$=new SymbolInfo($1->getName()+$2->getName()+$3->getName()+$4->getName()+$5->getName()+$6->getName()+$7->getName(),"statement");
		log("IF LPAREN expression RPAREN statement ELSE statement",$$);
	}
	| WHILE LPAREN expression RPAREN statement
	{
		$$=new SymbolInfo($1->getName()+$2->getName()+$3->getName()+$4->getName()+$5->getName(),"statement");
		log("WHILE LPAREN expression RPAREN statement",$$);
	}
	| PRINTLN LPAREN ID RPAREN SEMICOLON
	{
		$$=new SymbolInfo($1->getName()+$2->getName()+$3->getName()+$4->getName()+$5->getName(),"statement");
		log("PRINTLN LPAREN ID RPAREN SEMICOLON",$$);
	}
	| RETURN expression SEMICOLON
	{
		$$=new SymbolInfo($1->getName()+" "+$2->getName()+$3->getName(),"statement");
		log("RETURN expression SEMICOLON",$$);
	}
	;

expression_statement : SEMICOLON
	{
		$$=new SymbolInfo($1->getName(),"expression_statement");
		log("SEMICOLON",$$);
	}			
	| expression SEMICOLON 
	{
		$$=new SymbolInfo($1->getName()+$2->getName(),"expression_statement");
		log("expression SEMICOLON ",$$);
	}
	;

variable : ID 
	{
		$$=new SymbolInfo($1->getName(),"variable");
		log("ID",$$);
	}		
	| ID LTHIRD expression RTHIRD
	{
		$$=new SymbolInfo($1->getName()+$2->getName()+$3->getName()+$4->getName(),"variable");
		log("ID LTHIRD expression RTHIRD",$$);
	} 
	;

expression : logic_expression
	{
		$$=new SymbolInfo($1->getName(),"expression");
		log("logic_expression",$$);
	}	
	| variable ASSIGNOP logic_expression 
	{
		$$=new SymbolInfo($1->getName()+$2->getName()+$3->getName(),"expression");
		log("variable ASSIGNOP logic_expression",$$);
	}	
	;
			
logic_expression : rel_expression
	{
		$$=new SymbolInfo($1->getName(),"logic_expression");
		log("rel_expression",$$);
	}	
	| rel_expression LOGICOP rel_expression 
	{
		$$=new SymbolInfo($1->getName()+$2->getName()+$3->getName(),"logic_expression");
		log("rel_expression LOGICOP rel_expression",$$);
	}	
	;
			
rel_expression	: simple_expression
	{
		$$=new SymbolInfo($1->getName(),"rel_expression");
		log("simple_expression",$$);
	} 
	| simple_expression RELOP simple_expression
	{
		$$=new SymbolInfo($1->getName(),"rel_expression");
		log("simple_expression",$$);
	}
	;
				
simple_expression : term
	{
		$$=new SymbolInfo($1->getName(),"simple_expression");
		log("simple_expression",$$);
	}
	| simple_expression ADDOP term
	{
		$$=new SymbolInfo($1->getName()+$2->getName()+$3->getName(),"simple_expression");
		log("simple_expression ADDOP term",$$);
	}
	;
					
term :	unary_expression
	{
		$$=new SymbolInfo($1->getName(),"term");
		log("unary_expression",$$);
	}
     |  term MULOP unary_expression
	 {
		$$=new SymbolInfo($1->getName()+$2->getName()+$3->getName(),"term");
		log("term MULOP unary_expression",$$);
	 }
     ;

unary_expression : ADDOP unary_expression
	{
		$$=new SymbolInfo($1->getName()+$2->getName(),"unary_expression");
		log("ADDOP unary_expression",$$);
	}
	| NOT unary_expression 
	{
		$$=new SymbolInfo($1->getName()+$2->getName(),"unary_expression");
		log("NOT unary_expression",$$);
	}
	| factor
	{
		$$=new SymbolInfo($1->getName(),"unary_expression");
		log("factor",$$);
	} 
	;
	
factor	: variable
	{
		$$=new SymbolInfo($1->getName(),"factor");
		log("variable",$$);
	}
	| ID LPAREN argument_list RPAREN
	{
		$$=new SymbolInfo($1->getName()+$2->getName()+$3->getName()+$4->getName(),"factor");
		log("ID LPAREN argument_list RPAREN",$$);
	}
	| LPAREN expression RPAREN
	{
		$$=new SymbolInfo($1->getName()+$2->getName()+$3->getName(),"factor");
		log("LPAREN expression RPAREN",$$);
	}
	| CONST_INT
	{
		$$=new SymbolInfo($1->getName(),"factor");
		log("CONST_INT",$$);
	} 
	| CONST_FLOAT
	{
		$$=new SymbolInfo($1->getName(),"factor");
		log("CONST_FLOAT",$$);
	}
	| variable INCOP{
		$$=new SymbolInfo($1->getName(),"factor");
		log("INCOP",$$);
	} 
	| variable DECOP
	{
		$$=new SymbolInfo($1->getName(),"factor");
		log("DECOP",$$);
	}
	;
	
argument_list : arguments
	{
		$$=new SymbolInfo($1->getName(),"argument_list");
		log("arguments",$$);
	}
	;
	
arguments : arguments COMMA logic_expression
	{
		$$=new SymbolInfo($1->getName()+$2->getName()+$3->getName(),"arguments");
		log("arguments COMMA logic_expression",$$);
	}
	| logic_expression
	{
		$$=new SymbolInfo($1->getName(),"arguments");
		log("logic_expression",$$);
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
			log("VOID",$$);
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

	symbolTable=new SymbolTable(17);

	logFile.open("1805001_log.txt");

	yyin=fp;
	yyparse();
	

	fclose(fp);
	logFile.close();
	
	return 0;
}

