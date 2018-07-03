CC = gcc -g
LIBS = -ly -ll
LEX = flex
YACC = yacc
CFLAGS = -DYYDEBUG=1

all: pcc

pcc: pcc.l pcc.y
	${LEX} pcc.l
	${YACC} -d pcc.y
	${CC} ${CFLAGS} -o pcc y.tab.c lex.yy.c ${LIBS}
