# Section 1 — Reconnaissance and threat model

This is the initial source-based review, prepared before running Slither as required by the handout.

## Actors
- Members/depositors: any address can call `deposit`, `withdraw` and `claimReward`.
- Owner: the address stored in `owner`; owner-only actions are checked using `tx.origin`, not `msg.sender`.
- Treasury: destination of the full-balance emergency withdrawal.
- Reward funder: the owner funds the reward pool through `fundRewards`.
- Arbitrary callers: anyone can call `setRewardRate` and `sweepSurplus`.
- Contract recipients: a depositor or reward claimant may be a contract that executes code when receiving ETH.

## Assets
- ETH deposited by members, represented by `totalDeposits` and `balances`.
- ETH reserved for rewards, represented by `rewardPool`.
- Owner-controlled treasury and reward-rate configuration.
- Availability of member withdrawals and reward claims.
- Integrity of member balances and reward accounting.

## Functions that move ETH out
- `withdraw(uint256 amount)`: sends ETH to `msg.sender`.
- `claimReward()`: sends reward ETH to `msg.sender`.
- `emergencyWithdrawAll()`: sends the entire contract balance to `treasury`.
- `sweepSurplus(address payable to)`: sends the calculated surplus to a caller-selected address.

## Trust assumptions
- The owner key and `tx.origin` are trusted for owner-only operations.
- The treasury address is valid and able to receive ETH.
- External recipient contracts may execute arbitrary code or reject ETH.
- `block.timestamp` is suitable for a one-day lock boundary, but should not be treated as secure randomness.
- The design assumes accounting fields correctly represent liabilities and that unsolicited ETH is handled by the surplus mechanism.
- The design does not establish who is authorised to set the reward rate; the code currently allows any caller.

## Invariants
1. Under the intended accounting model, `address(this).balance >= totalDeposits + rewardPool`. The difference is unallocated surplus; deposits and reward funding must not make the balance fall below recorded liabilities.
2. For every member `u`, `balances[u]` must not be reduced more than once for the same withdrawal, and the sum of member balances should equal `totalDeposits`.

## Important review note
The source does not provide a complete specification for whether reward-rate changes should be public, whether surplus should be sweepable by anyone, or whether the owner is intentionally allowed to withdraw member liabilities. Those are design/trust questions and must be stated as assumptions rather than silently treated as safe.
