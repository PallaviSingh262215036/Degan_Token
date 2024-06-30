// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";


contract DegenToken is ERC20 {
    address public treasury;
    uint256 public transferFeePercentage = 3; // 3% transfer fee
    uint256 public rewardPercentage = 2; // 2% reward for holding tokens
    uint256 public rewardPeriod = 30 days; // Reward period
    address public owner;
    uint256 public TotalSupply;


    // Structure to represent an in-game item
    struct Item {
        string name;
        uint256 cost; // Cost in DegenTokens
    }

    // Array of available items
    Item[] public items;


    mapping(address=>uint256) public BalanceOf; 
    // Mapping to track redeemed items by user
    mapping(address => mapping(uint256 => uint256)) public redeemedItems;
    mapping(address => uint256) public lastClaimedReward;

    
   constructor(address _treasury ) ERC20("DegenToken", "DGN") {
        owner=msg.sender;
        require(_treasury != address(0), "Treasury address cannot be zero address");
        treasury = _treasury;
    
        // Initialize with some items
        items.push(Item("Sword", 100));
        items.push(Item("Shield", 150));
        items.push(Item("Health Potion", 50));
    }
    
    modifier onlyOwner(){
      require(owner==msg.sender,"Only Owner");
      _;
    }

    // Minting new tokens with time lock
    
    function mintToken(address to, uint256 amount) public onlyOwner {
        require(to!=address(0),"You are minting to Zero address");
         BalanceOf[to]+=amount;
         TotalSupply+=amount;   
    }

    // Redeeming tokens for items
    function redeem(uint256 itemId, uint256 quantity) external {
        require(itemId < items.length, "Invalid item ID");
        require(quantity > 0, "Quantity must be greater than 0");

        uint256 totalCost = items[itemId].cost * quantity;
        require(BalanceOf[msg.sender] >= totalCost, "Not enough tokens to redeem");

        BalanceOf[msg.sender]-=totalCost;
        redeemedItems[msg.sender][itemId] += quantity;  
    }

    // Burning tokens
    function burnToken(uint256 amount) public {
        require(BalanceOf[msg.sender] >= amount, "Not enough tokens to burn");
        BalanceOf[msg.sender]-=amount;
        TotalSupply-=amount;
        
    }

   //Transfer logic internaal function
   function transfer_logic(address from, address to, uint256 amount) internal {
     require(from!=address(0),"Invalid address");
     require(to!=address(0),"You are sending to invalid address");
     require(BalanceOf[from]>amount,"Insufficient balance");
     BalanceOf[from]-=amount;
     BalanceOf[to]+=amount;
   }
   
    //  Transfer function to include fee and reward mechanism
    function transfer( address recipient, uint256 amount) public override returns(bool) {
        uint256 fee = (amount * transferFeePercentage) / 100;
        uint256 transferAmount = amount - fee;

        // Transfer fee to treasury
        transfer_logic(msg.sender, treasury, fee);

        // Transfer remaining tokens to recipient
        transfer_logic(msg.sender, recipient, transferAmount);

        // Update last claimed reward timestamp
        if (block.timestamp >= lastClaimedReward[msg.sender] + rewardPeriod) {
            uint256 reward = (BalanceOf[msg.sender] * rewardPercentage) / 100;
            mintToken(msg.sender, reward);
            lastClaimedReward[msg.sender] = block.timestamp;
        }
        
        return true;
    }
    
    // Function to add new items to the inventory
    function addItem(string memory name, uint256 cost) external onlyOwner {
        items.push(Item(name, cost));
    }

    // Function to update item cost
    function updateItemCost(uint256 itemId, uint256 newCost) external onlyOwner {
        require(itemId < items.length, "Invalid item ID");
        items[itemId].cost = newCost;
    }

    // Function to get items count
    function getItemsCount() external view returns (uint256) {
        return items.length;
    }
}
