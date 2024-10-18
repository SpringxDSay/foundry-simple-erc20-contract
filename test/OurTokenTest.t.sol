// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from 'forge-std/Test.sol';
import {OurToken} from 'src/OurToken.sol';
import {DeployOurToken} from '../script/DeployOurToken.s.sol';

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr('bob');
    address alice = makeAddr('alice');
    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run(); 

        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testInitialSupply() public view {
        assertEq(ourToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testBobBalance() public view {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }

    function testAllowancesWorks() public {
        // Arrange / Act
        uint256 initialAllowance = 100;

        // Bob allows alice to send his tokens
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);
        uint256 transferAmount = 50;
        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        // Assert
        assertEq(transferAmount, ourToken.balanceOf(alice));
        assertEq(STARTING_BALANCE - transferAmount, ourToken.balanceOf(bob));

    }

    // Transfers: Test simple transfers
    function testTransfer() public {
        uint256 transferAmount = 20 ether;

        vm.prank(bob);
        ourToken.transfer(alice, transferAmount);

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    // Transfer Failures: Test transferring more than balance
    function testTransferMoreThanBalance() public {
        uint256 transferAmount = 2000 ether;

        vm.prank(bob);
        vm.expectRevert();
        ourToken.transfer(alice, transferAmount);
    }

    // Transfer From Failures: Test transferring more than allowance
    function testTransferFromMoreThanAllowance() public {
        uint256 allowanceAmount = 100 ether;
        uint256 transferAmount = 200 ether;

        vm.prank(bob);
        ourToken.approve(alice, allowanceAmount);

        vm.prank(alice);
        vm.expectRevert();
        ourToken.transferFrom(bob, alice, transferAmount);
    }

    // Test that allowances decrease correctly after a transferFrom
    function testAllowanceDecreaseAfterTransferFrom() public {
        uint256 allowanceAmount = 50 ether;
        uint256 transferAmount = 20 ether;

        vm.prank(bob);
        ourToken.approve(alice, allowanceAmount);

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.allowance(bob, alice), allowanceAmount - transferAmount);
    }
}