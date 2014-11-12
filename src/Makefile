wsm-parser: wsm.h wsm.cpp wsm.lex.c wsm.tab.c main.cpp dct.cpp parser.cpp
	mkdir -p ../bin
	g++ -o ../bin/$@ -O3 -Wall -Wextra -pedantic -std=c++11 wsm.cpp wsm.lex.c wsm.tab.c main.cpp dct.cpp parser.cpp

wsm-irrths: wsm.h wsm.cpp wsm.lex.c wsm.tab.c main.cpp dct.cpp irrths.cpp
	mkdir -p ../bin
	g++ -o ../bin/$@ -O3 -Wall -Wextra -pedantic -std=c++11 wsm.cpp wsm.lex.c wsm.tab.c main.cpp dct.cpp irrths.cpp

wsm.lex.c: wsm.l
	flex -o wsm.lex.c wsm.l

wsm.tab.c: wsm.y
	bison -d wsm.y

clean:
	rm -f wsm.lex.c wsm.tab.h wsm.tab.c
