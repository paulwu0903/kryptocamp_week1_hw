// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "hardhat/console.sol";
import "../contracts/TodoListSimple.sol";

contract TodoListSimpleTest {

    TodoListSimple todoList = new TodoListSimple();

    function testAddTodo() public {
        string memory inputValue = "1";
        todoList.addTodo(inputValue);
        Assert.equal(todoList.getAllTodo().length, 1, "1_addTodo function error!");
        Assert.equal(todoList.getTodo(0), inputValue, "2_addTodo function error!");

        inputValue = "2";
        todoList.addTodo(inputValue);
        Assert.equal(todoList.getAllTodo().length, 2, "3_addTodo function error!");
        Assert.equal(todoList.getTodo(1), inputValue, "4_addTodo function error!");

        inputValue = "3";
        todoList.addTodo(inputValue);
        Assert.equal(todoList.getAllTodo().length, 3, "5_addTodo function error!");
        Assert.equal(todoList.getTodo(2), inputValue, "6_addTodo function error!");

        inputValue = "4";
        todoList.addTodo(inputValue);
        Assert.equal(todoList.getAllTodo().length, 4, "7_addTodo function error!");
        Assert.equal(todoList.getTodo(3), inputValue, "8_addTodo function error!");

        inputValue = "5";
        todoList.addTodo(inputValue);
        Assert.equal(todoList.getAllTodo().length, 5, "9_addTodo function error!");
        Assert.equal(todoList.getTodo(4), inputValue, "10_addTodo function error!");
    }

    function testDeleteTodo() public {
        
        string memory inputValue = "2";
        Assert.equal(todoList.getTodo(1), inputValue, "1_deleteTodo function error!");
        todoList.deleteTodo(0);
        Assert.equal(todoList.getAllTodo().length, 4, "2_deleteTodo function error!");
        
    }

    function testSetPending() public {

        todoList.setPending(0);
        Assert.equal(todoList.getAllPending().length, 1, "1_setPending function error!");
        Assert.equal(todoList.getPending(0), "2", "2_setPending function error!");

        todoList.setPending(0);
        Assert.equal(todoList.getAllPending().length, 2, "3_setPending function error!");
        Assert.equal(todoList.getPending(1), "3", "4_setPending function error!");

    }

    function testSetCompleted() public {
        todoList.setCompleted(0);
        Assert.equal(todoList.getAllCompleted().length, 1, "1_setCompleted function error!");
        Assert.equal(todoList.getCompleted(0), "2", "2_setCompleted function error!");
    }

    function testGetAllTodo() public {
        Assert.equal(todoList.getAllTodo().length, 2, "1_getAllTodo function error!");
    }

    function testGetAllCompleted() public {
        Assert.equal(todoList.getAllCompleted().length, 1, "1_getAllCompleted function error!");
    }

    function testGetAllPending() public {
        Assert.equal(todoList.getAllPending().length, 1, "1_getAllPending function error!");
    }

    function testGetTodo() public {
        Assert.equal(todoList.getTodo(0), "4", "1_getTodo function error!");
        Assert.equal(todoList.getTodo(1), "5", "2_getTodo function error!");
    }

    function testGetCompleted() public {
        Assert.equal(todoList.getCompleted(0), "2", "1_getCompleted function error!");
    }

    function testGetPending() public {
        Assert.equal(todoList.getPending(0), "3", "1_getPending function error!");
    }

}