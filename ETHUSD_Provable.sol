// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "https://raw.githubusercontent.com/provable-things/ethereum-api/master/provableAPI_0.6.sol";

contract ETHUSD is usingProvable {
    uint public etherUSD;
    
    constructor() public payable {}
    
    function update() public payable {
        // provable_query recibe 2 parametros
        // 1.- data source = URL
        // 2.- Parsing helper = json(<url>)
        provable_query(
            "URL",
            "json(https://api.coingecko.com/api/v3/coins/ethereum/tickers?exchange_ids=binance).tickers.0.last"
            );
    }
    
    function __callback(bytes32 myid, string memory result) override public {
        require(msg.sender == provable_cbAddress());        // provable_cbAddress lo provee Provable y sirve para verificar quien puede escribir
        etherUSD = parseInt(result, 2); // 3040.26 -> 304026
    }
}