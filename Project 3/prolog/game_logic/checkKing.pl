:- consult(boardManipulation).
:- consult(pieces).

/*
	Checks if the horse is going to a position where it could check the king.
*/
horseChecksKing(OppositeColor, Board, Col, Row) :-
	(KingRow is Row - 2, KingCol is Col - 1, getPiece(Board, KingRow, KingCol, Piece) , isPieceOfType(Piece, 'K') , isPieceOfColor(Piece, OppositeColor));
	(KingRow is Row - 2, KingCol is Col + 1, getPiece(Board, KingRow, KingCol, Piece) , isPieceOfType(Piece, 'K') , isPieceOfColor(Piece, OppositeColor));
	(KingRow is Row - 1, KingCol is Col - 2, getPiece(Board, KingRow, KingCol, Piece) , isPieceOfType(Piece, 'K') , isPieceOfColor(Piece, OppositeColor));
	(KingRow is Row - 1, KingCol is Col + 2, getPiece(Board, KingRow, KingCol, Piece) , isPieceOfType(Piece, 'K') , isPieceOfColor(Piece, OppositeColor));
	(KingRow is Row + 1, KingCol is Col - 2, getPiece(Board, KingRow, KingCol, Piece) , isPieceOfType(Piece, 'K') , isPieceOfColor(Piece, OppositeColor));
	(KingRow is Row + 1, KingCol is Col + 2, getPiece(Board, KingRow, KingCol, Piece) , isPieceOfType(Piece, 'K') , isPieceOfColor(Piece, OppositeColor));
	(KingRow is Row + 2, KingCol is Col - 1, getPiece(Board, KingRow, KingCol, Piece) , isPieceOfType(Piece, 'K') , isPieceOfColor(Piece, OppositeColor));
	(KingRow is Row + 2, KingCol is Col + 1, getPiece(Board, KingRow, KingCol, Piece) , isPieceOfType(Piece, 'K') , isPieceOfColor(Piece, OppositeColor)).

/**
 * Auxiliary for bishopChecksKing, verifying the right-up movement.
 */
bishopChecksKingRightUp(b, _Board, 'Kb', _Col, _Row).
bishopChecksKingRightUp(w, _Board, 'Kw', _Col, _Row).
bishopChecksKingRightUp(OppositeColor, Board, CurrentPiece, Col, Row) :-
	CurrentPiece == '  ', Col < 9, Row > 0,
	NewCol is Col + 1, NewRow is Row - 1,
	getPiece(Board, NewRow, NewCol, NextPiece),
	bishopChecksKingRightUp(OppositeColor, Board, NextPiece, NewCol, NewRow).

/**
 * Auxiliary for bishopChecksKing, verifying the right-down movement.
 */
bishopChecksKingRightDown(b, _Board, 'Kb', _Col, _Row).
bishopChecksKingRightDown(w, _Board, 'Kw', _Col, _Row).
bishopChecksKingRightDown(OppositeColor, Board, CurrentPiece, Col, Row) :-
	CurrentPiece == '  ', Col < 9, Row < 9,
	NewCol is Col + 1, NewRow is Row + 1,
	getPiece(Board, NewRow, NewCol, NextPiece),
	bishopChecksKingRightDown(OppositeColor, Board, NextPiece, NewCol, NewRow).

/**
 * Auxiliary for bishopChecksKing, verifying the left-up movement.
 */
bishopChecksKingLeftUp(b, _Board, 'Kb', _Col, _Row).
bishopChecksKingLeftUp(w, _Board, 'Kw', _Col, _Row).
bishopChecksKingLeftUp(OppositeColor, Board, CurrentPiece, Col, Row) :-
	CurrentPiece == '  ', Col > 0, Row > 0,
	NewCol is Col - 1, NewRow is Row - 1,
	getPiece(Board, NewRow, NewCol, NextPiece),
	bishopChecksKingLeftUp(OppositeColor, Board, NextPiece, NewCol, NewRow).

