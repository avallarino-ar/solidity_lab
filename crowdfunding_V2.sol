pragma solidity ^0.7.6;

// Libreria util para manejar las fechas de los proyectos
import 'https://github.com/ConsenSysMesh/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol';
// https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol


contract crowdfunding02{
    using SafeMath for uint256;

    // Array de proyectos
    Project[] private projects;

    
    // Generar evento cuando creemos un proyecto
    event ProjectoEmpezado(address direccion_contrato, address creadorProyecto, string tituloProyecto, string descripcionProyecto, uint fechaLimiteRecaudacion, uint montoObjetivo);


    //Funcion para crear proyectos
    function crearProjecto( string calldata titulo, string calldata descripcion, uint duracionEnDias, uint montoARecaudar) external {
    
            uint recaudarHasta = block.timestamp.add(duracionEnDias.mul(1 days));
            Project nuevoProjecto = new Project(msg.sender, titulo, descripcion, recaudarHasta, montoARecaudar);
            projects.push(nuevoProjecto);
            emit ProjectoEmpezado( address(nuevoProjecto), msg.sender, titulo, descripcion, recaudarHasta,montoARecaudar);
    
        }   

   
    //Funcion Get para recuperar las direcciones de los proyectos
    function devolverTodosLosProjects() external view returns(Project[] memory){
        return projects;

    }

}



contract Project {
    using SafeMath for uint256;

    // Estructura de datos para controlar el estado del proyectos
    enum Estado {
        Recaudando,
        Expirado,
        Exitoso
    }   

    // Variables de estado
    address payable public artista;     // Creador del proyecto
    uint public objetivo;               // monto a recaudar
    uint public fechaCompletado;
    uint256 public balanceActual;
    uint public fechaLimite;    
    string public titulo;
    string public descripcion; 

    // - creo variable de tipo Estado, con el valor por defecto Recaudando
    Estado public estado = Estado.Recaudando;

    // - Similar a una tabla con 2 columnas (clave, valor) clave:address, valor:uint
    mapping(address => uint) public direcciones_sponsor;


    // Eventos fondos recibidos y artista pagado
    event FondosRecibidos(address sponsor, uint monto, uint totalActual);
    
    event ArtistaPagado(address beneficiario);

    // Modificadores del estado del proyecto y de comprobar si el sender es el creador del proyecto
    modifier enEstado(Estado _estado) {
        require(estado == _estado);
        _;
    }
    

    // constructor
     constructor(address payable creadorProyecto, string memory tituloProyecto, string memory descripcionProyecto, uint fechaLimiteRecaudacion, uint montoObjetivo) public {
        
        artista = creadorProyecto;
        titulo = tituloProyecto;
        descripcion = descripcionProyecto;
        objetivo = montoObjetivo;
        fechaLimite = fechaLimiteRecaudacion;
        balanceActual = 0;
    }


    // funciones contribuir a un proyecto, comprobar si esta completado o expirado, pagar a artista
    function contribuir() external enEstado(Estado.Recaudando) payable {

        require(msg.sender != artista);
        direcciones_sponsor[msg.sender] = direcciones_sponsor[msg.sender].add(msg.value);
        balanceActual = balanceActual.add(msg.value);
        emit FondosRecibidos(msg.sender, msg.value, balanceActual);
        comprobarEstado();
    }
    
    
    function comprobarEstado() public {

        if (balanceActual >= objetivo) {
            estado = Estado.Exitoso;
            payOut();

        } else if (block.timestamp > fechaLimite)  {
            estado = Estado.Expirado;
        }
        fechaCompletado = block.timestamp;
    }
    
    
    function payOut() internal enEstado(Estado.Exitoso) returns (bool) {

        uint256 totalRecaudado = balanceActual;
        balanceActual = 0;

        if (artista.send(totalRecaudado)) {
            emit ArtistaPagado(artista);
            return true;

        } else {
            balanceActual = totalRecaudado;
            estado = Estado.Exitoso;
        }
        return false;
    }
    
    
     function getDetalles() public view returns (
        address payable creadorProyecto,
        string memory tituloProyecto,
        string memory descripcionProyecto,
        uint256 fechaLimiteRecaudacion,
        Estado estadoActual,
        uint256 montoActual,
        uint256 montoObjetivo) {

        creadorProyecto = artista;
        tituloProyecto = titulo;
        descripcionProyecto = descripcion;
        fechaLimiteRecaudacion = fechaLimite;
        estadoActual = estado;
        montoActual = balanceActual;
        montoObjetivo = objetivo;
    }
}