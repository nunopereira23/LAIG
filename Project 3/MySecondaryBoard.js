class MySecondaryBoard {
    /**
     * 
     * @param {XMLscene} scene 
     * @param {*} position Object with 'x', 'y' and 'z' attributes.
     */
    constructor(scene, position) {
        this.scene = scene;
        this.position = position;

        this.cellWidth = 1;
        this.secondaryBoardLines = 8;
        this.secondaryBoardColumns = 2;
        this.blackCell = scene.graph.nodes['blackCell'];
        this.whiteCell = scene.graph.nodes['whiteCell'];

        this.boardCells = this._buildSecondaryBoard();
        this.boardPieces = this._initBoardPieces();
        this.queuedBoardPieces = this._initBoardPieces();
    }

    display() {
        this.scene.pushMatrix();
            this.scene.translate(this.position.x, this.position.y, this.position.z);
            for (let line = 0; line < this.secondaryBoardLines; line++) {
                for (let col = 0; col < this.secondaryBoardColumns; col++) {
                    this.scene.pushMatrix();
                        if (this.boardPieces[line][col].movingToMainBoard) {
                            let animDestLine = this.boardPieces[line][col].movingToLine;
                            let animDestCol = this.boardPieces[line][col].movingToCol;
                            this.scene.registerForPick(this.scene.board._getPickId(animDestLine, animDestCol), this.scene.board.board[line][col]);
                        }
                        this.scene.translate(this.cellWidth * col, 0, this.cellWidth * line);
                        this._displayCell(line, col);
                        this._displayPiece(line, col);
                    this.scene.popMatrix();
                }
            }
        this.scene.popMatrix();
    }

    /**
     * Copies queued board to the active board.
     * This allows pieces to animate to the board before they're actually placed on it.
     */
    updateQueued() {
        this.boardPieces = this._copyBoardPieces(this.queuedBoardPieces);
    }

    /**
     * 
     * @param {MyPiece} piece 
     */
    placePiece(piece) {
        let coords = this.getCoordsToPlacePieceOn(piece);

        

        this.queuedBoardPieces[coords.line][coords.col].setPiece("" + piece.type + piece.color);
    }

    getCoordsToPlacePieceOn(piece) {
        let coords = {};

        if (piece.isWhite()) {
            coords.col = 0;
        } else if (piece.isBlack()) {
            coords.col = 1;
        }

        if (piece.isKing()) {
            coords.line = 0;
        } else if (piece.isQueen()) {
            coords.line = 1;
        } else if (piece.isBishop()) {
            if (this.queuedBoardPieces[2][coords.col].pieceIsSet()) {
                coords.line = 3;
            } else {
                coords.line = 2;
            }
        } else if (piece.isTower()) {
            if (this.queuedBoardPieces[4][coords.col].pieceIsSet()) {
                coords.line = 5;
            } else {
                coords.line = 4;
            }
        } else if (piece.isHorse()) {
            if (this.queuedBoardPieces[6][coords.col].pieceIsSet()) {
                coords.line = 7;
            } else {
                coords.line = 6;
            }
        }

        return coords;
    }

    getCoordsOfPiece(piece) {
        let coords = {};

        if (piece.isWhite()) {
            coords.col = 0;
        } else if (piece.isBlack()) {
            coords.col = 1;
        }

        if (piece.isKing()) {
            coords.line = 0;
        } else if (piece.isQueen()) {
            coords.line = 1;
        } else if (piece.isBishop()) {
            if (this.queuedBoardPieces[2][coords.col].pieceIsSet()) {
                coords.line = 2;
            } else {
                coords.line = 3;
            }
        } else if (piece.isTower()) {
            if (this.queuedBoardPieces[4][coords.col].pieceIsSet()) {
                coords.line = 4;
            } else {
                coords.line = 5;
            }
        } else if (piece.isHorse()) {
            if (this.queuedBoardPieces[6][coords.col].pieceIsSet()) {
                coords.line = 6;
            } else {
                coords.line = 7;
            }
        }

        return coords;
    }

    removePiecesGoingToMainBoard() {
        for (let line = 0; line < this.secondaryBoardLines; line++) {
            for (let col = 0; col < this.secondaryBoardColumns; col++) {
                if (this.queuedBoardPieces[line][col].movingToMainBoard) {
                    //this.boardPieces[line][col].unsetPiece();
                    this.queuedBoardPieces[line][col].unsetPiece();
                }
            }
        }
    }

    _buildSecondaryBoard() {
        let outerBlackTurn = true;
        let board = [];
        for (let line = 0; line < this.secondaryBoardLines; line++) {
          let blackTurn = outerBlackTurn;
          let boardLine = [];
          for (let col = 0; col < this.secondaryBoardColumns; col++) {
            let cell = (blackTurn ? this.blackCell : this.whiteCell);
            blackTurn = !blackTurn;
            boardLine.push(cell);
          }
          board.push(boardLine);
          outerBlackTurn = !outerBlackTurn;
        }
        return board;
    }

    _initBoardPieces() {
        let boardPieces = [];
        for (let line = 0; line < this.secondaryBoardLines; line++) {
          let piecesLine = [];
          for (let col = 0; col < this.secondaryBoardColumns; col++) {
            piecesLine[col] = new MyPiece(this.scene);
          }
          boardPieces.push(piecesLine);
        }
        return boardPieces;
    }

    _copyBoardPieces(boardPieces) {
        let newBoardPieces = [];
        for (let line = 0; line < boardPieces.length; line++) {
          let newBoardLine = [];
          for (let col = 0; col < boardPieces[line].length; col++) {
            newBoardLine[col] = boardPieces[line][col].clone();
          }
          newBoardPieces.push(newBoardLine);
        }
        return newBoardPieces;
    }

    _displayCell(line, col) {
        this.scene.graph.displayNode(this.boardCells[line][col]);
    }

    _displayPiece(line, col) {
        this.scene.pushMatrix();

            if (this.boardPieces[line][col].node != null && this.boardPieces[line][col].animations.length > 0) {
                let currAnimTime = Date.now() / 1000 - this.boardPieces[line][col].animationsStartTime;
                let animTransform = this.boardPieces[line][col].getAnimTransform(currAnimTime);
                this.scene.multMatrix(animTransform);
            }
        
            if (this.boardPieces[line][col].node != null) {
                this.scene.graph.displayNode(this.boardPieces[line][col].node);
            }

        this.scene.popMatrix();
    }
}