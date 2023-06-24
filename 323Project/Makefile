# Variables to control Makefile operation
CXX = g++
YACC = yacc
LEX = lex

# Targets
all: program

program: lex.yy.c y.tab.c
	$(CXX) lex.yy.c y.tab.c -ll -o program

y.tab.c y.tab.h: program.y
	$(YACC) -d program.y

lex.yy.c: program.l y.tab.h
	$(LEX) program.l

clean: 
	rm -f lex.yy.c y.tab.c y.tab.h program



