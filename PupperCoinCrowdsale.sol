pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/math/SafeMath.sol";

contract PupperCoinSale is Crowdsale, MintedCrowdsale {
     // Build the constructor, passing in the parameters that Crowdsale needs
   
    constructor(
        uint rate,  // rate in TKNBits
        address payable wallet, // sale beneficiary
        PupperCoin token
    )
        Crowdsale(rate, wallet, token)
        public
        
    {
        // constructor can stay empty
    }
}

contract PupperCoinSaleDeployer {
    using SafeMath for uint256;
    uint256 private _cap;
    address public token_sale_address;
    address public token_address;
    uint256 goal;
    // uint256 private _openingTime;
    // uint256 private _closingTime;
    uint256 open = now;  // permanently store the time this contract was initialized 
    uint256 close = open + 24 weeks; // Set the closing time to be 24 weeks after openingTime
    uint256 fakenow = now;
    function fastforward () public{
        fakenow += 10 minutes;
    }
    
    constructor(
        string memory name, 
        string memory symbol, 
        address payable wallet,  // this addresss will receive all Ether raised by the sale
        uint256 cap
    )
        
        public 
    {
        // create the PupperCoin and keep its address handy
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);


        // create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        PupperCoinSale pupper_sale = new PupperCoinSale(1, wallet, token);
        token_sale_address = address(pupper_sale);

        // cap Max amount of wei to be contributed
        require(cap == 10000 wei, "CappedCrowdsale: goal is 10,000 wei");

        // solhint-disable-next-line not-rely-on-time
        require(open <= fakenow, "TimedCrowdsale: opening time is before current time");
        // solhint-disable-next-line max-line-length
        require(close >= fakenow, "TimedCrowdsale: opening time is not before closing time");

        
        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}
