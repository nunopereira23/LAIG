:- use_module(library(random)).
:- consult(pieces).
:- consult(boardManipulation).

/*
	Evaluation criteria:
	- Advance/Retreat of the King
	- Number of enemy Pieces attacked (increases Score)
	- Number of enemy Pieces attacking own Pieces (reduces Score)
*/

/*
	Calculates the plays the computer can make.
*/
getPlays(Color, Board, Plays) :-
	entireBoardPlays(Color, Board, Board, 1, 1),
	setof(Play,playWrapper(Play),Plays),
	retractall(playWrapper(Play)).

/*
	Asserts each valid Play with playWrapper(Play) for the entire Board.
*/
entireBoardPlays(_,_,[],_,_).
entireBoardPlays(Color,Board,[A|B],Row,Col):-
	entireLinePlays(Color,Board,A,Row,Col),
	NewRow is Row + 1,
	Col is 1,
	entireBoardPlays(Color,Board,B,NewRow,Col).

/*
	Asserts each Play in a given list with playWrapper(Play), adding Piece to each Play's first element.
*/
assertPlays([], _).
assertPlays([[Col, Row, ColDest, RowDest] | Rest], Piece) :-
	assert(playWrapper([Piece, Col, Row, ColDest, RowDest])),
	assertPlays(Rest, Piece).

/*
	Asserts each valid Play with playWrapper(Play) for one line.
	Used by entireBoardPlays for each line.
*/
entireLinePlays(_,_Board,[],_,_).
entireLinePlays(Color,Board,[A|B],Row,Col):-
	(A \= '  ',
	isPieceOfColor(A,Color),
	(setof([Col, Row, ColDest, RowDest],checkLegal(Color,Board,Col,Row,ColDest,RowDest),[H|T]),
	assertPlays([H|T], A) ; true),
	NewCol is Col + 1,
	entireLinePlays(Color,Board,B,Row,NewCol)) ;
	(NewCol is Col + 1,
	entireLinePlays(Color,Board,B,Row,NewCol)).

/*
	Randomly picks a Play from a list of Plays.
*/
pickPlay(1, _, _, Plays, Play) :-
	random_member(Play, Plays).

/*
	Picks a play from a list of Plays according to our evaluation algorithm.
*/
pickPlay(2, Color, Board, Plays, Play) :-
	evaluatePlays(Color, Board, Plays, PlaysEvaluated),
	pickBestEvaluated(PlaysEvaluated, _, Play).
	
/*
	Picks the Play with the highest evaluated Score.
*/
pickBestEvaluated([], InitScore, _) :-
	InitScore is -9999.
pickBestEvaluated([[Piece, Row_Start, Col_Start, Row_Dest, Col_Dest, Score] | Rest], BestScore, Play) :-
	pickBestEvaluated(Rest, PrevScore, PrevPlay),
	ite(Score > PrevScore,
		(Play = [Piece, Row_Start, Col_Start, Row_Dest, Col_Dest],
			BestScore is Score),
		(BestScore is PrevScore,
			Play = PrevPlay)).


/**
 * Evaluates a Piece taking into account the enemy Pieces in a given line, outputting LineScore.
 * If AttDef == attack, LineScore is the number of enemy Pieces each own Piece can attack.
 * Else, LineScore is the negative of the number of enemy Pieces that can attack each own Piece.
 */
evalPieceLine(_, _, _, Col, _, _, _, InitScore, _) :-
	Col > 8,
	InitScore is 0.

evalPieceLine(Color, Board, Row, Col, Cell, CellRow, CellCol, LineScore, AttDef) :-
	Col < 9,
	NewCol is Col + 1,
	evalPieceLine(Color, Board, Row, NewCol, Cell, CellRow, CellCol, RestScore, AttDef),
	getPiece(Board, Row, Col, Piece),
	ite(Color == w, OppositeColor = b, OppositeColor = w),
	((Piece \= '  ',
	ite(AttDef == attack,
		(checkLegal(Color, Board, CellCol, CellRow, Col, Row),
			LineScore is RestScore + 1),
		(isPieceOfColor(Cell, Color),
			checkLegal(OppositeColor, Board, Col, Row, CellCol, CellRow),
			LineScore is RestScore - 1))) ;
	LineScore is RestScore).


