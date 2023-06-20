// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract Messenger {
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
    constructor(uint256 _numOfPendingLimits) payable {
        console.log("Here is my first smart contract!");

        numOfPendingLimits = _numOfPendingLimits;
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
   // ...
}
