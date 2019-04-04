'use strict';

class MyBoard {
  /**
   * 
   * @param {XMLscene} scene 
   */
  constructor(scene, maxTimePerPlay) {
    'use strict';
    this.scene = scene;
    this.maxTimePerPlay = maxTimePerPlay;
    this.timeOfLastPlay = Date.now();

    this.activeGame = false;
    this.requestingPlayerChange = false;

    this.playerColor = 'w'; //white
    this.botColor = 'b'; //black
    this.cellWidth = 1;
    this.boardLength = 8;
    this.blackCell = scene.graph.nodes['blackCell'];
    this.whiteCell = scene.graph.nodes['whiteCell'];
    this.board = this._buildBoard();
    this.boardPieces = this._initBoardPieces();
    this.queuedBoardPieces = this._initBoardPieces();
    this.initedBoard = false;
    this.playSequence = [];
    this.gameState = new MyGameState();

    this.secondaryOffset = {'x': -5, 'y': 0, 'z': 0};
    this.secondaryBoard = new MySecondaryBoard(this.scene, this.secondaryOffset);
  }

  display() {
    for (let line = 0; line < this.boardLength; line++) {
      for (let col = 0; col < this.boardLength; col++) {
        this.scene.pushMatrix();
          if (this.boardPieces[line][col].movingToMainBoard) {
            let animDestLine = this.boardPieces[line][col].movingToLine;
            let animDestCol = this.boardPieces[line][col].movingToCol;
            this.scene.registerForPick(this._getPickId(animDestLine, animDestCol), this.board[line][col]);
          } else {
            this.scene.registerForPick(this._getPickId(line, col), this.board[line][col]);
          }
          this.scene.translate(this.cellWidth * col, 0, this.cellWidth * line);
          this._displayCell(line, col);
          this._displayPiece(line, col);
        this.scene.popMatrix();
      }
    }

    this.secondaryBoard.display();
  }

  setActiveGame() {
    this.activeGame = true;
  }

  /**
   * Checks if current player hasn't timed out.
   */
  canStillPlay() {
    return (Date.now() - this.timeOfLastPlay <= this.maxTimePerPlay * 1000);
  }

  /**
   * 
   * @param {string} prologPieces Prolong representation of board.
   */
  updatePieces(prologPieces) {
    if (this.gameState.isOver()) {
      return;
    }

    this.resetPlayerTime();

    prologPieces = prologPieces.slice(2);
    prologPieces = prologPieces.slice(0, -2);
    let piecesLines = prologPieces.split("],[");
    
    for (let line = 0; line < this.boardLength; line++) {
      let pieces = piecesLines[line].split(",");
      for (let col = 0; col < this.boardLength; col++) {
        this.queuedBoardPieces[line][col].setPiece(pieces[col]);
        if (!this.initedBoard) {
          this.boardPieces[line][col].setPiece(pieces[col]);
        }
      }
    }
    this.initedBoard = true;
  }

  /**
   * Returns an object with 'line' and 'col' attributes.
   * @param {number} pickedId 
   */
  getCoordsOfPickedId(pickedId) {
    let coords = new Object();
    coords.line = Math.floor((pickedId - 1) / this.boardLength);
    coords.col = (pickedId - 1) % this.boardLength;
    return coords;
  }

  /**
   * 
   * @param {MyPlay} play 
   */
  addPlay(play) {
    this.playSequence.push(play);
    this._endAnimations();
    this._makeAnimation(play);
    
    if (this.boardPieces[play.destLine][play.destCol].pieceIsSet()) {
      play.eatPiece(this.boardPieces[play.destLine][play.destCol], play.destLine, play.destCol);
      if (this.boardPieces[play.destLine][play.destCol].isWhite()) {
        this.scene.blackScore++;
      } else {
        this.scene.whiteScore++;       
      }
      this._animateEatenPiece(play);
      this.secondaryBoard.placePiece(this.boardPieces[play.destLine][play.destCol]);
    }
  }

  /**
   * 
   * @param {MyGameState} gameState 
   */
  updateState(gameState) {
    this.gameState = gameState;

    if (gameState.isDraw) {
      alert("Draw");
    } else if (gameState.whiteWon) {
      alert("Whites won");
    } else if (gameState.blackWon) {
      alert("Blacks won");
    }
  }

  resetPlayerTime() {
    this.timeOfLastPlay = Date.now();
    this.requestingPlayerChange = false;
  }

  bringBackEatenPiece(eatenPiece, col, line) {
    if (eatenPiece.isWhite()) {
      this.scene.blackScore--;
    } else {
      this.scene.whiteScore--;
    }
    this._animateResurrectingPiece(eatenPiece, line, col);
  }

