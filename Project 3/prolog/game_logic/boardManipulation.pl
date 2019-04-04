/*
	Returns the piece in the coordinates received
*/
getPiece(Board, Row, Col, Piece) :-
	nth1(Row, Board, BoardLine),
	nth1(Col, BoardLine, Piece).

/*
	Puts a piece in the wanted coordinates
*/
setPiece(Board, Num_Row, Num_Col, Piece, NewBoard) :-
	rowSet(Board, Num_Row, Num_Col, Piece, NewBoard).

rowSet([Line|Remainder], 1, Num_Col, Piece, [NewLine|Remainder]) :-
	colSet(Num_Col, Line, Piece, NewLine).
rowSet([Line|Remainder], Num_Row, Num_Col, Piece, [Line|NewRemainder]) :-
	Num_Row > 1,
	Next is Num_Row - 1,
	rowSet(Remainder, Next, Num_Col, Piece, NewRemainder).

colSet(1, [_|Remainder], Piece, [Piece|Remainder]).
colSet(Pos, [X|Remainder], Piece, [X|NewRemainder]) :-
	Pos > 1,
	Next is Pos - 1,
	colSet(Next, Remainder, Piece, NewRemainder).

/*
	Inserts an element in a list in a certain index
*/
insertInList(List,Index,Play,NewList):-nth0(Index,NewList,Play,List).
