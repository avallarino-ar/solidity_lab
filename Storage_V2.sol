// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
interface MiniStorage {
    function setMini(uint8 miniInt) external;  // external permite que sea accedido desde otro contrato
}
*/

// contract StorageV2 is MiniStorage {
contract StorageV2 {    
    // Variables
    uint public storedInt;
    string public storedString;
    uint[] public storedArray;
    address public owner;
    
    // Events
    event SetInt(uint storedInt);
    
    
    // Modifiers
    modifier onlyOwner() {
        require(owner == msg.sender, "Sender is not the owner");
        _;
    }
    
    // Constructor
    constructor() {
        owner = msg.sender;
    }
    
    // Methods
    function setInt(uint _storedInt) public onlyOwner {
        storedInt = _storedInt;
        emit SetInt(_storedInt);
    }
    
    function setString(string memory _storedString) public onlyOwner {
         // en caso de String se agrega memory porque un string es un tipo de datos complejo puede ser de long variable - Otra opcion es calldata
        storedString = _storedString;
    }
    
    function pushArray(uint _pushInt) public onlyOwner {
        storedArray.push(_pushInt);
    }
    
    function setOwner(address _owner) public onlyOwner {
        owner = _owner;
    }
    
    

    
    /*
    // este metodo esta definido en la interface, por lo tanto requiere que se implemente:
    function setMini(uint8 miniInt) {
        
    }
    
    // si en la variable indico public, genera los metodos get
    function getInt() public view returns (uint) {
        return storedInt;
    }
    
    
    function getString() public view returns (string memory) {
        return storedString;
    }
    */   
}