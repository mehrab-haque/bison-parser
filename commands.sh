g++ -c 1805001_SymbolInfo.cpp
yacc -d -y 1805001.y
g++ -w -c -o y.o y.tab.c
flex 1805001.l
g++ -w -c -o l.o lex.yy.c
g++ 1805001_SymbolInfo.o y.o l.o -lfl -o parser
./parser 1805001_input.txt
