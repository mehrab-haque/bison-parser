%option noyywrap


%x STRING
%x COMMENT_SINGLE_LINE
%x COMMENT_MULTI_LINE

%{

#define YYSTYPE SymbolInfo*

#include<iostream>
#include<cstdio>
#include<cstring>
#include <string>
#include "1805001_SymbolInfo.h"
#include "y.tab.h"

using namespace std;

extern int lineCount,errorCount;
int tmpLineCount;
string stringBody;
string logStringBody;
string commentBody;

%}

Integer [0-9]+
Float [0-9]*([.][0-9]+)?([eE][-+]?[0-9]+)?
SingleQuot \'
  
%%

"if" {
    SymbolInfo * symbolInfo=new SymbolInfo(string(yytext,strlen(yytext)),"IF");
    yylval=(YYSTYPE)symbolInfo;
    return IF;
}

"else" {
    SymbolInfo * symbolInfo=new SymbolInfo(string(yytext,strlen(yytext)),"ELSE");
    yylval=(YYSTYPE)symbolInfo;
    return ELSE;
}

"for" {
    SymbolInfo * symbolInfo=new SymbolInfo(string(yytext,strlen(yytext)),"FOR");
    yylval=(YYSTYPE)symbolInfo;
    return FOR;
}

"while" {
    SymbolInfo * symbolInfo=new SymbolInfo(string(yytext,strlen(yytext)),"WHILE");
    yylval=(YYSTYPE)symbolInfo;
    return WHILE;
}

"printf" {
    SymbolInfo * symbolInfo=new SymbolInfo(string(yytext,strlen(yytext)),"PRINTLN");
    yylval=(YYSTYPE)symbolInfo;
    return PRINTLN;
}

"void" {
    SymbolInfo * symbolInfo=new SymbolInfo(string(yytext,strlen(yytext)),"VOID");
    yylval=(YYSTYPE)symbolInfo;
    return VOID;
}

"int" {
    SymbolInfo * symbolInfo=new SymbolInfo(string(yytext,strlen(yytext)),"INT");
    yylval=(YYSTYPE)symbolInfo;
    return INT;
}

"float" {
    SymbolInfo * symbolInfo=new SymbolInfo(string(yytext,strlen(yytext)),"FLOAT");
    yylval=(YYSTYPE)symbolInfo;
    return FLOAT;
}

"return" {
    SymbolInfo * symbolInfo=new SymbolInfo(string(yytext,strlen(yytext)),"RETURN");
    yylval=(YYSTYPE)symbolInfo;
    return RETURN;
}

("+"|"-") {
    SymbolInfo * symbolInfo=new SymbolInfo(string(yytext,strlen(yytext)),"ADDOP");
    yylval=(YYSTYPE)symbolInfo;
    return ADDOP;
}

("*"|"/"|"%") {
    SymbolInfo * symbolInfo=new SymbolInfo(string(yytext,strlen(yytext)),"MULOP");
    yylval=(YYSTYPE)symbolInfo;
    return MULOP;
}

("++") {
    SymbolInfo * symbolInfo=new SymbolInfo(string(yytext,strlen(yytext)),"INCOP");
    yylval=(YYSTYPE)symbolInfo;
    return INCOP;
}

("--") {
    SymbolInfo * symbolInfo=new SymbolInfo(string(yytext,strlen(yytext)),"DECOP");
    yylval=(YYSTYPE)symbolInfo;
    return DECOP;
}

("<"|"<="|">"|">="|"=="|"!=") {
    SymbolInfo * symbolInfo=new SymbolInfo(string(yytext,strlen(yytext)),"RELOP");
    yylval=(YYSTYPE)symbolInfo;
    return RELOP;
}

("=") {
    SymbolInfo * symbolInfo=new SymbolInfo(string(yytext,strlen(yytext)),"ASSIGNOP");
    yylval=(YYSTYPE)symbolInfo;
    return ASSIGNOP;
}

("&&"|"||") {
    SymbolInfo * symbolInfo=new SymbolInfo(string(yytext,strlen(yytext)),"LOGICOP");
    yylval=(YYSTYPE)symbolInfo;
    return LOGICOP;
}

("!") {
    SymbolInfo * symbolInfo=new SymbolInfo(string(yytext,strlen(yytext)),"NOT");
    yylval=(YYSTYPE)symbolInfo;
    return NOT;
}

"," {
    SymbolInfo * symbolInfo=new SymbolInfo(string(yytext,strlen(yytext)),"COMMA");
    yylval=(YYSTYPE)symbolInfo;
    return COMMA;
}

[a-zA-Z_][a-zA-Z0-9_]* {
    SymbolInfo * symbolInfo=(YYSTYPE)new SymbolInfo(string(yytext,strlen(yytext)),"ID");
    yylval=(YYSTYPE)symbolInfo;
    return ID;
}

{Integer} {
    SymbolInfo * symbolInfo=(YYSTYPE)new SymbolInfo(string(yytext,strlen(yytext)),"CONST_INT");
    yylval=(YYSTYPE)symbolInfo;
    return CONST_INT;
}

{Float} {
    SymbolInfo * symbolInfo=(YYSTYPE)new SymbolInfo(string(yytext,strlen(yytext)),"CONST_FLOAT");
    yylval=(YYSTYPE)symbolInfo;
    return CONST_FLOAT;
}


("(") {
    SymbolInfo * symbolInfo=(YYSTYPE)new SymbolInfo(string(yytext,strlen(yytext)),"LPAREN");
    yylval=(YYSTYPE)symbolInfo;
    return LPAREN;
}

(")") {
    SymbolInfo * symbolInfo=(YYSTYPE)new SymbolInfo(string(yytext,strlen(yytext)),"RPAREN");
    yylval=(YYSTYPE)symbolInfo;
    return RPAREN;
}

("[") {
    SymbolInfo * symbolInfo=(YYSTYPE)new SymbolInfo(string(yytext,strlen(yytext)),"LTHIRD");
    yylval=(YYSTYPE)symbolInfo;
    return LTHIRD;
}

("]") {
    SymbolInfo * symbolInfo=(YYSTYPE)new SymbolInfo(string(yytext,strlen(yytext)),"RTHIRD");
    yylval=(YYSTYPE)symbolInfo;
    return RTHIRD;
}

("{") {
    SymbolInfo * symbolInfo=(YYSTYPE)new SymbolInfo(string(yytext,strlen(yytext)),"LCURL");
    yylval=(YYSTYPE)symbolInfo;
    return LCURL;
}

("}") {
    SymbolInfo * symbolInfo=(YYSTYPE)new SymbolInfo(string(yytext,strlen(yytext)),"RCURL");
    yylval=(YYSTYPE)symbolInfo;
    return RCURL;
}


(";") {
    SymbolInfo * symbolInfo=(YYSTYPE)new SymbolInfo(string(yytext,strlen(yytext)),"SEMICOLON");
    yylval=(YYSTYPE)symbolInfo;
    return SEMICOLON;
}


(" "|\t)* {}


\n {lineCount++;}
%%
