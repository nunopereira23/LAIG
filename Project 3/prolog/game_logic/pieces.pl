/**
 * Auxiliary of isPieceOfColor.
 */
isPieceListOfColor([_, Color], IntendedColor) :-
	char_code(ColorChar, Color),
	ColorChar == IntendedColor.

/**
 * Checks if Piece is of a given color.
 */
isPieceOfColor(Piece, IntendedColor) :-
	atom_codes(Piece, PieceAsList),
	isPieceListOfColor(PieceAsList, IntendedColor).


/**
 * Auxiliary of isPieceOfType.
 */
isPieceListOfType([Type, _], IntendedType) :-
	char_code(TypeChar, Type),
	TypeChar == IntendedType.

/**
 * Checks if Piece is of a given type (King, Queen, etc.).
 */
isPieceOfType(Piece, IntendedType) :-
	atom_codes(Piece, PieceAsList),
	isPieceListOfType(PieceAsList, IntendedType).