/**
 * Auxiliary for bishopChecksKing, verifying the left-down movement.
 */
bishopChecksKingLeftDown(b, _Board, 'Kb', _Col, _Row).
bishopChecksKingLeftDown(w, _Board, 'Kw', _Col, _Row).
bishopChecksKingLeftDown(OppositeColor, Board, CurrentPiece, Col, Row) :-
	CurrentPiece == '  ', Col > 0, Row < 9,
	NewCol is Col - 1, NewRow is Row + 1,
	getPiece(Board, NewRow, NewCol, NextPiece),
	bishopChecksKingLeftUp(OppositeColor, Board, NextPiece, NewCol, NewRow).

/**
 * Checks if the Bishop at the given coordinates checks the King.
 */
bishopChecksKing(OppositeColor, Board, Col, Row) :-
	bishopChecksKingRightUp(OppositeColor, Board, '  ', Col, Row) ;
	bishopChecksKingRightDown(OppositeColor, Board, '  ', Col, Row) ;
	bishopChecksKingLeftUp(OppositeColor, Board, '  ', Col, Row) ;
	bishopChecksKingLeftDown(OppositeColor, Board, '  ', Col, Row).

/**
 * Auxiliary for towerChecksKing, verifying the upwards movement.
 */
towerChecksKingUp(b, _Board, 'Kb', _Col, _Row).
towerChecksKingUp(w, _Board, 'Kw', _Col, _Row).
towerChecksKingUp(OppositeColor, Board, CurrentPiece, Col, Row) :-
	CurrentPiece == '  ', Row > 0,
	NewRow is Row - 1,
	getPiece(Board, NewRow, Col, NextPiece),
	towerChecksKingUp(OppositeColor, Board, NextPiece, Col, NewRow).

/**
 * Auxiliary for towerChecksKing, verifying the downwards movement.
 */
towerChecksKingDown(b, _Board, 'Kb', _Col, _Row).
towerChecksKingDown(w, _Board, 'Kw', _Col, _Row).
towerChecksKingDown(OppositeColor, Board, CurrentPiece, Col, Row) :-
	CurrentPiece == '  ', Row < 9,
	NewRow is Row + 1,
	getPiece(Board, NewRow, Col, NextPiece),
	towerChecksKingDown(OppositeColor, Board, NextPiece, Col, NewRow).

/**
 * Auxiliary for towerChecksKing, verifying the left movement.
 */
towerChecksKingLeft(b, _Board, 'Kb', _Col, _Row).
towerChecksKingLeft(w, _Board, 'Kw', _Col, _Row).
towerChecksKingLeft(OppositeColor, Board, CurrentPiece, Col, Row) :-
	CurrentPiece == '  ', Col > 0,
	NewCol is Col - 1,
	getPiece(Board, Row, NewCol, NextPiece),
	towerChecksKingLeft(OppositeColor, Board, NextPiece, NewCol, Row).

/**
 * Auxiliary for towerChecksKing, verifying the right movement.
 */
towerChecksKingRight(b, _Board, 'Kb', _Col, _Row).
towerChecksKingRight(w, _Board, 'Kw', _Col, _Row).
towerChecksKingRight(OppositeColor, Board, CurrentPiece, Col, Row) :-
	CurrentPiece == '  ', Col > 0,
	NewCol is Col + 1,
	getPiece(Board, Row, NewCol, NextPiece),
	towerChecksKingRight(OppositeColor, Board, NextPiece, NewCol, Row).

/**
 * Checks if the Tower at the given coordinates checks the King.
 */
towerChecksKing(OppositeColor, Board, Col, Row) :-
	towerChecksKingUp(OppositeColor, Board, '  ', Col, Row) ;
	towerChecksKingDown(OppositeColor, Board, '  ', Col, Row) ;
	towerChecksKingLeft(OppositeColor, Board, '  ', Col, Row) ;
	towerChecksKingRight(OppositeColor, Board, '  ', Col, Row).

/**
 * Checks if the Queen at the given coordinates checks the King.
 */
