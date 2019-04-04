:- consult(pieces).
:- consult(boardManipulation).
:- consult(checkMovement).
:- consult(checkKing).
:- consult(noPiecesInTrajectory).


colY(1).
colY(2).
colY(3).
colY(4).
colY(5).
colY(6).
colY(7).
colY(8).

rowX(1).
rowX(2).
rowX(3).
rowX(4).
rowX(5).
rowX(6).
rowX(7).
rowX(8).

/**
 * Checks if the movement is legal.
 */
checkLegal(PieceColor, Board, Col_Start, Row_Start, Col_Dest, Row_Dest) :-
	rowX(Row_Dest),
	colY(Col_Dest),
	%ver se a peça no destino
	getPiece(Board,Row_Dest,Col_Dest,PieceDest),
	not(isPieceOfColor(PieceDest,PieceColor)),
	getPiece(Board, Row_Start, Col_Start, Piece),
	((isPieceOfType(Piece, 'H') , checkLegalHorse(PieceColor, Board, Col_Start, Row_Start, Col_Dest, Row_Dest)) ;
	(isPieceOfType(Piece, 'B') , checkLegalBishop(PieceColor, Board, Col_Start, Row_Start, Col_Dest, Row_Dest)) ;
	(isPieceOfType(Piece, 'T') , checkLegalTower(PieceColor, Board, Col_Start, Row_Start, Col_Dest, Row_Dest)) ;
	(isPieceOfType(Piece, 'Q') , checkLegalQueen(PieceColor, Board, Col_Start, Row_Start, Col_Dest, Row_Dest)) ;
	(isPieceOfType(Piece, 'K') , checkLegalKing(PieceColor, Board, Col_Start, Row_Start, Col_Dest, Row_Dest))),
	moveGeneral(Board, Col_Start, Row_Start, Col_Dest, Row_Dest, AuxiliaryBoard),
	entireBoardCheck(AuxiliaryBoard,AuxiliaryBoard,1,1).

/**
 * Auxiliary for checkLegal if the Piece is a Horse.
 */
checkLegalHorse(PieceColor, Board, Col_Start, Row_Start, Col_Dest, Row_Dest) :-
	checkMovementHorse(Col_Start, Row_Start, Col_Dest, Row_Dest),
	\+ ((PieceColor == w, horseChecksKing(b, Board, Col_Dest, Row_Dest)) ;
		(PieceColor == b, horseChecksKing(w, Board, Col_Dest, Row_Dest))).

/**
 * Auxiliary for checkLegal if the Piece is a Horse.
 */
checkLegalBishop(PieceColor, Board, Col_Start, Row_Start, Col_Dest, Row_Dest) :-
	checkMovementBishop(Col_Start, Row_Start, Col_Dest, Row_Dest),
	\+ ((PieceColor == w, bishopChecksKing(b, Board, Col_Dest, Row_Dest)) ;
		(PieceColor == b, bishopChecksKing(w, Board, Col_Dest, Row_Dest))),
	noPiecesInBishopTrajectory(Board, Col_Start, Row_Start, Col_Dest, Row_Dest).

/**
 * Auxiliary for checkLegal if the Piece is a Tower.
 */
checkLegalTower(PieceColor, Board, Col_Start, Row_Start, Col_Dest, Row_Dest) :-
	checkMovementTower(Col_Start, Row_Start, Col_Dest, Row_Dest),
	\+ ((PieceColor == w, towerChecksKing(b, Board, Col_Dest, Row_Dest)) ;
		(PieceColor == b, towerChecksKing(w, Board, Col_Dest, Row_Dest))),
		noPiecesInTowerTrajectory(Board, Col_Start, Row_Start, Col_Dest, Row_Dest).

/**
 * Auxiliary for checkLegal if the Piece is a Queen.
 */
checkLegalQueen(PieceColor, Board, Col_Start, Row_Start, Col_Dest, Row_Dest) :-
	checkMovementQueen(Col_Start, Row_Start, Col_Dest, Row_Dest),
	\+ ((PieceColor == w, queenChecksKing(b, Board, Col_Dest, Row_Dest)) ;
		(PieceColor == b, queenChecksKing(w, Board, Col_Dest, Row_Dest))),
	noPiecesInQueenTrajectory(Board, Col_Start, Row_Start, Col_Dest, Row_Dest).

/**
 * Auxiliary for checkLegal if the Piece is a King.
 */
checkLegalKing(PieceColor, Board, Col_Start, Row_Start, Col_Dest, Row_Dest) :-
	checkMovementKing(Col_Start, Row_Start, Col_Dest, Row_Dest),
	\+ ((PieceColor == w, kingChecksKing(b, Board, Col_Dest, Row_Dest)) ;
		(PieceColor == b, kingChecksKing(w, Board, Col_Dest, Row_Dest))).
