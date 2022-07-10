#ifndef SYMBOLTABLE_H
#define SYMBOLABLE_H

#include <string>
#include <sstream>
#include "1805001_SymbolInfo.h"
#include "1805001_ScopeTable.h"

class SymbolTable{
	int bucketSize;
	ScopeTable *currentScope;
	string printScopesRecursively(ScopeTable *scope);
	void freeScopesRecursively(ScopeTable *scope);
	stringstream printStream;
	public:
		SymbolTable(int bucketSize);
		void enterScope();
		void exitScope();
		bool insertSymbol(string name,string type);
		bool insertSymbol(SymbolInfo *symbol);
		bool removeSymbol(string name);
		SymbolInfo *lookup(string name);
		SymbolInfo *lookupCurrent(string name);
		string printCurrentScope();
		string printAllScopes();
		string getCurrentScopeId();
		int getHashPos(string name);
		int getChainPos(string name);
		bool isGlobalScope();
		~SymbolTable();
};

void SymbolTable::freeScopesRecursively(ScopeTable *scope){
	if(scope->getParentScope()!=NULL)
		this->freeScopesRecursively(scope->getParentScope());
	delete scope;
}

SymbolTable::~SymbolTable(){
	freeScopesRecursively(this->currentScope);
}

bool SymbolTable::isGlobalScope(){
	return currentScope->getParentScope()==NULL;
}

SymbolInfo *SymbolTable::lookupCurrent(string name){
	return currentScope->lookup(name);
}

int SymbolTable::getHashPos(string name){
	return this->currentScope->getHashPos(name);
}

int SymbolTable::getChainPos(string name){
	return this->currentScope->getChainPos(name);
}

string SymbolTable::getCurrentScopeId(){
	return this->currentScope->getId();
}

string SymbolTable::printScopesRecursively(ScopeTable *scope){
	printStream<<scope->print();
	if(scope->getParentScope()!=NULL)
		this->printScopesRecursively(scope->getParentScope());
	return printStream.str();
}

string SymbolTable::printAllScopes(){
	printStream.str("");
	return this->printScopesRecursively(currentScope);
}

string SymbolTable::printCurrentScope(){
	printStream.str("");
	return this->currentScope->print();
}

SymbolInfo *SymbolTable::lookup(string name){
	SymbolInfo *foundSymbol=NULL;
	ScopeTable *tmpScope=currentScope;
	while(tmpScope!=NULL){
		foundSymbol=tmpScope->lookup(name);
		if(foundSymbol!=NULL)
			break;
		tmpScope=tmpScope->getParentScope();
	}
	return foundSymbol;
}

bool SymbolTable::removeSymbol(string name){
	return this->currentScope->deleteSymbol(name);
}

bool SymbolTable::insertSymbol(string name,string type){
	SymbolInfo *newSymbol=new SymbolInfo(name,type);
	bool isInserted=this->currentScope->insertSymbol(newSymbol);
	//if(!isInserted)delete newSymbol;
	return isInserted;
}

bool SymbolTable::insertSymbol(SymbolInfo *newSymbol){
	bool isInserted=this->currentScope->insertSymbol(newSymbol);
	//if(!isInserted)delete newSymbol;
	return isInserted;
}

void SymbolTable::exitScope(){
	ScopeTable *parentScope=this->currentScope->getParentScope();
	if(parentScope==NULL){
		//delete currentScope;
		currentScope=new ScopeTable(this->bucketSize);
		return;
	}
	ScopeTable *tmpScope=this->currentScope;
	this->currentScope=this->currentScope->getParentScope();
	//delete tmpScope;
}

void SymbolTable::enterScope(){
	ScopeTable *newScope=new ScopeTable(bucketSize,currentScope);
	this->currentScope=newScope;
}

SymbolTable::SymbolTable(int bucketSize){
	this->bucketSize=bucketSize;
	currentScope=new ScopeTable(bucketSize);
}

#endif
