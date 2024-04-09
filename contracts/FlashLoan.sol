// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";


interface IDex {
    function depositUSDC(uint256 _amount) external;

    function depositDAI(uint256 _amount) external;

    function buyDAI(uint256 _amount) external returns (uint256);

    function sellDAI(uint256 _amount) external returns (uint256);
}

contract FlashLoan is FlashLoanSimpleReceiverBase {
    IPoolAddressesProvider immutable public addressesProvider;
    address payable owner;
    address private immutable dexContractAddress = 0x3f9e8854C643F32A169e794ba4DCf889709A258e;
    address private immutable daiAddressInAave = 0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357;
    address private immutable usdcAddressInAave = 0x94a9D9AC8a22534E3FaCa9F4e7F2E2cf85d5E4C8;
    uint256 private usdcQuantity = 100000000;
    uint256 maxUint = 115792089237316195423570985008687907853269984665640564039457584007913129639935;


    IERC20 private dai;
    IERC20 private usdc;
    IDex private dexContract;

    constructor(address _addressesProvider) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressesProvider)) {
        addressesProvider = IPoolAddressesProvider(_addressesProvider);
        owner = payable(msg.sender);
        dai = IERC20(daiAddressInAave);
        usdc = IERC20(usdcAddressInAave);
        dexContract = IDex(dexContractAddress);
    }

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        require(msg.sender == address(POOL), "only LendingPool can call");

        // Arbitage
        dexContract.depositUSDC(usdcQuantity); // 100 USDC
        uint256 daiBought = dexContract.buyDAI(usdcQuantity);
        dexContract.depositDAI(daiBought);
        uint256 usdcBought = dexContract.sellDAI(daiBought);

        uint256 amountOwedToPool = amount + premium;


        IERC20(asset).approve(address(POOL), amountOwedToPool);

        return true;
    }

    function triggerFlashLoan() public {
        address receiverAddress = address(this);
        address asset = usdcAddressInAave;
        uint256 amount = usdcQuantity;
        bytes memory params = "";
        uint16 referralCode = 0;

       POOL.flashLoanSimple(receiverAddress, asset, amount, params, referralCode);
    }

    function balance(address _tokenAddressInAave) external view returns (uint256) {
        return IERC20(_tokenAddressInAave).balanceOf(address(this));
    }

    function withdraw(address _tokenAddressInAave) external {
        require(msg.sender == owner, "only owner can call");
        IERC20(_tokenAddressInAave).transfer(owner, IERC20(_tokenAddressInAave).balanceOf(address(this)));
    }
    
    //  Less secure, but for testing purposes.
    function approveUSDC() external returns (bool) {
       return usdc.approve(dexContractAddress, maxUint);
    }

    function allowanceUSDC() external view returns (uint256) {
        return usdc.allowance(address(this), dexContractAddress);
    }

    function approveDAI() external returns (bool) {
        return dai.approve(dexContractAddress, maxUint);
    }

    function allowanceDAI() external view returns (uint256) {
        return dai.allowance(address(this), dexContractAddress);
    }

     receive() external payable{}
}