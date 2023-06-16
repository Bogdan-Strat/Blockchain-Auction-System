// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import {Licitatie} from './Auction.sol';

contract GestionareLicitatii {
    Licitatie[] licitatii;

    event LicitatieCreata(address adresaBeneficiar, string numeLicitatie, uint durataLicitatie, uint sumaStart);

    constructor(){

    }

    function creeazaLicitatie(address adresaBeneficiar, string memory numeLicitatie, uint durataLicitatie, uint sumaStart) public {
        Licitatie licitatie = new Licitatie(payable(msg.sender), numeLicitatie, durataLicitatie, sumaStart);
        licitatii.push(licitatie);

        emit LicitatieCreata(adresaBeneficiar, numeLicitatie, durataLicitatie, sumaStart);
    }

    function veziToateictatiile() public view returns(Licitatie[] memory){
        return licitatii;
    }
}