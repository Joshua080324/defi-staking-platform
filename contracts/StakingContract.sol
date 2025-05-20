// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
}

contract StakingContract {
    IERC20 public stakingToken;
    IERC20 public rewardToken;

    mapping(address => uint256) public balances;
    mapping(address => uint256) public rewardDebt;

    uint256 public rewardRate = 100; // reward per block (example)
    uint256 public lastUpdateBlock;

    constructor(address _stakingToken, address _rewardToken) {
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
        lastUpdateBlock = block.number;
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be > 0");

        updateReward(msg.sender);

        stakingToken.transferFrom(msg.sender, address(this), amount);
        balances[msg.sender] += amount;
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Not enough staked");

        updateReward(msg.sender);

        balances[msg.sender] -= amount;
        stakingToken.transfer(msg.sender, amount);
    }

    function claimReward() external {
        updateReward(msg.sender);

        uint256 reward = rewardDebt[msg.sender];
        require(reward > 0, "No rewards");

        rewardDebt[msg.sender] = 0;
        rewardToken.transfer(msg.sender, reward);
    }

    function updateReward(address user) internal {
        uint256 blocksPassed = block.number - lastUpdateBlock;
        lastUpdateBlock = block.number;

        uint256 reward = balances[user] * rewardRate * blocksPassed / 1e18;
        rewardDebt[user] += reward;
    }
}
