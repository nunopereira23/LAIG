:- include('game_logic/main.pl').


% gameData(Board, Mode, Difficulty, NextToPlay).

initGame(Mode, Difficulty) :-
    retractall(gameData(_, _, _, _)),
    now(X),
	setrand(X),
    board(Board),
    assert(gameData(Board, Mode, Difficulty, w)).


getBoard(Board) :-
    gameData(Board, _, _, _).

getMode(Mode) :-
    gameData(_, Mode, _, _).

getDifficulty(Difficulty) :-
    gameData(_, _, Difficulty, _).

getNextToPlay(Next) :-
    gameData(_, _, _, Next).


/**
 * For bot movement in NPC vs NPC mode.
 */
makeBotPlay(npc, _, [Color, Col_Start, Row_Start, Col_Dest, Row_Dest]) :-
    gameData(Board, npc, Difficulty, Color),
    moveNPC_Logic(Color, Difficulty, Board, NewBoard, [_, Col_Start, Row_Start, Col_Dest, Row_Dest]),
    retractall(gameData(_, _, _, _)),
    ite(Color == w, NextColor = b, NextColor = w),
    assert(gameData(NewBoard, npc, Difficulty, NextColor)).

makeBotPlay(single, BotColor, [BotColor, Col_Start, Row_Start, Col_Dest, Row_Dest]) :-
    gameData(Board, single, Difficulty, BotColor),
    moveNPC_Logic(BotColor, Difficulty, Board, NewBoard, [_, Col_Start, Row_Start, Col_Dest, Row_Dest]),
    retractall(gameData(_, _, _, _)),
    ite(BotColor == w, NextColor = b, NextColor = w),
    assert(gameData(NewBoard, single, Difficulty, NextColor)).

/**
 * Color is the Player's color, to guarantee the Player doesn't move the bot's pieces.
 */
makePlayerPlay(single, Color, [Color, Col_Start, Row_Start, Col_Dest, Row_Dest]) :-
    gameData(Board, single, Difficulty, Color),
    move(Color, Board, Col_Start, Row_Start, Col_Dest, Row_Dest, NewBoard),
    retractall(gameData(_, _, _, _)),
    ite(Color == w, NextColor = b, NextColor = w),
    assert(gameData(NewBoard, single, Difficulty, NextColor)).

/**
 * Makes a player move. If the move cannot be made, it fails and the board isn't changed.
 */
makePlayerPlay(multi, _, [Color, Col_Start, Row_Start, Col_Dest, Row_Dest]) :-
    gameData(Board, multi, Difficulty, Color),
    move(Color, Board, Col_Start, Row_Start, Col_Dest, Row_Dest, NewBoard),
    retractall(gameData(_, _, _, _)),
    ite(Color == w, NextColor = b, NextColor = w),
    assert(gameData(NewBoard, multi, Difficulty, NextColor)).


/**
 * Meant to undo moves by playing their reverse. Bypasses legality checks.
 * Should never be used for regular moves as it may break the game flow.
 */
forceMove(NextColor, Col_Start, Row_Start, Col_Dest, Row_Dest) :-
    gameData(Board, Mode, Difficulty, _),
    moveGeneral(Board, Col_Start, Row_Start, Col_Dest, Row_Dest, NewBoard),
    retractall(gameData(_, _, _, _)),
    assert(gameData(NewBoard, Mode, Difficulty, NextColor)).

placePiece(Piece, Col, Row) :-
    gameData(Board, Mode, Difficulty, Color),
    setPiece(Board, Row, Col, Piece, NewBoard),
    retractall(gameData(_, _, _, _)),
    assert(gameData(NewBoard, Mode, Difficulty, Color)).


% IsDraw, WhiteWon, BlackWon.
gameIsOver(Board, 1, 0, 0) :-
    isDraw(Board), !.

gameIsOver(Board, 0, 1, 0) :-
    win(w, Board), !.

gameIsOver(Board, 0, 0, 1) :-
    win(b, Board), !.

gameIsOver(_, 0, 0, 0).

changePlayer(NewPlayerColor) :-
    gameData(Board, Mode, Difficulty, OldColor),
    ite(OldColor == w, NewPlayerColor = b, NewPlayerColor = w),
    retractall(gameData(_, _, _, _)),
    assert(gameData(Board, Mode, Difficulty, NewPlayerColor)).


freeGame :-
    retractall(gameData(_, _, _, _)).