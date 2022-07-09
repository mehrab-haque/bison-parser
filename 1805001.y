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

ofstream logFile,errorFile;

SymbolTable *symbolTable;

const string GROUP_VARIABLE="var";
const string GROUP_FUNCTION_DECLARATION="func_dec";
const string GROUP_FUNCTION_DEFINITION="func_def";
const string GROUP_ARRAY="array";



void yyerror(char *s)
{
	//write your code
}

void log(string rule,SymbolInfo *symbolInfo){
	logFile<<"Line "<<lineCount<<" : "<<symbolInfo->getType()<<" : "<<rule<<endl<<endl<<symbolInfo->getName()<<endl<<endl;
}

void insertVariablesToTable(SymbolInfo *type,vector<SymbolInfo*> symbols,string code){
	for(int i=0;i<symbols.size();i++){
		SymbolInfo *newSymbol=new SymbolInfo(symbols[i]->getName(),"ID");
		newSymbol->setVariant(type->getName());
		newSymbol->setGroup(GROUP_VARIABLE);
		bool isInserted=symbolTable->insertSymbol(newSymbol);
		if(!isInserted){
			logFile<<"Error at line "<<lineCount<<": Multiple declaration of "<<newSymbol->getName()<<endl<<endl<<code<<endl<<endl;
			errorFile<<"Error at line "<<lineCount<<": Multiple declaration of "<<newSymbol->getName()<<endl<<endl;
		}
	}

}

void insertFunctionDeclarationToTable(SymbolInfo *type,SymbolInfo *funcId,vector<SymbolInfo*> params,string code){
	SymbolInfo *funcSymbol=new SymbolInfo(funcId->getName(),"ID");
	funcSymbol->setVariant(type->getName());
	funcSymbol->setGroup(GROUP_FUNCTION_DECLARATION);
	for(int i=0;i<params.size();i++){
		SymbolInfo *newParam=new SymbolInfo(params[i]->getName(),"ID");
		newParam->setVariant(params[i]->getVariant());
		funcSymbol->addChildSymbol(newParam);
	}
	bool isInserted=symbolTable->insertSymbol(funcSymbol);
	if(!isInserted){
		logFile<<"Error at line "<<lineCount<<": Multiple declaration of "<<funcSymbol->getName()<<endl<<endl<<code<<endl<<endl;
		errorFile<<"Error at line "<<lineCount<<": Multiple declaration of "<<funcSymbol->getName()<<endl<<endl;
	}
}


