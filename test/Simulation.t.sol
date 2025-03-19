// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {ERC20, ERC20Multitransfer} from "../src/ERC20Multitransfer.sol";
import {ERC20StandardMultitransfer} from "../src/ERC20StandardMultitransfer.sol";
import {ERC20NonStandardMultitransfer} from "../src/ERC20NonStandardMultitransfer.sol";

import {IERC20} from "forge-std/interfaces/IERC20.sol";

contract ERC20Multitransferable is ERC20, ERC20Multitransfer {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(_msgSender(), 10 ** 20);
    }
}

contract ERC20StandardMultitransferable is ERC20StandardMultitransfer {
    constructor(string memory name, string memory symbol) ERC20StandardMultitransfer(name, symbol) {
        _mint(_msgSender(), 10 ** 20);
    }
}

contract ERC20NonStandardMultitransferable is ERC20NonStandardMultitransfer {
    constructor(string memory name, string memory symbol) ERC20NonStandardMultitransfer(name, symbol) {
        _mint(_msgSender(), 10 ** 20);
    }
}

contract Simulation is Test {
    ERC20Multitransferable internal extendedToken;
    ERC20StandardMultitransferable internal standardToken;
    ERC20NonStandardMultitransferable internal nonStandardToken;

    address internal sender = makeAddr("sender");

    address[] internal recipients;
    uint256[] internal amounts;

    function setUp() public {
        vm.startPrank(sender);
        extendedToken = new ERC20Multitransferable("Test", "TST");
        standardToken = new ERC20StandardMultitransferable("Test", "TST");
        nonStandardToken = new ERC20NonStandardMultitransferable("Test", "TST");
        vm.stopPrank();

        uint256 length = 1000;
        uint256 amount = 100;

        _populateRecipientsAndAmounts(length, amount);
    }

    function test_simulate_sequential_transfers() public {
        vm.startPrank(sender);
        vm.startSnapshotGas("Gas: Sequential transfers");
        for (uint256 i = 0; i < recipients.length; i++) {
            extendedToken.transfer(recipients[i], amounts[i]);
        }
        uint256 gasUsedI = vm.stopSnapshotGas();
        vm.stopPrank();

        _verifyBalances(address(extendedToken));

        console.log("Sequential Transfers --- gas used: %d", gasUsedI);

        vm.startPrank(sender);
        vm.startSnapshotGas("Gas: Sequential transfers already initialized");
        for (uint256 i = 0; i < recipients.length; i++) {
            extendedToken.transfer(recipients[i], amounts[i]);
        }
        uint256 gasUsedII = vm.stopSnapshotGas();
        vm.stopPrank();

        console.log("Sequential Transfers (already initialized) --- gas used: %d", gasUsedII);
    }

    function test_simulate_multi_transfer_extension() public {
        vm.startPrank(sender);
        vm.startSnapshotGas("Gas: Multitransfer extension");
        extendedToken.multitransfer(recipients, amounts);
        uint256 gasUsedI = vm.stopSnapshotGas();
        vm.stopPrank();

        _verifyBalances(address(extendedToken));

        console.log("Multitransfer extension --- gas used: %d", gasUsedI);

        vm.startPrank(sender);
        vm.startSnapshotGas("Gas: Multitransfer extension already initialized");
        extendedToken.multitransfer(recipients, amounts);
        uint256 gasUsedII = vm.stopSnapshotGas();
        vm.stopPrank();

        console.log("Multitransfer extension (already initialized) --- gas used: %d", gasUsedII);
    }

    function test_simulate_multi_transfer_standard() public {
        vm.startPrank(sender);
        vm.startSnapshotGas("Gas: Multitransfer standard");
        standardToken.multitransfer(recipients, amounts);
        uint256 gasUsedI = vm.stopSnapshotGas();
        vm.stopPrank();

        _verifyBalances(address(standardToken));

        console.log("Multitransfer Standard --- gas used: %d", gasUsedI);

        vm.startPrank(sender);
        vm.startSnapshotGas("Gas: Multitransfer standard already initialized");
        standardToken.multitransfer(recipients, amounts);
        uint256 gasUsedII = vm.stopSnapshotGas();
        vm.stopPrank();

        console.log("Multitransfer Standard (already initialized) --- gas used: %d", gasUsedII);
    }

    function test_simulate_multi_transfer_non_standard() public {
        vm.startPrank(sender);
        vm.startSnapshotGas("Gas: Multitransfer non-standard");
        nonStandardToken.multitransfer(recipients, amounts);
        uint256 gasUsedI = vm.stopSnapshotGas();
        vm.stopPrank();

        _verifyBalances(address(nonStandardToken));

        console.log("Multitransfer Non-standard --- gas used: %d", gasUsedI);

        vm.startPrank(sender);
        vm.startSnapshotGas("Gas: Multitransfer non-standard already initialized");
        nonStandardToken.multitransfer(recipients, amounts);
        uint256 gasUsedII = vm.stopSnapshotGas();
        vm.stopPrank();

        console.log("Multitransfer Non-standard (already initialized) --- gas used: %d", gasUsedII);
    }

    function _verifyBalances(address _token) internal view {
        uint256 totalAmount = 0;
        IERC20 token = IERC20(_token);
        for (uint256 i = 0; i < recipients.length; i++) {
            assertEq(token.balanceOf(recipients[i]), amounts[i]);
            totalAmount += amounts[i];
        }
        assertEq(token.balanceOf(sender), 10 ** 20 - totalAmount);
        assertEq(token.totalSupply(), 10 ** 20);
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
