debugBoard1([['  ','  ','  ','  ','  ','  ','  ','  '],
			['  ','  ','  ','  ','  ','  ','  ','  '],
			['  ','Kw','Kw','Kw','Kw','Kw','  ','Kw'],
			['Kw','Tb','Kw','Kb','Kw','  ','Bb','  '],
			['  ','Kw','Kw','Kw','Kw','Kw','  ','Kw'],
			['  ','  ','  ','  ','  ','  ','  ','  '],
			['Kb','  ','  ','Hb','Hw','Bw','Tw','  '],
			['Qb','Tb','Bb','Hb','Hw','Bw','Tw','Qw']]).

debugBoard2([
			['  ','  ','  ','  ','  ','  ','  ','  '],%1
			['  ','  ','  ','  ','  ','  ','  ','  '],%2
			['  ','  ','  ','  ','  ','  ','  ','  '],%3
			['  ','  ','  ','  ','  ','  ','  ','  '],%4
			['  ','  ','  ','  ','  ','  ','  ','  '],%5
			['  ','  ','  ','  ','  ','  ','  ','Kw'],%6
			['Kb','Tb','Bb','Hb','Hw','Bw','Tw','  '],%7
			['Qb','Tb','Bb','Hb','Hw','Bw','Tw','Qw']]).%8
				%1   %2   %3   %4   %5   %6   %7   %8

debugBoard3([
			['Qb','  ','  ','  ','  ','  ','  ','  '],%1
			['  ','  ','  ','  ','  ','  ','  ','  '],%2
			['  ','Kb','Hb','  ','  ','  ','  ','  '],%3
			['  ','  ','  ','  ','  ','  ','  ','  '],%4
			['  ','  ','  ','  ','Kw','  ','  ','  '],%5
			['  ','  ','  ','  ','  ','  ','  ','  '],%6
			['  ','  ','  ','  ','Hw','  ','Tw','  '],%7
			['  ','  ','  ','  ','Hw','Bw','Tw','Qw']]). %8

debugBoard4([
			['  ','Tw','  ','  ','  ','  ','  ','  '],%1
			['  ','  ','  ','  ','  ','  ','  ','  '],%2
			['  ','  ','  ','  ','  ','  ','  ','  '],%3
			['  ','  ','  ','  ','  ','  ','  ','  '],%4
			['  ','  ','  ','  ','Kw','  ','  ','  '],%5
			['  ','  ','Tb','  ','  ','  ','  ','  '],%6
			['  ','  ','Tw','  ','  ','  ','  ','  '],%7
			['Kb','  ','  ','  ','  ','  ','  ','  ']]).

/*
	Initial Board

	Tabuleiro inicial
*/
board([['  ','  ','  ','  ','  ','  ','  ','  '],
     ['  ','  ','  ','  ','  ','  ','  ','  '],
     ['  ','  ','  ','  ','  ','  ','  ','  '],
     ['  ','  ','  ','  ','  ','  ','  ','  '],
     ['  ','  ','  ','  ','  ','  ','  ','  '],
     ['  ','  ','  ','  ','  ','  ','  ','  '],
     ['Kb','Tb','Bb','Hb','Hw','Bw','Tw','Kw'],
     ['Qb','Tb','Bb','Hb','Hw','Bw','Tw','Qw']]).

/*
	Shows the board in the screen.
*/
 printGame(Board) :-
    printColumnNumbers,
 	printLineUnderscores,
 	write('\n'),
 	printBoard(Board,1).

/**
 * Prints the Board.
 */
printBoard([],_).
printBoard([A|B],N) :-
	write('|'),
	printLine(A),
	write(N),nl,
	printLineUnderscores,nl,
	Next is N + 1,
	printBoard(B,Next).

/**
 * Prints each line of the Board. Used by printBoard for each line.
 */
printLine([]).
printLine([A|B]) :-
	write(A),
	write('|'),
	printLine(B).

/**
 * Prints a line of underscores.
 */
printLineUnderscores :-
	write(' __ __ __ __ __ __ __ __').

/**
 * Prints a line of numbers to identify the columns.
 */
printColumnNumbers :-
	write(' 1  2  3  4  5  6  7  8'),nl.

/**
 * Clears the screen.
 */
clr:- write('\33\[2J').
