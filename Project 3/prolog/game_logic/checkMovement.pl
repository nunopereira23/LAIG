/*
	Checks if the coordinates used are valid.
	In this particular case the horse as an L shaped movement
*/
checkMovementHorse(Col_Start, Row_Start, Col_Dest, Row_Dest) :-
	((Col_Start + 1 =:= Col_Dest ; Col_Start - 1 =:= Col_Dest) , (Row_Start + 2 =:= Row_Dest ; Row_Start - 2 =:= Row_Dest));
	((Col_Start + 2 =:= Col_Dest ; Col_Start - 2 =:= Col_Dest) , (Row_Start + 1 =:= Row_Dest ; Row_Start - 1 =:= Row_Dest)).

/*
	Checks if the coordinates used are valid.
	In this particular case the bishop only moves diagonally
*/
checkMovementBishop(Col_Start, Row_Start, Col_Dest, Row_Dest) :-
	(Col_Dest - Col_Start =:= Row_Dest - Row_Start) ;
	(Col_Dest - Col_Start =:= -(Row_Dest - Row_Start)).

/*
	Checks if the coordinates used are valid.
	In this particular case the tower moves vertically and horizontally
*/
checkMovementTower(Col_Start, Row_Start, Col_Dest, Row_Dest) :-
	(Col_Start =:= Col_Dest) ; (Row_Start =:= Row_Dest).

/*
Checks if the coordinates used are valid.
In this particular case the queen moves in any direction
*/
checkMovementQueen(Col_Start, Row_Start, Col_Dest, Row_Dest) :-
	(Col_Dest - Col_Start =:= Row_Dest - Row_Start) ;
	(Col_Dest - Col_Start =:= -(Row_Dest - Row_Start)) ;
	(Col_Start =:= Col_Dest) ; (Row_Start =:= Row_Dest).

/*
Checks if the coordinates used are valid.
In this particular case the king moves in any direction(only 1 space)
*/
checkMovementKing(Col_Start, Row_Start, Col_Dest, Row_Dest) :-
	(Col_Dest =:= Col_Start, (Row_Dest + 1 =:= Row_Start ; Row_Dest - 1 =:= Row_Start)) ;
	(Row_Dest =:= Row_Start, (Col_Dest + 1 =:= Col_Start ; Col_Dest - 1 =:= Col_Start)) ;
	(Row_Dest =:= Row_Start + 1, (Col_Dest + 1 =:= Col_Start ; Col_Dest - 1 =:= Col_Start)) ;
	(Row_Dest =:= Row_Start - 1, (Col_Dest + 1 =:= Col_Start ; Col_Dest - 1 =:= Col_Start)).
