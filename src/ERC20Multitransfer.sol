// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Context} from "@openzeppelin/contracts/utils/Context.sol";

/**
 * @notice Extension of {ERC20} that allows multiple transfers in a single transaction.
 */
abstract contract ERC20Multitransfer is Context, ERC20 {
    // Errors
    error RecipientsLengthsMismatch();

    /**
     * @notice Transfers tokens to multiple recipients in a single transaction.
     * @param recipients The addresses to transfer to.
     * @param amounts The amounts to be transferred to each address.
     */
    function multitransfer(address[] calldata recipients, uint256[] calldata amounts) external {
        // Ensure that the number of recipients and amounts match
        require(recipients.length == amounts.length, RecipientsLengthsMismatch());

        // Transfer tokens to each recipient
        for (uint256 i = 0; i < recipients.length; i++) {
            _transfer(_msgSender(), recipients[i], amounts[i]);
        }
    }
}
