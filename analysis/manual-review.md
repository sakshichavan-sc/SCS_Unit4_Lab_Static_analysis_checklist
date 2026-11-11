# Section 4 – Manual Checklist Review

While checking the `CommunityVault.sol` contract manually, I found some issues that could affect the security and working of the contract. Some were also detected by Slither, while others required checking the code myself.

## 1. Issues Found During Manual Review

| Function | Issue Found | Slither Reported? | Severity | Suggested Fix |
|---|---|---|---|---|
| `onlyOwner` | The contract uses `tx.origin` instead of `msg.sender` for checking the owner. This can create an authorization problem if a malicious contract is involved. | No | High | Use `msg.sender` for owner verification. |
| `withdraw()` | ETH is transferred before updating the user's balance. A malicious user may try to call the function again through a callback. | Yes – `reentrancy-eth` | High | Update the balance before transferring ETH and use reentrancy protection. |
| `claimReward()` | The user's reward details are not updated after claiming. This may allow the same reward to be claimed again if enough funds remain. | Partially – `reentrancy-events` | High | Maintain a reward checkpoint for every user. |
| `setRewardRate()` | Anyone can change the reward rate because there is no owner restriction. | No | High | Add an owner restriction and a maximum rate. |
| `constructor()` / `setTreasury()` | The treasury address can be set to zero. | Yes – `missing-zero-check` | Medium | Add a zero-address check. |
| `transferOwnership()` | A zero address can be assigned as the new owner. This may cause the contract to lose its owner. | Yes – `missing-zero-check` | Medium | Check that the new owner is not zero. |
| `emergencyWithdrawAll()` | The owner can withdraw the entire contract balance, including users' deposits and reward funds. | No | Critical – design risk | Allow withdrawal of surplus only, or clearly document this owner privilege. |
| `pendingReward()` | Division happens before multiplication, which can reduce the accuracy of reward calculations. | Yes – `divide-before-multiply` | Low | Review the calculation order to reduce precision loss. |
| `deposit()` | If a user deposits again, the deposit timestamp is reset for their entire balance. | No | Medium | Track separate deposits or their individual lock periods. |
| `deposit()` | The strict equality check can stop new deposits if extra ETH is sent directly to the contract. | Yes – `incorrect-equality` | Low | Handle extra ETH separately in the accounting logic. |
| `sweepSurplus()` | Anyone can call this function and choose where the surplus ETH is sent. | Partially – `missing-zero-check` | Low | Restrict the recipient or clearly document this behaviour. |

## 2. Manual Checklist

**1. Access Control**

The owner-only functions use the `onlyOwner` modifier, but it checks `tx.origin`. Also, `setRewardRate()` has no access restriction, so anyone can change the reward rate. `sweepSurplus()` is also open to everyone.

**2. Authentication**

Using `tx.origin` for owner verification is not a good practice. It is safer to use `msg.sender` because it checks the account directly calling the contract.

**3. Checks-Effects-Interactions**

In `withdraw()`, ETH is transferred before updating the user's balance. This creates a reentrancy risk. In `claimReward()`, the reward pool is reduced, but the user's reward entitlement is not updated before the external call.

**4. Arithmetic**

The withdrawal function uses unchecked subtraction. The reward calculation also performs division before multiplication, which can cause precision loss. The surplus calculation may revert if the contract balance is less than its recorded liabilities.

**5. State Reset**

Every time a user deposits again, the deposit timestamp is reset. This affects the lock period of the entire balance. Also, `claimReward()` does not maintain a separate record of the last claimed reward period.

**6. Accounting Invariants**

The contract checks whether its balance exactly matches the recorded deposits and reward pool. If someone sends extra ETH directly to the contract, this check may fail and prevent further deposits. The emergency withdrawal function can also remove funds that belong to users.

**7. Admin Parameters**

The reward rate can be changed by anyone. There is no maximum limit on the rate. The contract should also emit events when important settings are changed.

**8. Address Inputs**

The constructor, treasury setter and ownership transfer function do not properly reject zero addresses. This should be checked to avoid configuration problems.

**9. Denial of Service**

If the treasury address does not accept ETH, `emergencyWithdrawAll()` may fail. Similarly, a user may not be able to withdraw or claim rewards if their receiving address rejects ETH.

**10. Centralisation**

The owner has significant control over the contract because they can withdraw the complete balance. If the owner's account is compromised, user deposits and reward funds could be at risk.

## 3. Additional Findings from Slither

During the analysis, Slither reported issues related to:

- Reentrancy in `withdraw()`.
- Strict equality in `deposit()`.
- Precision loss in `pendingReward()`.
- Missing events for ownership changes and reward funding.
- Missing zero-address checks.
- Timestamp comparisons.
- Low-level ETH calls.

The `events-access` warning was selected for inline suppression. After adding the suppression comment and running Slither again, the total findings decreased from 17 to 16.

## 4. Conclusion

This manual review helped me understand that not every security issue can be found using an automated tool. Slither identified several important code patterns, but I also found issues related to access control, reward calculation, deposit timestamps and owner privileges by reading the contract myself.

I learned that both automated analysis and manual code review are important when checking the security of a smart contract.

These findings should be tested further before considering them confirmed exploits.