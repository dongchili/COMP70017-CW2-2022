//SPDX-License-Identifier: Unlicense
pragma solidity ^0.4.24;

/**
 * @title TicTacToe contract
 **/
contract TicTacToe {
    address[2] public players;//two players

    /**
     turn
     1 - players[0]'s turn
     2 - players[1]'s turn
     */
    uint public turn = 1;

    /**
     status
     0 - ongoing
     1 - players[0] won
     2 - players[1] won
     3 - draw
     */
    uint public status;

    /**
    board status
     0    1    2
     3    4    5
     6    7    8
     */
    uint[9] private board;

    /**
      * @dev Deploy the contract to create a new game
      * @param opponent The address of player2
      **/
    constructor(address opponent) public {
        require(msg.sender != opponent, "No self play");
        players = [msg.sender, opponent];
    }

    /**
      * @dev Check a, b, c in a line are the same
      * _threeInALine doesn't check if a, b, c are in a line
      * @param a position a
      * @param b position b
      * @param c position c
      **/    
    function _threeInALine(uint a, uint b, uint c) private view returns (bool){
        /*Please complete the code here.*/
        if(board[a]==board[b] && board[a]==board[c]){
            return true;
        }else{
            return false;
        }
    }

    /**
     * @dev get the status of the game
     * @param pos the position the player places at
     * @return the status of the game
     */
    function _getStatus(uint pos) private view returns (uint) {
        /*Please complete the code here.*/
        uint result;
        bool full =true;
        uint win = 0;

        //check is the board full
        for(uint i=0;i<9;i++){
            if(board[i]==0){
                full = false;
                break;
            }
        }

        if (((pos == 0) && (_threeInALine(0,1,2) || _threeInALine(0,3,6) || _threeInALine(0,4,8)))
        || ((pos == 1) && (_threeInALine(0,1,2) || _threeInALine(1,4,7)))
        || ((pos == 2) && (_threeInALine(0,1,2) || _threeInALine(2,5,8) || _threeInALine(2,4,6)))
        || ((pos == 3) && (_threeInALine(3,4,5) || _threeInALine(0,3,6)))
        || ((pos == 4) && (_threeInALine(1,4,7) || _threeInALine(3,4,5) || _threeInALine(0,4,8) || _threeInALine(2,4,6)))
        || ((pos == 5) && (_threeInALine(2,5,8) || _threeInALine(3,4,5)))
        || ((pos == 6) && (_threeInALine(6,7,8) || _threeInALine(0,3,6) || _threeInALine(2,4,6)))
        || ((pos == 7) && (_threeInALine(1,4,7) || _threeInALine(6,7,8)))
            || ((pos == 8) && (_threeInALine(6,7,8) || _threeInALine(2,5,8) || _threeInALine(0,4,8)))){
            win = board[pos];
        }

        if(full){
            if(win!=0){
                result = win ;
            }else{
                result = 3;
            }
        }else{
            if(win!=0){
                result = win ;
            }else{
                result = 0;
            }
        }

        return result;
    }

    /**
     * @dev ensure the game is still ongoing before a player moving
     * update the status of the game after a player moving
     * @param pos the position the player places at
     */
    modifier _checkStatus(uint pos) {
        /*Please complete the code here.*/
        require(status==0);
        _;
        status = _getStatus(pos);
    }

    /**
     * @dev check if it's msg.sender's turn
     * @return true if it's msg.sender's turn otherwise false
     */
    function myTurn() public view returns (bool) {
       /*Please complete the code here.*/
    //return turn==1;
    return players[turn - 1] == msg.sender;
    }

    /**
     * @dev ensure it's a msg.sender's turn
     * update the turn after a move
     */
    modifier _myTurn() {
      /*Please complete the code here.*/
        require(myTurn()==true);
        _;
        if(turn == 1){
            turn = 2;
        }else{
            turn = 1;
        }
    }

    /**
     * @dev check a move is valid
     * @param pos the position the player places at
     * @return true if valid otherwise false
     */
    function validMove(uint pos) public view returns (bool) {
      /*Please complete the code here.*/
        //if board[pos] != null return false; else return true;
        if(pos < board.length && pos >= 0 && board[pos] == 0){
            return true;
        }else{
            return false;
        }
    }

    /**
     * @dev ensure a move is valid
     * @param pos the position the player places at
     */
    modifier _validMove(uint pos) {
      /*Please complete the code here.*/
        require(validMove(pos)==true);
        _;
    }

    /**
     * @dev a player makes a move
     * @param pos the position the player places at
     */
    function move(uint pos) public _validMove(pos) _checkStatus(pos) _myTurn {
        board[pos] = turn;
    }

    /**
     * @dev show the current board
     * @return board
     */
    function showBoard() public view returns (uint[9]) {
      return board;
    }
}
