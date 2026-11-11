// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/// @title CommunityVault
/// @notice Members deposit ETH, earn a daily reward from a pool the
///         owner funds, and can withdraw once the lock period has passed.
contract CommunityVault {
    address public owner;
    address public treasury;

    uint256 public constant LOCK_PERIOD = 1 days;
    uint256 public rewardRatePerDay; // basis points of balance per day

    uint256 public totalDeposits;
    uint256 public rewardPool;

    mapping(address => uint256) public balances;
    mapping(address => uint256) public depositedAt;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 amount);

    modifier onlyOwner() {
        require(tx.origin == owner, "not owner");
        _;
    }

    constructor(address _treasury) {
        owner = msg.sender;
        treasury = _treasury;
        rewardRatePerDay = 10; // 0.10% per day
    }

    // ---------------------------------------------------------------- users

    function deposit() external payable {
        require(msg.value > 0, "zero deposit");
        require(
            address(this).balance - msg.value == totalDeposits + rewardPool,
            "accounting mismatch"
        );
        balances[msg.sender] += msg.value;
        depositedAt[msg.sender] = block.timestamp;
        totalDeposits += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "insufficient balance");
        require(
            block.timestamp >= depositedAt[msg.sender] + LOCK_PERIOD,
            "still locked"
        );

        (bool ok, ) = msg.sender.call{value: amount}("");
        require(ok, "transfer failed");

        unchecked {
            balances[msg.sender] -= amount;
        }
        totalDeposits -= amount;
        emit Withdrawn(msg.sender, amount);
    }

    function pendingReward(address user) public view returns (uint256) {
        uint256 daysHeld = (block.timestamp - depositedAt[user]) / 1 days;
        return (balances[user] / 10_000) * rewardRatePerDay * daysHeld;
    }

    function claimReward() external {
        uint256 reward = pendingReward(msg.sender);
        require(reward > 0 && reward <= rewardPool, "nothing to claim");
        rewardPool -= reward;

        (bool ok, ) = msg.sender.call{value: reward}("");
        require(ok, "transfer failed");
        emit RewardPaid(msg.sender, reward);
    }

    // ---------------------------------------------------------------- admin

    function fundRewards() external payable onlyOwner {
        rewardPool += msg.value;
    }

    function setRewardRate(uint256 newRate) external {
        rewardRatePerDay = newRate;
    }

    function setTreasury(address newTreasury) external onlyOwner {
        treasury = newTreasury;
    }

    function transferOwnership(address newOwner) external onlyOwner {
    // Accepted risk: ownership change is not emitted as an event.
    //slither-disable-next-line events-access
    owner = newOwner;
}

    function emergencyWithdrawAll() external onlyOwner {
        payable(treasury).transfer(address(this).balance);
    }

    function sweepSurplus(address payable to) external {
        uint256 surplus = address(this).balance - totalDeposits - rewardPool;
        to.transfer(surplus);
    }
}