void insertFunctionDefinitionToTable(SymbolInfo *type,SymbolInfo *funcId,vector<SymbolInfo*> params,string code){
	SymbolInfo *funcSymbol=new SymbolInfo(funcId->getName(),"ID");
	funcSymbol->setVariant(type->getName());
	funcSymbol->setGroup(GROUP_FUNCTION_DECLARATION);
	for(int i=0;i<params.size();i++){
		SymbolInfo *newParam=new SymbolInfo(params[i]->getName(),"ID");
		newParam->setVariant(params[i]->getVariant());
		funcSymbol->addChildSymbol(newParam);
	}
	SymbolInfo *foundSymbol=symbolTable->lookup(funcId->getName());
	if(foundSymbol==NULL)
		symbolTable->insertSymbol(funcSymbol);
	else if(foundSymbol->getGroup().compare(GROUP_FUNCTION_DECLARATION))
		foundSymbol->setGroup(GROUP_FUNCTION_DEFINITION);
	else{
		logFile<<"Error at line "<<lineCount<<": Multiple declaration of "<<funcSymbol->getName()<<endl<<endl<<code<<endl<<endl;
		errorFile<<"Error at line "<<lineCount<<": Multiple declaration of "<<funcSymbol->getName()<<endl<<endl;
	}
	symbolTable->exitScope();
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

func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement
	{
		$$=new SymbolInfo($1->getName()+" "+$2->getName()+$3->getName()+$4->getName()+$5->getName()+$6->getName(),"func_definition");
		insertFunctionDefinitionToTable($1,$2,$4->getChildSymbols(),$$->getName());
		log("type_specifier ID LPAREN parameter_list RPAREN compound_statement",$$);
	}
	| type_specifier ID LPAREN RPAREN compound_statement
	{
		vector<SymbolInfo*> symbols;
		$$=new SymbolInfo($1->getName()+" "+$2->getName()+$3->getName()+$4->getName()+$5->getName(),"func_definition");
		insertFunctionDefinitionToTable($1,$2,symbols,$$->getName());
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
		insertVariablesToTable($1,$2->getChildSymbols(),$$->getName());
		log("type_specifier declaration_list SEMICOLON",$$);
	 }
 	 ;

declaration_list : declaration_list COMMA ID
	{
		$$=new SymbolInfo($1->getName()+$2->getName()+$3->getName(),"declaration_list");
		for(int i=0;i<$1->getChildSymbols().size();i++)
			$$->addChildSymbol($1->getChildSymbols()[i]);
		$$->addChildSymbol($3);
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
		$$->addChildSymbol($1);
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
			symbolTable->exitScope();
			$$=new SymbolInfo($1->getName()+" "+$2->getName()+$3->getName()+$4->getName()+$5->getName()+$6->getName(),"func_declaration");
			insertFunctionDeclarationToTable($1,$2,$4->getChildSymbols(),$$->getName());
			log("type_specifier ID LPAREN parameter_list RPAREN SEMICOLON",$$);
		}
		| type_specifier ID LPAREN RPAREN SEMICOLON
		{
			vector<SymbolInfo*> symbols;
			$$=new SymbolInfo($1->getName()+" "+$2->getName()+$3->getName()+$4->getName()+$5->getName(),"func_declaration");
			insertFunctionDeclarationToTable($1,$2,symbols,$$->getName());
			log("type_specifier ID LPAREN RPAREN SEMICOLON",$$);
		}
		;

parameter_list  : parameter_list COMMA type_specifier ID
		{
			$$=new SymbolInfo($1->getName()+$2->getName()+$3->getName()+" "+$4->getName(),"parameter_list");
			for(int i=0;i<$1->getChildSymbols().size();i++)
				$$->addChildSymbol($1->getChildSymbols()[i]);
			$4->setVariant($3->getName());
			bool isInserted=symbolTable->insertSymbol($4);
			if(!isInserted){
				logFile<<"Error at line "<<lineCount<<": Multiple declaration of "<<$4->getName()<<endl<<endl<<$$->getName()<<endl<<endl;
				errorFile<<"Error at line "<<lineCount<<": Multiple declaration of "<<$4->getName()<<endl<<endl;
			}
			$$->addChildSymbol($4);
			log("parameter_list COMMA type_specifier ID",$$);
		}
		| parameter_list COMMA type_specifier
		{
			$$=new SymbolInfo($1->getName()+$2->getName()+$3->getName(),"parameter_list");
			for(int i=0;i<$1->getChildSymbols().size();i++)
				$$->addChildSymbol($1->getChildSymbols()[i]);
			SymbolInfo *newSymbol=new SymbolInfo(NULL,"ID");
			newSymbol->setVariant($3->getName());
			bool isInserted=symbolTable->insertSymbol(newSymbol);
			if(!isInserted){
				logFile<<"Error at line "<<lineCount<<": Multiple declaration of "<<newSymbol->getName()<<endl<<endl<<$$->getName()<<endl<<endl;
				errorFile<<"Error at line "<<lineCount<<": Multiple declaration of "<<newSymbol->getName()<<endl<<endl;
			}
			$$->addChildSymbol(newSymbol);
			log("parameter_list COMMA type_specifier",$$);
		}
 		| type_specifier ID
		 {
			symbolTable->enterScope();
			$$=new SymbolInfo($1->getName()+" "+$2->getName(),"parameter_list");
			$2->setVariant($1->getName());
			bool isInserted=symbolTable->insertSymbol($2);
			if(!isInserted){
				logFile<<"Error at line "<<lineCount<<": Multiple declaration of "<<$2->getName()<<endl<<endl<<$$->getName()<<endl<<endl;
				errorFile<<"Error at line "<<lineCount<<": Multiple declaration of "<<$2->getName()<<endl<<endl;
			}
			$$->addChildSymbol($2);
			log("type_specifier ID",$$);
		 }
		| type_specifier
		{
			symbolTable->enterScope();
			$$=new SymbolInfo($1->getName(),"parameter_list");
			SymbolInfo *newSymbol=new SymbolInfo(NULL,"ID");
			newSymbol->setVariant($1->getName());
			bool isInserted=symbolTable->insertSymbol(newSymbol);
			if(!isInserted){
				logFile<<"Error at line "<<lineCount<<": Multiple declaration of "<<newSymbol->getName()<<endl<<endl<<$$->getName()<<endl<<endl;
				errorFile<<"Error at line "<<lineCount<<": Multiple declaration of "<<newSymbol->getName()<<endl<<endl;
			}
			$$->addChildSymbol(newSymbol);
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

	symbolTable=new SymbolTable(7);

	logFile.open("1805001_log.txt");
	errorFile.open("1805001_error.txt");

	yyin=fp;
	yyparse();
	

	fclose(fp);
	logFile.close();
	
	return 0;
}

