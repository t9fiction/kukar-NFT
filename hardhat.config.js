require("@nomiclabs/hardhat-waffle");
require('dotenv').config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
// task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
//   const accounts = await hre.ethers.getSigners();

//   for (const account of accounts) {
//     console.log(account.address);
//   }
// });

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const PRIVATE_KEY = process.env["TEST_PRIVATE_KEY"];

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.0",
  networks: {
    mumbai: {
      url: "https://polygon-mumbai.g.alchemy.com/v2/I0u4Y4eYOo29BhQK1FJ5lZEPyVKAvLR9",
      accounts: [`0x${PRIVATE_KEY}`]
    }
  }
};
