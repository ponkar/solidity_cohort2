// const express = require('express')
// const app = express()

// app.get('/', function (req,res) {

//     res.send('Hello World')
// })
// app.listen(3000)

const Web3 = require('web3');

const web3 = new Web3("https://ropsten.infura.io/v3/f250c244d2fb42689201294297ce77b0");
web3.eth.getAccounts((err,accounts) => {
    console.log(accounts)
})
