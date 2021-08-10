pragma solidity ^0.7.6;

contract crowdfunding{
    
    address private owner;
    
    constructor() public {
        owner = msg.sender;    
    }    
    
    
    modifier isOwner(){
        require(owner == msg.sender);
        _;  // placeholder, cuando se comprueba si es el propietario se reemplaza por el codigo de la func. setSponsor
    }    
    
    
    string public nombre;
    string public apellido;
    
    uint public objetivo = 10 ether;
    uint public balance;
    uint public totalRecaudado;
    
    address payable public artista = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148;
    
    function setSponsor(string memory nombre_sponsor, string memory apellido_sponsor)  public isOwner payable {
        
        nombre = nombre_sponsor;
        apellido = apellido_sponsor;
        
        require(msg.value > 1 ether);
        
        balance = balance + msg.value;
        
        if(balance>=objetivo){
            payOut();
        }
    }
    
    
    function getSponsor()  public view returns(string memory, string memory){
        
        return(nombre, apellido);
    }
    
    
    function payOut()  private{
        
        totalRecaudado = balance;
        balance = 0;
        
        artista.transfer(totalRecaudado);
        
    }
    
}
