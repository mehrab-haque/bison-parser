#ifndef SCOPETABLE_H
#define SCOPETABLE_H

#include <string>
#include <sstream>
#include "1805001_SymbolInfo.h"
#include "1805001_Hash.h"

class ScopeTable{
	Hash *hash;
	ScopeTable *parentScope;
	string id;
	int nChildScopes;
	stringstream printStream;
	
	public:
		ScopeTable(int size,ScopeTable *parentScope);
		ScopeTable(int size);
		string getId();
		int getNChildScopes();
		string getNChildScopesString();
		void incrementNChild();
		string print();
		bool insertSymbol(SymbolInfo *symbol);
		bool deleteSymbol(string name);
		SymbolInfo *lookup(string name);
		ScopeTable *getParentScope();
		int getHashPos(string name);
		int getChainPos(string name);
		~ScopeTable();
};

ScopeTable::~ScopeTable(){
	delete this->hash;
}

int ScopeTable::getHashPos(string name){
	return this->hash->getHashPos(name);
}

int ScopeTable::getChainPos(string name){
	return this->hash->getChainPos(name);
}

ScopeTable *ScopeTable::getParentScope(){
	return this->parentScope;
}

string ScopeTable::getId(){
	return this->id;
}

int ScopeTable::getNChildScopes(){
	return this->nChildScopes;
}

void ScopeTable::incrementNChild(){
	this->nChildScopes+=1;
}

string ScopeTable::getNChildScopesString(){
	string result;  
	ostringstream convert;   
	convert << this->nChildScopes; 
	result = convert.str();
	return result;
}


ScopeTable::ScopeTable(int size,ScopeTable *parentScope){
	this->hash=new Hash(size);
	this->nChildScopes=0;
	this->parentScope=parentScope;
	this->parentScope->incrementNChild();
	this->id=parentScope->getId()+"."+this->parentScope->getNChildScopesString();
}

ScopeTable::ScopeTable(int size){
	this->hash=new Hash(size);
	this->nChildScopes=0;
	this->parentScope=NULL;
	this->id="1";
}

string ScopeTable::print(){
	printStream.str("");
	printStream<<"ScopeTable# "<<this->id<<endl<<this->hash->print();
	return printStream.str();
}

bool ScopeTable::insertSymbol(SymbolInfo *symbol){
	return this->hash->insertItem(symbol);
}

bool ScopeTable::deleteSymbol(string name){
	return this->hash->deleteItem(name);
}

SymbolInfo *ScopeTable::lookup(string name){
	return this->hash->findItemByName(name);
}

#endif
