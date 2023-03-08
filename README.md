# 第一週作業

## Q1:請簡單描述錢包助記詞，私鑰，公鑰之間的關係
一個錢包生成可以簡略成七個步驟：
* Step1: 產生一個256bits的隨機數。
* Step2: 與BIP-39對照表對應出英文字。
* Step3: 對應好後，取得助記詞。
* Step4: 一份助記詞會對應多個私鑰，從中取得一個作為錢包私鑰。
* Step5: 私鑰透過ECDSA橢圓曲線算法計算出公鑰。
* Step6: 將公鑰透過Keccak-256雜湊函數產生雜湊值(64位十六進制)。
* Step7: 取最右邊20 bytes最為錢包地址(20 bytes = 160 bits = 40位十六進制)。
![](https://i.imgur.com/yv1hRyN.png)

## Q2: 用 Remix 部署智能合約(Local London)
成果截圖:
* 部署成功
![](https://i.imgur.com/80JwUmW.png)
* 操作頁面
![](https://i.imgur.com/R8WWRmF.png =25%x)

## Q3: 
### Q3.1 將寫好的合約部署到 Görli / Goerli 測試鏈上，並 verify 開源程式碼
### Q3.2 Todo List 增加 Pending 功能

* 測試鏈合約地址：<a href = "https://goerli.etherscan.io/address/0x9770de5f05a0c04d5f50d0d1d899d5c872ddb062#code">0x9770de5f05a0c04d5F50d0D1d899D5C872ddB062</a>


* 程式碼：

```solidity=
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

contract TodoListSimple {
    string[] public todos;
    string[] public todoCompleted;
    string[] public pending;

    constructor() {}

    // 永久儲存是storage，短暫使用就用memory，calldata傳入後只能參考不能改變的data type 
    function addTodo(string memory todo) external {
        todos.push(todo);
    }

    function setCompleted(uint256 index) external {
        string memory compeltedTodo = pending[index];
        
        for (uint256 i = index; i < pending.length - 1; i++){
            pending[i] = pending[i + 1];
        }
        delete pending[pending.length - 1];
        pending.pop();

        todoCompleted.push(compeltedTodo);
    }

    function getTodo(uint256 index) external view returns (string memory) {
        return todos[index];
    }

    function deleteTodo(uint256 index) external {
        delete todos[index];
        for(uint256 i = index; i < todos.length - 1 ; i++){
            todos[i] = todos[i+1];
        }

        todos.pop();
    }

    function getCompleted(uint256 index) external view returns (string memory) {
        return todoCompleted[index];
    }

    function getAllTodo() external view returns (string[] memory) {
        return todos;
    }

    function getAllCompleted() external view returns (string[] memory) {
        return todoCompleted;
    }

    function setPending(uint256 index) external {
        string memory pendingTodo = todos[index];
        
        for (uint256 i = index; i < todos.length - 1; i++){
            todos[i] = todos[i + 1];
        }
        delete todos[todos.length - 1];
        todos.pop();

        pending.push(pendingTodo);
    }

    function getAllPending() external view returns (string[] memory) {
        return pending;
    }

    function getPending(uint256 index) external view returns (string memory) {
        return pending[index];
    }
}
```


## 進階題
* 測試程式碼：
```solidity=
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
```
* 測試結果截圖：

![](https://i.imgur.com/G4EiUlQ.png)

* 測試鏈合約地址：<a href ="https://goerli.etherscan.io/address/0xfbebf18229a3e856444b5ae3eefe89b35c83f75f#code">0xFBEbf18229a3e856444b5Ae3EEfe89B35c83f75f</a>

* 程式碼（包含1. 清空Complete, 2. 限定秒數可搬回Todo）：
```solidity=
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract TodoList {


    struct Item{
        string content;
        uint256 pendingStartTime;
    }


    Item[] public todos;
    Item[] public todoCompleted;
    Item[] public pending;

    uint256 public pendingThreshold; 

    constructor(uint256 _pendingLimit) {
        pendingThreshold = _pendingLimit;
    }

    modifier overRecoverTime(uint256 pendingStartTime){
        require(block.timestamp - pendingStartTime <= pendingThreshold, "over time !");
        _;
    }

    // 永久儲存是storage，短暫使用就用memory，calldata傳入後只能參考不能改變的data type 
    function addTodo(string memory todo) external {
        Item memory todoItem = Item({
            content: todo,
            pendingStartTime: 0 
            });
        todos.push(todoItem);
    }

    function setCompleted(uint256 index) external {

        Item memory compeltedTodo = pending[index];

        for (uint256 i = index; i < pending.length - 1; i++){
            pending[i] = pending[i + 1];
        }

        delete pending[pending.length - 1];

        pending.pop();

        todoCompleted.push(compeltedTodo);
    }

    function getTodo(uint256 index) external view returns (string memory) {
        return todos[index].content;
    }

    function deleteTodo(uint256 index) external {

        delete todos[index];

        //調整刪除arr元素，自動排序arr內容，並pop空間 (如此會增加deleteTodo所需支付的Gas Fee)
        for(uint256 i = index; i < todos.length - 1 ; i++){
            todos[i] = todos[i+1];
        }

        todos.pop();
    }

    function getCompleted(uint256 index) external view returns (string memory) {
        return todoCompleted[index].content;
    }

    function getAllTodo() external view returns (string[] memory) {
        string[] memory res = new string[](todos.length);
        for (uint256 i =0; i< todos.length; i++){
            res[i] = todos[i].content;
        }
        return res;
    }

    function getAllCompleted() external view returns (string[] memory) {
        string[] memory res = new string[](todoCompleted.length);
        for (uint256 i =0; i< todoCompleted.length; i++){
            res[i] = todoCompleted[i].content;
        }
        return res;
    }

    function setPending(uint256 _index) external {
        //取得要完成todo list 事項的內容
        Item memory pendingTodo = todos[_index];
        pendingTodo.pendingStartTime = block.timestamp;
        //重新整理arr內容，將完成事項後面的內容網前移動
        for (uint256 i = _index; i < todos.length - 1; i++){
            todos[i] = todos[i + 1];
        }
        //將最後一項還原成預設直
        delete todos[todos.length - 1];
        //將arr最後一個剛被還原的空間刪掉(arr長度-1)
        todos.pop();

        //將完成事項加入另一個list中
        pending.push(pendingTodo);
    } 

    function getPending (uint256 _index) external view returns (string memory){
        return pending[_index].content;
    }

    function getAllPending()external view returns(string[] memory) {
        string[] memory res = new string[](pending.length);
        for (uint256 i =0; i< pending.length; i++){
            res[i] = pending[i].content;
        }
        return res;
    }

    function recoverFromPendingToTodo(uint256 _index) external overRecoverTime(pending[_index].pendingStartTime) {
        Item memory pendingRecoverItem = pending[_index];
        todos.push(pendingRecoverItem);

        for(uint256 i= _index; i < pending.length-1; i++){
            pending[i] = pending[i+1];
        }
        delete pending[pending.length-1];
        pending.pop();
    }

    function cleanCompleted() external {
        delete todoCompleted;
        for(uint256 i=0; i< todoCompleted.length; i++){
            todoCompleted.pop();
        }
    }
}
```