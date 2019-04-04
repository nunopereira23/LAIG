:- consult(boardManipulation).

/**
 * Executes the chosen movement, returning NewBoard.
 * NewBoard is the Board after applying the move.
 */
moveGeneral(Board, Col_Start, Row_Start, Col_Dest, Row_Dest, NewBoard) :-
	getPiece(Board, Row_Start, Col_Start, Piece) ,
	setPiece(Board, Row_Start, Col_Start, '  ', MidBoard) ,
	setPiece(MidBoard, Row_Dest, Col_Dest, Piece, NewBoard).
