/** @type import('hardhat/config').HardhatUserConfig */

require("dotenv").config();

require("@nomicfoundation/hardhat-ethers");
require("@nomicfoundation/hardhat-verify");

const {
  API_URL_POLYGON,
  API_URL_SEPLOIA,
  API_URL_AMOY,
  PRIVATE_KEY,
  POLYGONSCAN_API_KEY,
  ETHERSCAN_API_KEY,
  OKLINK_AMOY_API,
} = process.env;
module.exports = {
  solidity: "0.8.25",

  networks: {
    maticmum: {
      networkId: 80001,
      url: API_URL_POLYGON,
      accounts: [`0x${PRIVATE_KEY}`],
      gasPrice: 35000000000,
    },
    polygonAmoy: {
      networkId: 80002,
      url: API_URL_AMOY,
      accounts: [`0x${PRIVATE_KEY}`],
    },
    sepolia: {
      networkId: 11155111,
      url: API_URL_SEPLOIA,
      accounts: [`0x${PRIVATE_KEY}`],
    },
  },

  etherscan: {
    apiKey: {
      polygonMumbai: POLYGONSCAN_API_KEY,
      sepolia: ETHERSCAN_API_KEY,
      polygonAmoy: "3IY24R8KMYP4BXQEGCMYFNU2T64FMJCE4C",
    },
    customChains: [
      {
        network: "polygonAmoy",
        chainId: 80002,
        urls: {
          apiURL:
            "https://www.oklink.com/api/explorer/v1/contract/verify/async/api/polygonAmoy",
          browserURL: "https://www.oklink.com/polygonAmoy",
        },
      },
    ],
  },
};