queenChecksKing(OppositeColor, Board, Col, Row) :-
	towerChecksKing(OppositeColor, Board, Col, Row) ;
	bishopChecksKing(OppositeColor, Board, Col, Row).


/**
 * Checks if the King at the given coordinates checks the opponent's King.
 */
kingChecksKing(OppositeColor, Board, Col, Row) :-
	(KingRow is Row - 1, KingCol is Col - 1, getPiece(Board, KingRow, KingCol, Piece) , isPieceOfType(Piece, 'K') , isPieceOfColor(Piece, OppositeColor));
	(KingRow is Row - 1, KingCol is Col, getPiece(Board, KingRow, KingCol, Piece) , isPieceOfType(Piece, 'K') , isPieceOfColor(Piece, OppositeColor));
	(KingRow is Row - 1, KingCol is Col + 1, getPiece(Board, KingRow, KingCol, Piece) , isPieceOfType(Piece, 'K') , isPieceOfColor(Piece, OppositeColor));
	(KingRow is Row, KingCol is Col - 1, getPiece(Board, KingRow, KingCol, Piece) , isPieceOfType(Piece, 'K') , isPieceOfColor(Piece, OppositeColor));
	(KingRow is Row, KingCol is Col + 1, getPiece(Board, KingRow, KingCol, Piece) , isPieceOfType(Piece, 'K') , isPieceOfColor(Piece, OppositeColor));
	(KingRow is Row + 1, KingCol is Col - 1, getPiece(Board, KingRow, KingCol, Piece) , isPieceOfType(Piece, 'K') , isPieceOfColor(Piece, OppositeColor));
	(KingRow is Row + 1, KingCol is Col, getPiece(Board, KingRow, KingCol, Piece) , isPieceOfType(Piece, 'K') , isPieceOfColor(Piece, OppositeColor));
	(KingRow is Row + 1, KingCol is Col + 1, getPiece(Board, KingRow, KingCol, Piece) , isPieceOfType(Piece, 'K') , isPieceOfColor(Piece, OppositeColor)).


/**
 * Checks if any Piece in the Board checks the King. Row and Col must be 1.
 * This is used to check if any Piece checks the King after a movement, to verify its legality.
 */
entireBoardCheck(_Board, [], _, _).
entireBoardCheck(Board, [A|B], Row, Col) :-
	entireLineCheck(Board, A, Row, Col),
	NewRow is Row + 1,
	Col is 1,
	entireBoardCheck(Board, B, NewRow, Col).

/**
 * Checks if any Piece in a given line checks the King.
 * This is used by entireBoardCheck for each line.
 */
entireLineCheck(_Board,[],_,_).
entireLineCheck(Board,[A|B],Row,Col) :-
	not((
	(isPieceOfType(A, 'H') , ( (isPieceOfColor(A,w) , horseChecksKing(b, Board, Col, Row)) ; (isPieceOfColor(A,b) , horseChecksKing(w,Board,Col,Row))));
	(isPieceOfType(A, 'B') , ( (isPieceOfColor(A,w) , bishopChecksKing(b, Board, Col, Row)) ; (isPieceOfColor(A,b) , bishopChecksKing(w,Board,Col,Row))));
	(isPieceOfType(A, 'T') , ( (isPieceOfColor(A,w) , towerChecksKing(b, Board, Col, Row)) ; (isPieceOfColor(A,b) , towerChecksKing(w,Board,Col,Row))));
	(isPieceOfType(A, 'Q') , ( (isPieceOfColor(A,w) , queenChecksKing(b, Board, Col, Row)) ; (isPieceOfColor(A,b) , queenChecksKing(w,Board,Col,Row))));
	(isPieceOfType(A, 'K') , ( (isPieceOfColor(A,w) , kingChecksKing(b, Board, Col, Row)) ; (isPieceOfColor(A,b) , kingChecksKing(w,Board,Col,Row))))
	)),
	NewCol is Col + 1,
	entireLineCheck(Board,B,Row,NewCol).
