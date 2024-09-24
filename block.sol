// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

contract tips {
    address owner;
    Son[] son;
    uint public lastKeepAliveTimestamp; // เก็บเวลาที่เรียกใช้ keepAlive ครั้งล่าสุด

    constructor(){
        owner = msg.sender;
        lastKeepAliveTimestamp = block.timestamp; // ตั้งค่าเริ่มต้นให้เป็นเวลาปัจจุบันตอนสร้างสัญญา
    }
    
    // ฟังก์ชันเพิ่มเงินในสัญญา
    function addmoney() payable public {}

    // ฟังก์ชันดูยอดเงินในสัญญา
    function viewmoney() public view returns(uint){
        return address(this).balance;
    }

    // โครงสร้างข้อมูล Son
    struct Son{
        address payable walletAddress;
        string name;
    }

    // เพิ่มข้อมูล Son เฉพาะเจ้าของสัญญาเท่านั้นที่สามารถเรียกใช้
    function addSon(address payable walletAddress, string memory name) public {
        require(msg.sender == owner, "Only the owner can call this function");
        bool waitressExist = false;

        if (son.length >= 1) {
            for (uint i = 0; i < son.length; i++) {
                if (son[i].walletAddress == walletAddress) {
                    waitressExist = true;
                }
            }
        }
        if (!waitressExist) {
            son.push(Son(walletAddress, name));
        }
    }

    // ลบข้อมูล Son
    function removeSon(address payable walletAddress) public {
        if (son.length > 0) {
            for (uint i = 0; i < son.length; i++) {
                if (son[i].walletAddress == walletAddress) {
                    for (uint j = i; j < son.length - 1; j++) {
                        son[j] = son[j + 1];
                    }
                    son.pop();
                    break;
                }
            }
        }
    }

    // ดูข้อมูล Son ทั้งหมด
    function viewSon() public view returns (Son[] memory) {
        return son;
    }

    // แจกจ่ายทิป
    function distrubiteTips() public {
        require(address(this).balance > 0, "Insufficient balance in the contract");
        if (son.length >= 1) {
            uint amount = address(this).balance / son.length;
            for (uint i = 0; i < son.length; i++) {
                transfer(son[i].walletAddress, amount);
            }
        }
    }

    // ฟังก์ชันภายในสำหรับการโอนเงิน
    function transfer(address payable walletAddress, uint amount) internal {
        walletAddress.transfer(amount);
    }

    // ฟังก์ชันสำหรับเจ้าของในการตั้งค่า Time Stamp เริ่มต้นหรือรีเซ็ตเวลา
    function setKeepAlive() public {
        require(msg.sender == owner, "Only the owner can call this function");
        lastKeepAliveTimestamp = block.timestamp; // บันทึกเวลาเป็น Time Stamp ปัจจุบัน
    }

    // ฟังก์ชัน keepAlive ที่ใครก็สามารถเรียกได้ แต่ต้องรอเวลาหนึ่งปี
    function keepAlive() public {
        require(block.timestamp >= lastKeepAliveTimestamp + 365 days, "KeepAlive can only be called after one year");
        lastKeepAliveTimestamp = block.timestamp; // อัพเดต Time Stamp เมื่อเรียกฟังก์ชัน
    }
}
