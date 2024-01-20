// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

contract arith {

        uint256 num = 7;

       function getOddNum() public view returns (string memory) {
        if (num % 2 != 0) {
            return "It is an odd number";
        } else {
            return "It is an even number";
        }
    }

      function getEvenNum() public view returns (string memory) {
        if (num % 2 == 0) {
            return "It is an even number";
        } else {
            return "It is an odd number";
        }
    }
    function isEven(uint256 number) public pure returns (bool) {
        return number % 2 == 0;
    }
    function isOdd(uint256 number) public pure returns (bool) {
        return number % 2 != 0;
    }

        function mostSignificantBit() public view returns(uint256) {
        uint256 msb = num >> 255;
        return msb;
    } 
   
}
