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

extern int lineCount;
int tmpLineCount,errorCount=0;
string stringBody;
string logStringBody;
string commentBody;

%}

Integer [0-9]+
Float [0-9]*([.][0-9]+)?([eE][-+]?[0-9]+)?
SingleQuot \'
  
%%

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


(";") {
    SymbolInfo * symbolInfo=(YYSTYPE)new SymbolInfo(string(yytext,strlen(yytext)),"SEMICOLON");
    yylval=(YYSTYPE)symbolInfo;
    return SEMICOLON;
}


(" "|\t)* {}


\n {lineCount++;}
%%
