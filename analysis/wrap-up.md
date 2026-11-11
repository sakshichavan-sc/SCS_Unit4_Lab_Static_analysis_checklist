# Section 5 – Wrap-Up

## 1. Which issue would you fix first, and why?

I would fix the reentrancy issue in the `withdraw()` function first. The contract sends ETH before updating the user's balance. A malicious user could use this to call the withdrawal function again before the balance is updated.

This could lead to users withdrawing more ETH than they should. I would update the contract state before transferring ETH and add reentrancy protection.

## 2. Which Slither finding was higher impact than it deserved, and which issue was lower impact or not reported?

The `low-level-calls` finding may look serious at first, but using `call` to transfer ETH is not automatically a vulnerability. It depends on how the contract handles state updates and reentrancy.

On the other hand, the unrestricted `setRewardRate()` function was not reported by Slither. However, it is an important issue because anyone can change the reward rate.

This shows why manual code review is also necessary.

## 3. Why can't a static analyser decide whether setRewardRate() should be restricted?

A static analyser can check whether a function has an access-control modifier, but it cannot understand the complete business requirements of the project.

For example, the project might intentionally allow all users to change the reward rate, or it might be a function that only the owner should control.

The decision depends on the project's requirements and trust model. A developer or auditor must make that decision.

## 4. What would you say if someone suggested excluding low and informational findings in CI?

I would not recommend completely ignoring low and informational findings. Some small issues can become important when combined with other vulnerabilities.

I would keep the complete Slither report and review all findings. In CI, high and medium findings can be treated as build-blocking issues, while low and informational findings can be recorded and reviewed separately.

This helps the team avoid missing potential problems.

## Final Conclusion

Through this lab, I learned how to use Slither for static analysis and how to review a smart contract manually.

I understood that automated tools can identify suspicious code patterns, but they cannot replace human understanding of contract logic and business requirements.

Combining static analysis with manual review gives a better understanding of smart contract security.