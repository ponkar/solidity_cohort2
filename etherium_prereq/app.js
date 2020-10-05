
const Web3 = require('web3');
const solc = require('solc');
const fs = require('fs');
const express = require('express');
const url = require('url');
const morgan = require('morgan');
const { query, json } = require('express');
const path = require('path');
const app = express();

// Middlewares
app.use(express.json());
app.use((req, res, next) => {
  req.requestTime = new Date().toISOString();
  next();
});

app.use(morgan('tiny'));

const port = 3000;


  

//Accounts 
const accountAddress = "0x892BE8EA286CB9eE43728a37edD72bb8ffDaE623"
const accountAddress2 = "0xEDF015954CEa6f689eb9341CABa89FC8Ec072057"
const pkey = "9e0d96cbe005fc40ee1c628f61ea73b36d53409109a4481ea373f2bb92cd6040"
const Candidate_Contract_Address = "0x475b01dFFAf712F42462B27D0967Cbf45001D16E"
const input = fs.readFileSync('./../solidity_assignments/general_elections/Candidate.sol', 'utf-8');

let complierInput = {
    language: 'Solidity',
    sources:
    {
        'Candidate.sol': 
        {
            content: input.toString()
        }
    },
    settings:
    {
        optimizer:
        {
            enabled: true
        },
        outputSelection:
        {
            '*':{
                '*':['*']
            }
        }
    }
};
const output = solc.compile(JSON.stringify(complierInput));
const abi = JSON.parse(output).contracts['Candidate.sol'].Candidate.abi;
const web3 = new Web3("https://ropsten.infura.io/v3/f250c244d2fb42689201294297ce77b0");
const  myContract = new web3.eth.Contract(abi, Candidate_Contract_Address);
myContract.transactionPollingTimeout = 3000;

const encodeData = myContract.methods.registerNewCandidate("C2","EP12","12", "123412341234").encodeABI();


// console.log(encodeData);

var transactionObject = {
        gas : 500000,
        data : encodeData,
        from : accountAddress,
        to : Candidate_Contract_Address
}

// web3.eth.accounts.signTransaction(transactionObject, pkey, (err,result) => {
//     console.log(result);
//     web3.eth.sendSignedTransaction(result.rawTransaction).
//     on("receipt", (receiptdata) => {
//         console.log(receiptdata);
//     }).catch(error =>{
//         console.log(`There occured some issue while registering Candidate : ${error}`);
//     })

// });
//0x475b01dFFAf712F42462B27D0967Cbf45001D16E
//Contracts Webjs
// myContract.methods.getCandidateDetails("11").call({from : accountAddress,
//     to : Candidate_Contract_Address})
//     .then((err, result) => {
//         if(result){
//             console.log(result);
//         }else{
//             console.log(err);
//         }
//     });

// async function getCandidateFromContract (id) {
//     let response = undefined;
    
//     return response;
// } 

//APIs
const getCandidate = async (req, res) => {
    if (req.params.id) {

    console.log(req.params.id , accountAddress, Candidate_Contract_Address);
    let response;
    try{
        await myContract.methods.getCandidateDetails(req.params.id).call({from : accountAddress},
            (err, result) => {
                if(result){
                    response = result;
                }else{
                    console.log("Some error");
                }
            });
    } catch  {
        res.status(500).json({
            message: `No Candidate found with this Id`,
          });
    }


     if (response) {
        res.status(200).json({
          status: 'success',
          requestedTime: req.requestTime,
          data: {
            response,
          },
        });
      } else {
        res.status(404).json({
          message: `Candidate with ${req.params.id} not found`,
        });
      }
    }else{
        res.status(501).json({
            message: `This Method is not implemented..`,
          });
    }
  };

//Routes
app.route('/api/v1/candidate/:id?').get(getCandidate) //.post(createTour);

app.listen(port, () => {
    console.log(`App running on port ${port}`);
  });






