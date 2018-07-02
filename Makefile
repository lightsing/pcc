CC = gcc -g
LIBS = -ly -ll
LEX = flex
YACC = yacc

all: pcc

pcc: pcc.l pcc.y
	${LEX} pcc.l
	${YACC} -d pcc.y
	${CC} -o pcc y.tab.c lex.yy.c ${LIBS}


