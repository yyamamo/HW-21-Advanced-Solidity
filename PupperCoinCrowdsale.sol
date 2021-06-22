pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/math/SafeMath.sol";

contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale { 
     // Build the constructor, passing in the parameters that Crowdsale needs

    constructor(
        uint rate,  // rate in TKNBits
        address payable wallet, // sale beneficiary
        PupperCoin token,
        uint256 cap,
        uint256 openingTime,
        uint256 closingTime
    )
        Crowdsale(rate, wallet, token)
        CappedCrowdsale(cap)
        TimedCrowdsale(openingTime, closingTime)
        RefundableCrowdsale(cap)
        public
        
        {   
    
        }
    
}

contract PupperCoinSaleDeployer {
    using SafeMath for uint256;
    address public token_sale_address;
    address public token_address;
    
    // To test the TimedCrowdsales
    // uint fakenow = now;
    // function fastforward() public {
    // fakenow += 2 minutes;
    //   }    
        
    constructor(
        string memory name, 
        string memory symbol, 
        address payable wallet 
     
    )
        
        public 
    {
        // create the PupperCoin and keep its address handy
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);
    

        // create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
  
        PupperCoinSale pupper_sale = new PupperCoinSale(1, wallet, token, 5000000000000000000, now, now + 24 weeks);
        token_sale_address = address(pupper_sale);
        
        
        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
    
}


