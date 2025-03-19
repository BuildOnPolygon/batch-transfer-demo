// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {ERC20, ERC20Multitransfer} from "../src/ERC20Multitransfer.sol";

contract ERC20Multitransferable is ERC20, ERC20Multitransfer {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(_msgSender(), type(uint256).max);
    }
}

contract ERC20MultitransferTest is Test {
    ERC20Multitransferable internal token;

    address internal sender = makeAddr("sender");

    address[] internal recipients;
    uint256[] internal amounts;

    function setUp() public {
        vm.prank(sender);
        token = new ERC20Multitransferable("Test", "TST");

        uint256 length = 100;
        uint256 amount = 100;

        _populateRecipientsAndAmounts(length, amount);
    }

    function test_simulateRegularTransfers() public {
        vm.startPrank(sender);
        for (uint256 i = 0; i < recipients.length; i++) {
            token.transfer(recipients[i], amounts[i]);
        }
        vm.stopPrank();
    }

    function test_simulateMultiTransfer() public {
        vm.startPrank(sender);
        token.multitransfer(recipients, amounts);
        vm.stopPrank();
    }

    function _populateRecipientsAndAmounts(uint256 length, uint256 amount) internal {
        recipients = new address[](length);
        amounts = new uint256[](length);

        for (uint256 i = 0; i < length; i++) {
            recipients[i] = makeAddr(vm.toString(i));
            amounts[i] = amount;
        }
    }
}
