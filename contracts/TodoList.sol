// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract TodoList {

    enum State{
        todo,
        pending,
        completed
    }


    struct Item{
        string content;
        State state;
        uint256 pendingStartTime;
    }


    mapping (uint256 => Item) todoMap;
    

    uint256 public pendingThreshold; 

    uint256 public counter = 0;

    constructor(uint256 _pendingLimit) {
        pendingThreshold = _pendingLimit;
    }

    modifier isTodo(uint256 _id){
        require(todoMap[_id].state == State.todo, "Its state is not \"todo\"");
        _;
    }

    modifier isPending(uint256 _id){
        require(todoMap[_id].state == State.pending, "Its state is not \"pending\"");
        _;
    }

    modifier isCompleted(uint256 _id){
        require(todoMap[_id].state == State.completed, "Its state is not \"completed\"");
        _;
    }
    
    modifier overRecoverTime(uint256 pendingStartTime){
        require(block.timestamp - pendingStartTime <= pendingThreshold, "over time !");
        _;
    }


    // 永久儲存是storage，短暫使用就用memory，calldata傳入後只能參考不能改變的data type 
    function addTodo(string memory _content) external {
        Item memory todoItem = Item({
            content: _content,
            pendingStartTime: 0,
            state: State.todo 
            });
        todoMap[counter] = todoItem;
        counter++;
    }

    function setCompleted(uint256 _id) external isPending(_id){
        Item memory todo = todoMap[_id];
        todo.state= State.completed;
        todoMap[_id] = todo;
    }

    function deleteTodo(uint256 _id) external {
        delete todoMap[_id];    
    }

    function getTodo(uint256 _id) external isTodo(_id) view returns (string memory) {
        return todoMap[_id].content;
    }

    function getPending (uint256 _id) external isPending(_id) view returns (string memory){
        return todoMap[_id].content;
    }

    function getCompleted(uint256 _id) external isCompleted(_id) view returns (string memory) {
        return todoMap[_id].content;
    }

    function getAllTodo() external view returns (string[] memory) {
        uint256 arrSize = getTodoNumbers();
        uint256 index = 0;
        string[] memory res = new string[](arrSize) ;
        for (uint256 i =0; i< counter; i++){
            if (todoMap[i].state == State.todo){
                res[index] = todoMap[i].content;
                index++;
            }
        }
        return res;
    }

    function getAllPending()external view returns(string[] memory) {
        uint256 arrSize = getPendingNumbers();
        uint256 index = 0;
        string[] memory res = new string[](arrSize) ;
        for (uint256 i =0; i< counter; i++){
            if (todoMap[i].state == State.pending){
                res[index] = todoMap[i].content;
                index++;
            }
        }
        return res;
    }

    function getAllCompleted() external view returns(string[] memory) {
        uint256 arrSize = getCompletedNumbers();
        uint256 index = 0;
        string[] memory res = new string[](arrSize) ;
        for (uint256 i =0; i< counter; i++){
            if (todoMap[i].state == State.completed){
                res[index] = todoMap[i].content;
                index++;
            }
        }
        return res;
    }

    function getTodoNumbers() private view returns (uint256){
        uint256 count = 0;
         for (uint256 i =0; i< counter; i++){
            if (todoMap[i].state == State.todo){
                count++;
            }
        }
        return count;
    }

    function getPendingNumbers() private view returns (uint256){
        uint256 count = 0;
         for (uint256 i =0; i< counter; i++){
            if (todoMap[i].state == State.pending){
                count++;
            }
        }
        return count;
    }

    function getCompletedNumbers() private view returns (uint256){
        uint256 count = 0;
         for (uint256 i =0; i< counter; i++){
            if (todoMap[i].state == State.completed){
                count++;
            }
        }
        return count;
    }


    function setPending(uint256 _id) external isTodo(_id) {
        Item memory todo = todoMap[_id];
        todo.state= State.pending;
        todo.pendingStartTime = block.timestamp;
        todoMap[_id] = todo;
    } 

    function recoverFromPendingToTodo(uint256 _id) external isPending(_id) overRecoverTime(todoMap[_id].pendingStartTime) {
        Item memory todo = todoMap[_id];
        todo.state = State.todo;
        todo.pendingStartTime = 0;
        todoMap[_id] = todo;
    }

    function cleanCompleted() external {
        for (uint256 i =0; i< counter; i++){
            if (todoMap[i].state == State.completed){
                delete todoMap[i];
            }
        }
    }
}