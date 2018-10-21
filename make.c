#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>


int main()
{
	char line1[100], line2[100], line3[100];
	strcpy(line1,"flex exam2.l");
	strcpy(line2,"bison -d exam2.y");
	strcpy(line3,"gcc -o exam2 lex.yy.c exam2.tab.c -lfl"); // for bison: exam2.tab.c after lex
	printf("Executing: %s\n", line1);
	system(line1);
	printf("Executing: %s\n", line2);
	system(line2);
	printf("Executing: %s\n", line3);
	system(line3);
	return 0;

}
