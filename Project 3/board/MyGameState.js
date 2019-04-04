class MyGameState {
    constructor(isDraw = 0, whiteWon = 0, blackWon = 0) {
        this.isDraw = isDraw;
        this.whiteWon = whiteWon;
        this.blackWon = blackWon;
    }

    isOver() {
        return this.isDraw || this.whiteWon || this.blackWon;
    }
}