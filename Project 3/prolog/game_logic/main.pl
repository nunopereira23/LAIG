:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(system)).


:- consult(aIPlays).
:- consult(noPiecesInTrajectory).
:- consult(checkKing).
:- consult(checkMovement).
:- consult(boardManipulation).
:- consult(displayBoard).
:- consult(pieces).
:- consult(move).
:- consult(checkLegal).

/* Xb - Black X */
/* Xw - White X */
/* K - King */
/* Q - Queen */
/* T - Tower */
/* H - Horse */
/* B - Bishop */

/**
 * Used to test various predicates.
 */
debugChecks(X) :-
	bishopChecksKingRightUp(w, X, '  ', 7, 4),
	bishopChecksKingRightDown(w, X, '  ', 7, 4),
	bishopChecksKingLeftUp(w, X, '  ', 7, 4),
	bishopChecksKingLeftDown(w, X, '  ', 7, 4),
	bishopChecksKing(w, X, 7, 4),
	%format("Bishop checks king: success.\n", []),
	towerChecksKingUp(w, X, '  ', 2, 4),
	towerChecksKingDown(w, X, '  ', 2, 4),
	towerChecksKingLeft(w, X, '  ', 2, 4),
	towerChecksKingRight(w, X, '  ', 2, 4),
	towerChecksKing(w, X, 2, 4),
	%format("Tower checks king: success.\n", []),
	queenChecksKing(w, X, 4, 4),
	%format("Queen checks king: success.\n", []),
	kingChecksKing(w, X, 4, 4).
	%format("King checks king: success.\n", []).

/**
 * Game's point of entry.
 */
start :-
	now(X),
	setrand(X),
	clr,
	write('--------------------------------------------'),nl,
	write('|            Corrida de Reis               |'),nl,
	write('--------------------------------------------'),nl,
	write('Game mode:'),nl,
	write('1. Single player'),nl,
	write('2. Multiplayer'),nl,
	write('3. PC vs PC'),nl,
	readMenuChoice(Option),
	write(Option),
	nextMenu(Option).


/**
 * Difficulty menu for singleplayer mode.
 */
nextMenu(1) :-
	nl,
	write('Difficulty:'),nl,
	write('1.Easy'),nl,
	write('2.Hard'),nl,
	readDiffChoice(Option),
	clr,
	corridaReis(single,Option).

/**
 * Called by multiplayer option. There's no menu here.
 */
nextMenu(2) :-
	clr,
	corridaReis(multi).

/**
 * Difficulty menu for PC vs PC mode.
 */
nextMenu(3) :-
	nl,
	write('Difficulty:'),nl,
	write('1.Easy'),nl,
	write('2.Hard'),nl,
	readDiffChoice(Option),
	clr,
	corridaReis(npc,Option).

/**
 * Reads Main Menu option, verifying it is valid.
 */
readMenuChoice(Option) :-
	leInteiro('Choose a number between 1 and 3:\n',Option),
	Option > 0,
	Option < 4.

/**
 * Reads Difficulty Menu option, verifying it is valid.
 */
readDiffChoice(Option) :-
	leInteiro('Choose a number between 1 and 2:\n',Option),
	Option > 0,
	Option < 3.


/**
 * Game predicate past the menus used for debugging purposes.
 */
corridaReis(debug) :-
	debugBoard4(Y),
	%getPlays(w, Y, Plays),
	evaluateBoard(b, Y, Y, 1, Score, 8),
	%evaluatePieces(b, Y, 'Tb', 6, 3, Score, defend),
 	%evalAttackPieceLine(w, Y, Y, 6, 1, 'Tw', 7, 3, Score),
	format("~d", [Score]).

/*
	Initializes the game according to the chosen Mode.
	There are 3 possible modes:
	 1) multi - player vs player
	 2) single - player vs computer
	 3) npc - computer vs computer
*/
corridaReis(Mode, Difficulty) :- board(X), game(Mode, X, Difficulty).
corridaReis(Mode) :- board(X), game(Mode, X).

game(_, Board,_) :-
	printGame(Board),
	isDraw(Board) , write('Draw.').

game(_, Board,_) :-
	win(b, Board) , write('Blacks win.').

game(_, Board,_) :-
	win(w, Board) , write('Whites win.').



game(_, Board) :-
	printGame(Board),
	isDraw(Board) , write('Draw.').

game(_, Board) :-
	win(b, Board) , write('Blacks win.').

game(_, Board) :-
	win(w, Board) , write('Whites win.').

/**
 * Game cycle in multiplayer mode.
 */
game(multi, Board) :-
	moveUser(w, Board, MidBoard),
	printGame(MidBoard),
	moveUser(b, MidBoard, NewBoard),
	game(multi, NewBoard).

