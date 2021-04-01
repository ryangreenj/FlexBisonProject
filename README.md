HOW TO RUN:
	Need to have Flex and Bison installed
	
	Run the following commands:
	
	flex -l lexer.l
	bison -dv parser.y
	gcc -o progOut parser.tab.c lex.yy.c -lfl
	
	Run the parser using:
	./progOut