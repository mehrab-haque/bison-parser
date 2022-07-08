#ifndef HASH_H
#define HASH_H

#include "1805001_SymbolInfo.h"
#include <cstdlib>
#include <sstream>

class Hash{
	int size;
	SymbolInfo **items;
	stringstream printStream;
	
	unsigned long hashFunction(string name);
	bool exists(string name);
	
	public:
		Hash(int size);
		bool insertItem(SymbolInfo *item);
		bool deleteItem(string name);
		SymbolInfo *findItemByName(string name);
		int getHashPos(string name);
		int getChainPos(string name);
		string print();
		~Hash();
};


Hash::~Hash(){
	for(int i=0;i<size;i++){
		SymbolInfo *currSymbol=items[i];
		while(currSymbol!=NULL){
			SymbolInfo *tmpSymbol=currSymbol;
			currSymbol=currSymbol->getNextSymbol();
			delete tmpSymbol;
		}
	}
	free(items);
}



int Hash::getHashPos(string name){
	return this->hashFunction(name);
}

int Hash::getChainPos(string name){
	int index= this->hashFunction(name);
	int serial=0;
	SymbolInfo *currSymbol=items[index];
	while(currSymbol!=NULL){
		if(currSymbol->getName().compare(name)==0)
			break;
		serial++;
		currSymbol=currSymbol->getNextSymbol();
	}
	return serial;
}

Hash::Hash(int size){
	this->size=size;
	this->items=(SymbolInfo**)malloc(sizeof(SymbolInfo*)*size);
	for(int i=0;i<size;i++)
		this->items[i]=NULL;
}

SymbolInfo *Hash::findItemByName(string name){
	int index=(int)this->hashFunction(name);
	if(this->items[index]==NULL)return NULL;
	SymbolInfo *currSymbol=this->items[index];
	bool isFound=false;
	while(currSymbol!=NULL){
		if(currSymbol->getName().compare(name)==0){
			isFound=true;
			break;
		}
		currSymbol=currSymbol->getNextSymbol();
	}
	return currSymbol;
}


unsigned long Hash::hashFunction(string s){
    unsigned long hash = 0;
    for(int i=0;i<s.size();i++)
    	hash = s[i] + (hash << 6) + (hash << 16) - hash;       
    return hash%this->size;
}



bool Hash::exists(string name){
	int index=this->hashFunction(name);
	if(this->items[index]==NULL)return false;
	SymbolInfo *currSymbol=this->items[index];
	bool isFound=false;
	while(currSymbol!=NULL){
		if(currSymbol->getName().compare(name)==0){
			isFound=true;
			break;
		}
		currSymbol=currSymbol->getNextSymbol();
	}
	return isFound;
}

bool Hash::deleteItem(string name){
	if(!exists(name))return false;
	int index=this->hashFunction(name);
	SymbolInfo *prevSymbol=items[index];
	SymbolInfo *currSymbol=items[index];
	
	while(currSymbol->getName().compare(name)!=0){
		prevSymbol=currSymbol;
		currSymbol=currSymbol->getNextSymbol();
	}
	
	if(prevSymbol==currSymbol)
		items[index]=currSymbol->getNextSymbol();
	else
		prevSymbol->setNextSymbol(currSymbol->getNextSymbol());
	
	delete currSymbol;

	return true;
}

bool Hash::insertItem(SymbolInfo *item){
	if(exists(item->getName()))return false;
	int index=this->hashFunction(item->getName());
	if(this->items[index]==NULL)
		items[index]=item;
	else{
		SymbolInfo *currSymbol=items[index];
		while(currSymbol->getNextSymbol()!=NULL)
			currSymbol=currSymbol->getNextSymbol();
		currSymbol->setNextSymbol(item);
	}	
	return true;
}

string Hash::print(){
	printStream.str("");
	for(int i=0;i<this->size;i++){
		printStream<<i<<" --> ";
		SymbolInfo *currSymbol=this->items[i];
		while(currSymbol!=NULL){
			printStream<<"< "<<currSymbol->getName()<<" : "<<currSymbol->getType()<<" >";
			currSymbol=currSymbol->getNextSymbol();
		}
		printStream<<endl;
	}
	printStream<<endl;
	return printStream.str();
}

#endif
