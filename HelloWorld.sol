pragma solidity ^0.8.4;

contract HelloWorld{
    
    string public saludo = "Hello World";
    
    function escribirSaludo(string memory _helloWorld) public {
        
        saludo = _helloWorld;
    }
    
    
    function getSaludo() public view returns(string memory){
        
        return saludo;
    }
}