  _buildBoard() {
    let outerBlackTurn = true;
    let board = [];
    for (let line = 0; line < this.boardLength; line++) {
      let blackTurn = outerBlackTurn;
      let boardLine = [];
      for (let col = 0; col < this.boardLength; col++) {
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
    for (let line = 0; line < this.boardLength; line++) {
      let piecesLine = [];
      for (let col = 0; col < this.boardLength; col++) {
        piecesLine[col] = new MyPiece(this.scene);
      }
      boardPieces.push(piecesLine);
    }
    return boardPieces;
  }

  _displayCell(line, col) {
    this.scene.pushMatrix();

      if (this.scene.pickedId == this._getPickId(line, col)) {
        this.scene.setActiveShader(this.scene.pickedShader);
      }
      this.scene.graph.displayNode(this.board[line][col]);
      if (this.scene.pickedId == this._getPickId(line, col)) {
        this.scene.setActiveShader(this.scene.defaultShader);
      }
    
    this.scene.popMatrix();
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

  /**
   * 
   * @param {number} line 
   * @param {number} col 
   */
  _getPickId(line, col) {
    return line * this.boardLength + col + 1;
  }

  /**
   * 
   * @param {MyPlay} play 
   */
  _makeAnimation(play) {
    let startCoords = {'x': this.cellWidth * play.startCol, 'y': 0, 'z': this.cellWidth * play.startLine};
    let destCoords = {'x': this.cellWidth * play.destCol, 'y': 0, 'z': this.cellWidth * play.destLine};
    let deltaCoords = {'x': destCoords.x - startCoords.x, 'y': destCoords.y - startCoords.y, 'z': destCoords.z - startCoords.z};
    let P1 = [0, 0, 0];
    let P2 = [0, 10, 0];
    let P3 = [deltaCoords.x, deltaCoords.y + 10, deltaCoords.z];
    let P4 = [deltaCoords.x, deltaCoords.y, deltaCoords.z];
    
    let anim = new BezierAnimation(this.scene, 20, [P1, P2, P3, P4], false);
    if (this.boardPieces[play.startLine][play.startCol].animations.length == 0) {
      this.boardPieces[play.startLine][play.startCol].animationsStartTime = Date.now() / 1000;
    }
    this.boardPieces[play.startLine][play.startCol].addAnimation(anim, play.destLine, play.destCol);
  }

  _endAnimations() {
    this.boardPieces = this._copyBoardPieces(this.queuedBoardPieces);
    //this.secondaryBoard.removePiecesGoingToMainBoard();
    this.secondaryBoard.updateQueued();
  }

  /**
   * 
   * @param {MyPlay} play 
   */
  _animateEatenPiece(play) {
    let coordsInsideSecBoard = this.secondaryBoard.getCoordsToPlacePieceOn(this.boardPieces[play.destLine][play.destCol]);

    let pieceCoords = {'x': this.cellWidth * play.destCol, 'y': 0, 'z': this.cellWidth * play.destLine};
    let secCoords = {'x': this.cellWidth * coordsInsideSecBoard.col + this.secondaryOffset.x, 'y': this.secondaryOffset.y, 'z': this.cellWidth * coordsInsideSecBoard.line + this.secondaryOffset.z};
    let deltaCoords = {'x': secCoords.x - pieceCoords.x, 'y': secCoords.y - pieceCoords.y, 'z': secCoords.z - pieceCoords.z};
    let P1 = [0, 0, 0];
    let P2 = [0, 10, 0];
    let P3 = [deltaCoords.x, deltaCoords.y + 10, deltaCoords.z];
    let P4 = [deltaCoords.x, deltaCoords.y, deltaCoords.z];

    let anim = new BezierAnimation(this.scene, 20, [P1, P2, P3, P4], false);
    if (this.boardPieces[play.destLine][play.destCol].animations.length == 0) {
      this.boardPieces[play.destLine][play.destCol].animationsStartTime = Date.now() / 1000;
    }
    this.boardPieces[play.destLine][play.destCol].addAnimation(anim);
  }

  /**
   * 
   * @param {MyPiece} piece
   * @param {number} mainLine 
   * @param {number} mainCol 
   */
  _animateResurrectingPiece(piece, mainLine, mainCol) {
    let coordsInsideSecBoard = this.secondaryBoard.getCoordsOfPiece(piece);

    let mainCoords = {'x': this.cellWidth * mainCol, 'y': 0, 'z': this.cellWidth * mainLine};
    let secCoords = {'x': this.cellWidth * coordsInsideSecBoard.col + this.secondaryOffset.x, 'y': this.secondaryOffset.y, 'z': this.cellWidth * coordsInsideSecBoard.line + this.secondaryOffset.z};
    let deltaCoords = {'x': mainCoords.x - secCoords.x, 'y': mainCoords.y - secCoords.y, 'z': mainCoords.z - secCoords.z};
    let P1 = [0, 0, 0];
    let P2 = [0, 10, 0];
    let P3 = [deltaCoords.x, deltaCoords.y + 10, deltaCoords.z];
    let P4 = [deltaCoords.x, deltaCoords.y, deltaCoords.z];

    let anim = new BezierAnimation(this.scene, 20, [P1, P2, P3, P4], false);
    if (this.secondaryBoard.boardPieces[coordsInsideSecBoard.line][coordsInsideSecBoard.col].animations.length == 0) {
      this.secondaryBoard.queuedBoardPieces[coordsInsideSecBoard.line][coordsInsideSecBoard.col].animationsStartTime = Date.now() / 1000;
      this.secondaryBoard.boardPieces[coordsInsideSecBoard.line][coordsInsideSecBoard.col].animationsStartTime = Date.now() / 1000;
    }
    this.secondaryBoard.queuedBoardPieces[coordsInsideSecBoard.line][coordsInsideSecBoard.col].addAnimation(anim, mainLine, mainCol);
    this.secondaryBoard.boardPieces[coordsInsideSecBoard.line][coordsInsideSecBoard.col].addAnimation(anim, mainLine, mainCol);
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
}