// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

contract Licitatie {
        // parametrii contractului Licitatie 
        address payable public beneficiar;
        string public numeLicitatie;
        uint public timpFinalizare;

        // starea generala a contractului
        address public topLicitator;
        uint public topSumaLicitata;

        mapping(address => uint) public sumeRetinute;

        bool eIncheiata = false;

        event SumaLicitataACrescut(address licitator, string numeLicitatie, uint suma);
        event LicitatieIncheiata(address castigator, string numeLicitatie, uint suma);

        constructor(address payable _beneficiar, string memory _numeLicitatie, uint _timp, uint _sumaPornire){
            beneficiar = _beneficiar;
            numeLicitatie = _numeLicitatie;
            timpFinalizare = block.timestamp + _timp;
            topSumaLicitata = _sumaPornire;
        }

        function liciteaza() public payable {
            if(block.timestamp > timpFinalizare){
                revert("Licitatia s-a incheiat deja");
            }

            if(msg.value > topSumaLicitata){
                sumeRetinute[topLicitator] += topSumaLicitata;
                topSumaLicitata = msg.value;
                topLicitator = msg.sender;

                emit SumaLicitataACrescut(topLicitator, numeLicitatie, topSumaLicitata);
            }
            else 
            {
                revert("S-a licitat deja mai mult.");
            }
        }

        function inapoiaza() public returns(bool) {
            uint sumaTotala = sumeRetinute[msg.sender];
            if (sumaTotala > 0){
                if(!payable(msg.sender).send(sumaTotala)){
                    return false;
                }
            }
            
            sumeRetinute[msg.sender] = 0;

            return true;
        }

        function inchideLicitatia() public {
            if (block.timestamp > timpFinalizare){
                eIncheiata = true;
                emit LicitatieIncheiata(topLicitator, numeLicitatie, topSumaLicitata);
                beneficiar.transfer(topSumaLicitata);
            }
            else{
                revert("Licitatia nu s-a incheiat inca");
            }
        }

}