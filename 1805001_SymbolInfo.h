#ifndef SYMBOLINFO_H
#define SYMBOLINFO_H

//Dependencies
#include<iostream>
#include <string>
#include<sstream>

using namespace std;

//Class Signatures

//This class represents a Symbol
class SymbolInfo{
	string name;
	string type;

	stringstream printStream;

	SymbolInfo *nextSymbol;
	public:
		SymbolInfo(string name,string type);
		void setName(string name);
		string getName();
		void setType(string type);
		string getType();
		void setNextSymbol(SymbolInfo *nextSymbol);
		SymbolInfo *getNextSymbol();
		string print();
		~SymbolInfo();	
};

#endif
