:- consult(boardManipulation).

/**
 * Auxiliary for noPiecesInBishopTrajectory.
 */
noPiecesInBishopTrajectory_Rec(_Board, Col, Row, Col, Row).
noPiecesInBishopTrajectory_Rec(Board, Col, Row, Col_Dest, Row_Dest) :-
	Col > 0, Col < 9, Row > 0, Row < 9,
	%(Col > Col_Dest ; Col < Col_Dest),
	getPiece(Board, Row, Col, Piece), Piece == '  ',
	%right down
	((Col_Dest > Col, Row_Dest > Row, New_Col_Start is Col + 1, New_Row_Start is Row + 1) ;
	%right up
	(Col_Dest > Col, Row_Dest < Row, New_Col_Start is Col + 1, New_Row_Start is Row - 1) ;
	%left down
	(Col_Dest < Col, Row_Dest > Row, New_Col_Start is Col - 1, New_Row_Start is Row + 1) ;
	%left up
	(Col_Dest < Col, Row_Dest < Row, New_Col_Start is Col - 1, New_Row_Start is Row - 1)),
	noPiecesInBishopTrajectory_Rec(Board, New_Col_Start, New_Row_Start, Col_Dest, Row_Dest).

/**
 * Checks if there are no Pieces between the Bishop's start and destination.
 */
noPiecesInBishopTrajectory(Board, Col_Start, Row_Start, Col_Dest, Row_Dest) :-
	%right down
	((Col_Dest > Col_Start, Row_Dest > Row_Start, New_Col_Start is Col_Start + 1, New_Row_Start is Row_Start + 1) ;
	%right up
	(Col_Dest > Col_Start, Row_Dest < Row_Start, New_Col_Start is Col_Start + 1, New_Row_Start is Row_Start - 1) ;
	%left down
	(Col_Dest < Col_Start, Row_Dest > Row_Start, New_Col_Start is Col_Start - 1, New_Row_Start is Row_Start + 1) ;
	%left up
	(Col_Dest < Col_Start, Row_Dest < Row_Start, New_Col_Start is Col_Start - 1, New_Row_Start is Row_Start - 1)),
	noPiecesInBishopTrajectory_Rec(Board, New_Col_Start, New_Row_Start, Col_Dest, Row_Dest).

/**
 * Auxiliary for noPiecesInTowerTrajecetory.
 */
noPiecesInTowerTrajectory_Rec(_Board, Col, Row, Col, Row).
noPiecesInTowerTrajectory_Rec(Board, Col, Row, Col_Dest, Row_Dest) :-
		Col > 0, Col < 9, Row > 0, Row < 9,
		%(Col > Col_Dest ; Col < Col_Dest),
		getPiece(Board, Row, Col, Piece), Piece == '  ',
		%up
		((Col_Dest =:= Col, Row_Dest < Row, New_Col_Start is Col, New_Row_Start is Row - 1) ;
		%down
		(Col_Dest =:= Col, Row_Dest > Row, New_Col_Start is Col, New_Row_Start is Row + 1) ;
		%right
		(Col_Dest > Col, Row_Dest =:= Row, New_Col_Start is Col + 1, New_Row_Start is Row) ;
		%left
		(Col_Dest < Col, Row_Dest =:= Row, New_Col_Start is Col - 1, New_Row_Start is Row)),
		noPiecesInTowerTrajectory_Rec(Board, New_Col_Start, New_Row_Start, Col_Dest, Row_Dest).

/**
 * Checks if there are no Pieces between the Tower's start and destination.
 */
noPiecesInTowerTrajectory(Board, Col_Start, Row_Start, Col_Dest, Row_Dest) :-
		%up
		((Col_Dest =:= Col_Start, Row_Dest < Row_Start, New_Col_Start is Col_Start, New_Row_Start is Row_Start -1) ;
		%down
		(Col_Dest =:= Col_Start, Row_Dest > Row_Start, New_Col_Start is Col_Start, New_Row_Start is Row_Start + 1) ;
		%right
		(Col_Dest > Col_Start, Row_Dest =:= Row_Start, New_Col_Start is Col_Start + 1, New_Row_Start is Row_Start) ;
		%left
		(Col_Dest < Col_Start, Row_Dest =:= Row_Start, New_Col_Start is Col_Start - 1, New_Row_Start is Row_Start)),
		noPiecesInTowerTrajectory_Rec(Board, New_Col_Start, New_Row_Start, Col_Dest, Row_Dest).

/**
 * Checks if there are no Pieces between the Queen's start and destination.
 */
noPiecesInQueenTrajectory(Board, Col_Start, Row_Start, Col_Dest, Row_Dest) :-
			noPiecesInTowerTrajectory(Board,Col_Start,Row_Start,Col_Dest,Row_Dest);
			noPiecesInBishopTrajectory(Board,Col_Start,Row_Start,Col_Dest,Row_Dest).
