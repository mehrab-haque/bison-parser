#ifndef SYMBOLINFO_H
#define SYMBOLINFO_H

//Dependencies
#include<iostream>
#include <string>
#include<sstream>
#include<vector>

using namespace std;

//Class Signatures

//This class represents a Symbol
class SymbolInfo{
	string name;
	string type;
	string variant;
	bool isFunc;

	vector<SymbolInfo*> childSymbols;


	stringstream printStream;

	SymbolInfo *nextSymbol;
	public:
		SymbolInfo(string name,string type);
		void setName(string name);
		vector<SymbolInfo*> getChildSymbols();
		string getName();
		void addChildSymbol(SymbolInfo *symbol);
		void setType(string type);
		string getType();
		void setNextSymbol(SymbolInfo *nextSymbol);
		SymbolInfo *getNextSymbol();
		string print();
		void setVariant(string s);
		string getVariant();
		void setFunction(bool b);
		bool isFunction();
		~SymbolInfo();	
};

#endif
