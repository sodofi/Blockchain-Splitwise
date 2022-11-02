// SPDX-License-Identifier: UNLICENSED

// DO NOT MODIFY BELOW THIS
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract Splitwise {
// DO NOT MODIFY ABOVE THIS

// ADD YOUR CONTRACT CODE BELOW

    // map stores debtor --> creditor --> amount
    mapping (address => mapping(address => uint32)) public map;  

    function lookup(address debtor, address creditor) public view returns (uint32 ret) { 
        // NOTE: all memory is zero initialized already, thus if this hasn't been initialized it will return 0 
        return map[debtor][creditor];
    }

    function add_IOU(address creditor, uint32 amount, address[] calldata cycle_path) public { 

        // check that debtor and creditor are not the same person 
        address debtor = msg.sender;
        require(debtor != creditor, "Sender cannot be the same as creditor.");
        require(creditor != address(0), "Creditor address cannot be the empty address.");

        // get length of path 
        uint len = cycle_path.length;
        // if path is length 0, we can just update directly and return
        if (len == 0) { 
            map[debtor][creditor] += amount; 
            return; 
        }

        // otherwise we must verify that the path is valid 
        // cycle ends at debtor 
        require(debtor == cycle_path[len - 1], "Sender must be at the end of the cycle path.");
        // cycle begins at creditor 
        require(creditor == cycle_path[0], "Creditor must be at the beginning of the cycle path.");

        // first pass: check that the cycle is valid (i.e. edge between all adjacent users)
        // also keep track of min weight along path; initialize to amount
        uint32 min_amount = amount;  
        for (uint i = 0; i < cycle_path.length - 1; i++) { 
            // not a cycle if val ever equals 0
            uint32 val = lookup(cycle_path[i], cycle_path[i+1]); 
            require(val > 0, "Invalid cycle path.");
            if (val < min_amount) min_amount = val; 
        }

        // the path must be valid, thus we update the edge amounts
        for (uint i = 0; i < cycle_path.length - 1; i++) { 
            map[cycle_path[i]][cycle_path[i+1]] -= min_amount; 
        }
        amount -= min_amount; 

        map[debtor][creditor] += amount; 
    }
}