/**
 * Game cycle in singleplayer mode. The Player is represented by the white Pieces.
 */
game(single, Board, Difficulty) :-
	moveUser(w, Board, MidBoard),
	printGame(MidBoard),
	moveNPC(b, Difficulty, MidBoard, NewBoard),
	game(single, NewBoard, Difficulty).

/**
 * Game cycle in PC vs PC mode.
 */
game(npc,Board,Difficulty) :-
	moveNPC(w,Difficulty,Board,MidBoard),
	printGame(MidBoard),
	moveNPC(b,Difficulty,MidBoard,NewBoard),
	game(npc,NewBoard,Difficulty).

/**
 * Check if the game ended with a draw.
 */
isDraw(Board) :- win(w, Board) , win(b, Board).

/*
	Checks if White won the game.
*/
win(w, [A|_]) :- member('Kw', A).

/*
	Checks if Black won the game.
*/
win(b, [A|_]) :- member('Kb', A).

/*
	Calculates and executes the computer's movement.
	After White's/Black's turn appears on the screen,
	the program waits for any user input in order to help visualize	what was the move executed previously.
*/
moveNPC(Color, Difficulty, Board, NewBoard) :-
	ite(Color=='w' , write('White'),write('Black')),
	write('\'s turn\n'),
	write('Please press enter to see the chosen play.\n'),
	get_char(_Char),
	moveNPC_Logic(Color, Difficulty, Board, NewBoard, _).

moveNPC_Logic(Color, Difficulty, Board, NewBoard, Play) :-
	getPlays(Color, Board, Plays),
	pickPlay(Difficulty, Color, Board, Plays, Play),
	executePlay(Play, Board, NewBoard).

/*
	Executes the user's Movement.
*/
moveUser(Color, Board, NewBoard) :-
	ite(Color=='w' , write('White'),write('Black')),
	write('\'s turn\n'),
	getPosition(Row_Start,Col_Start,Row_Dest,Col_Dest),
	move(Color, Board, Col_Start, Row_Start, Col_Dest, Row_Dest, NewBoard).

/**
 * Checks if the movement chosen by the user can be executed, executing it if so.
 * It checks if the Player is moving one of his own Pieces and if the movement is legal.
 */
move(Color, Board, Col_Start, Row_Start, Col_Dest, Row_Dest, NewBoard) :-
	checkColor(Color, Board, Col_Start, Row_Start),
	checkLegal(Color, Board, Col_Start, Row_Start, Col_Dest, Row_Dest),
	moveGeneral(Board, Col_Start, Row_Start, Col_Dest, Row_Dest, NewBoard).

/**
 * Checks if the color of the Piece in the given coordinates is of the given IntendedColor.
*/
checkColor(IntendedColor, Board, Col_Start, Row_Start) :-
	getPiece(Board, Row_Start, Col_Start, Piece),
	isPieceOfColor(Piece, IntendedColor).

/*
	Executes the computer's movement.
*/
executePlay([_, Col_Start, Row_Start, Col_Dest, Row_Dest], Board, NewBoard) :-
	format("Move (Column, Row): (~d, ~d) -> (~d, ~d)\n", [Col_Start, Row_Start, Col_Dest, Row_Dest]),
	moveGeneral(Board, Col_Start, Row_Start, Col_Dest, Row_Dest, NewBoard).

/**
 * Read the coordinates selected by the user.
 */
le(Frase) :-
  get_code(Ch),
  leTodosOsChars(Ch,ListaCarateres),
  name(Frase,ListaCarateres).

/**
 * Reads into a list the characters input by the user until it detects a newline.
 * The newline isn't added to the list.
 */
leTodosOsChars(10,[]).
leTodosOsChars(13,[]).
leTodosOsChars(Ch,[Ch|MaisChars]) :-
  get_code(NovoChar),
  leTodosOsChars(NovoChar,MaisChars).

/**
 * Reads in a number from the user, asking again if it isn't.
 */
leInteiro(Prompt,Inteiro) :-
  repeat,
    write(Prompt),
    once(le(Inteiro)),
    number(Inteiro).

/**
 * Reads in the Play from the user, checking if the input is valid.
 * If the input is invalid, it asks the user to repeat.
 */
getPosition(Row_Start,Col_Start,Row_Dest,Col_Dest):-
		repeat,
			once(leInteiro('Start column: ',Col_Start)),
			once(leInteiro('Start row: ',Row_Start)),
			once(leInteiro('Final column: ',Col_Dest)),
			once(leInteiro('Final row: ',Row_Dest)),
			Col_Start < 9,
			Row_Start < 9,
			Col_Dest < 9,
			Row_Dest < 9,
			Col_Start > 0,
			Row_Start > 0,
			Col_Dest > 0,
			Row_Dest > 0.

not(X) :-
	X,!,fail.

not(_X).