/**
 * Given a Piece in a Board, this iterates the Board to sum the scores between the Piece and the iterated Pieces.
 * This is used by evaluatePieces, its wrapper.
 */
evaluatePiecesIn(_, _, Row, _, _, _, InitScore, _) :-
	Row > 8,
	InitScore is 0.

evaluatePiecesIn(Color, Board, Row, Cell, CellRow, CellCol, AttackScore, AttDef) :-
	Row < 9,
	evalPieceLine(Color, Board, Row, 1, Cell, CellRow, CellCol, LineScore, AttDef),
	NewRow is Row + 1,
	evaluatePiecesIn(Color, Board, NewRow, Cell, CellRow, CellCol, RestScore, AttDef),
	AttackScore is LineScore + RestScore.


/**
 * Wrapper for evaluatePiecesIn. This is used by evaluateCell for each attack and defense scores of a cell.
 */
evaluatePieces(Color, Board, Cell, CellRow, CellCol, AttackScore, AttDef) :-
	evaluatePiecesIn(Color, Board, 1, Cell, CellRow, CellCol, AttackScore, AttDef).


/**
 * Outputs CellScore for a given cell. This is used by evaluateLine for each cell in a line.
 * It calls evaluatePieces to get both the attack and defense scores, outputting their sum.
 */
evaluateCell(Color, Board, Cell, Row, Col, CellScore) :-
	evaluatePieces(Color, Board, Cell, Row, Col, AttackScore, attack),
	evaluatePieces(Color, Board, Cell, Row, Col, DefenseScore, defense),
	CellScore is AttackScore + DefenseScore.


/**
 * Outputs LineScore for a given line. This is used by evaluateBoard for each line.
 */
evaluateLine(_, _, [], _, _, InitScore) :-
	InitScore is 0.

evaluateLine(Color, Board, [FirstCell | Rest], Row, Col, LineScore) :-
	NewCol is Col + 1,
	evaluateLine(Color, Board, Rest, Row, NewCol, RestScore),
	evaluateCell(Color, Board, FirstCell, Row, Col, CellScore),
	LineScore is RestScore + CellScore.


/*
	Outputs a Score for a given Board. This is used to evaluate a Play.
*/
evaluateBoard(_, _, [], _, InitScore) :-
	InitScore is 0.

evaluateBoard(Color, Board, [FirstLine | Rest], Row, Score) :-
	NewRow is Row + 1,
	evaluateBoard(Color, Board, Rest, NewRow, RestScore),
	evaluateLine(Color, Board, FirstLine, Row, 1, LineScore),
	Score is RestScore + LineScore.

/*
	Changes the Play's score based on the King's movement.
	If the Play moves the King forward, the score is increased by 3, else if the King moves backwards it is decreased by 3.
*/
evaluateKingAdvance(Piece, Row_Start, Row_Dest, Score, RealScore) :-
	(isPieceOfType(Piece, 'K'),
	it(Row_Dest < Row_Start,
		RealScore is Score + 3),
	it(Row_Dest > Row_Start,
		RealScore is Score - 3),
	it(Row_Dest == Row_Start,
		RealScore is Score)
	) ;
	RealScore is Score.

/*
	Evaluate plays.
	Plays are given a score based on the new distance of the King to the top row,
	the number of attacking Pieces
	and the number of defending Pieces.
*/
evaluatePlays(_, _, [], []).
evaluatePlays(Color, Board, [[Piece, Col_Start, Row_Start, Col_Dest, Row_Dest] | RestPlays], [[Piece, Col_Start, Row_Start, Col_Dest, Row_Dest, RealScore] | RestPlaysEvaluated]) :-
	moveGeneral(Board, Col_Start, Row_Start, Col_Dest, Row_Dest, BoardAfterPlay),
	evaluateBoard(Color, BoardAfterPlay, BoardAfterPlay, 1, Score),
	evaluateKingAdvance(Piece, Row_Start, Row_Dest, Score, RealScore),
	evaluatePlays(Color, Board, RestPlays, RestPlaysEvaluated).

/*
	If-Then-Else.
*/
ite(If,Then,_Else) :-
  If,!,Then.

ite(_If,_Then,Else) :-
  Else.

/*
	If-Then.
*/
it(If,Then) :-
  If,!,Then.

it(_,_).
