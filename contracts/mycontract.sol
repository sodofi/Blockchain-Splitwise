// SPDX-License-Identifier: UNLICENSED

// DO NOT MODIFY BELOW THIS
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract Splitwise {
// DO NOT MODIFY ABOVE THIS

// ADD YOUR CONTRACT CODE BELOW

    struct IOU { 
        address creditor_addr;
        uint32 amount;
    }

    mapping (address => IOU[]) public map;  
    address[] public debtors; 

    function lookup(address debtor, address creditor) public view returns (uint32 ret) { 
        // get creditors 
        IOU[] storage creditors = map[debtor]; 
        // loop over creditors 
        for (uint i = 0; i < creditors.length; i++ ) { 
            if (creditors[i].creditor_addr == creditor) { 
                return(creditors[i].amount);
            }
        }
        return(0);
    }

    function add_IOU(address creditor, uint32 amount) public { 
        address debtor = msg.sender; 
        IOU[] storage creditors = map[debtor]; 
        if (lookup(debtor, creditor) > 0 ) { 
            // already exists
            for (uint i = 0; i < creditors.length; i++ ) { 
                if (creditors[i].creditor_addr == creditor) { 
                    creditors[i].amount += amount;
                    break;
                }
            }
        } else { 
            debtors.push(debtor);
            // append to end 
            IOU memory x = IOU({creditor_addr:creditor, amount:amount}); 
            creditors.push(x);
        }
    }
}
