FLAG = -std=gnu11 -Werror -Wall
parser:	parser.c 
	cc ${FLAG} -o parser parser.c -g 