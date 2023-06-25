// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "hardhat/console.sol";
import "./Ownable.sol";

contract Messenger is Ownable{
    // ユーザが保留できるメッセージ数の上限を設定します。
    uint256 public numOfPendingLimits;

    // メッセージ情報を定義します。
    struct Message {
        address payable sender;
        address payable receiver;
        uint256 depositInWei;
        uint256 timestamp;
        string text;
        bool isPending;
    }
    
    // メッセージの受取人アドレスをkeyにメッセージを保存します。
    mapping(address => Message[]) private _messagesAtAddress;
    // ユーザが保留中のメッセージの数を保存します。
    mapping(address => uint256) private _numOfPendingAtAddress;

    event NewMessage(
        address sender,
        address receiver,
        uint256 depositInWei,
        uint256 timestamp,
        string text,
        bool isPending
    );

    event MessageConfirmed(address receiver, uint256 index);
    event NumOfPendingLimitsChanged(uint256 limits);
    constructor(uint256 _numOfPendingLimits) payable {
        console.log("Here is my first smart contract!");
        ownable();
        numOfPendingLimits = _numOfPendingLimits;
    }

    function changeNumOfPendingLimits(uint256 _limits) external onlyOwner {
        numOfPendingLimits =_limits;
        emit NumOfPendingLimitsChanged(numOfPendingLimits);
    }
   // ユーザからメッセージを受け取り、状態変数に格納します。
   function post(string memory _text, address payable _receiver)
       public
       payable
   {
        // メッセージ受取人の保留できるメッセージが上限に達しているかを確認します。
        require(
            _numOfPendingAtAddress[_receiver] < numOfPendingLimits,
            "The receiver has reached the number of pending limits"
        );

        // 保留中のメッセージの数をインクリメントします。
        _numOfPendingAtAddress[_receiver] += 1;
       console.log(
           "%s posts text:[%s] token:[%d]",
           msg.sender,
           _text,
           msg.value
       );
       _messagesAtAddress[_receiver].push(
           Message(
               payable(msg.sender),
               _receiver,
               msg.value,
               block.timestamp,
               _text,
               true
           )
       );
       emit NewMessage(
           msg.sender,
           _receiver,
           msg.value,
           block.timestamp,
           _text,
           true
       );
   }

    function getOwnMessages() public view returns (Message[] memory) {
        return _messagesAtAddress[msg.sender];
    }
        function accept(uint256 _index) public {
        //指定インデックスのメッセージを確認します。
        _confirmMessage(_index);

        Message memory message = _messagesAtAddress[msg.sender][_index];

        // メッセージの受取人にavaxを送信します。
        _sendAvax(message.receiver, message.depositInWei);

        emit MessageConfirmed(message.receiver, _index);
    }
        function deny(uint256 _index) public payable {
        _confirmMessage(_index);

        Message memory message = _messagesAtAddress[msg.sender][_index];

        // メッセージの送信者にavaxを返却します。
        _sendAvax(message.sender, message.depositInWei);

       emit MessageConfirmed(message.receiver, _index);
   }
function _confirmMessage(uint256 _index) private {
        Message storage message = _messagesAtAddress[msg.sender][_index];

        // 関数を呼び出したアドレスとメッセージの受取人アドレスが同じか確認します。
        require(
            msg.sender == message.receiver,
            "Only the receiver can _confirmMessage the message"
        );

        // メッセージが保留中であることを確認します。
        require(
            message.isPending == true,
            "This message has already been confirmed"
        );

        // メッセージの保留状態を解除します。
        message.isPending = false;
    }

    function _sendAvax(address payable _to, uint256 _amountInWei) private {
        (bool success, ) = (_to).call{value: _amountInWei}("");
        require(success, "Failed to withdraw AVAX from contract");
    }

}
