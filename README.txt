# Exam 2

## Programming Languages and Translators 

##Autores: 	Luis Santiago Mille fregoso	A01169067
## 		Iván Gilberto Martin Enciso	A01169099

October 22, 2018 

-----------------------------------------------------------------------------------------------
Compiling and running Instructions

1. In order to compile the project it is only necessary to run the already made executable called "make" as such: ./make
This will execute the necessary commands to compile both the scanner (flex) and the parser(bison). 

NOTE: It is necessary that the 'make.c' file and the executable 'make' are in the same folder as the flex and bison files (.l and .y files) 

2. In order to run and test the program one must open a terminal in the same folder where the flex, the bison, and the make file are. Then in the terminal one should execute the compiler as: 
./exam2 < file.txt

NOTE: file.txt is the input file (change file.txt to the name and extension of the desired input file)

Possible files:

	- input_right.txt (File with correct output)
	- input_wrong.txt (File with declaration error)
	- input_wrong_types.txt (File with incompatible types error)

------------------------------------------------------------------------------------------------

Sample runs:

evidence.png: Shows compilations with the make file. Sample run using the three files as input. And some examples using the executable without input file (only with user input with the terminal) 
