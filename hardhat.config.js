/** @type import('hardhat/config').HardhatUserConfig */

require("dotenv").config();

require("@nomicfoundation/hardhat-ethers");
require("@nomicfoundation/hardhat-verify");

const {
  API_URL_POLYGON,
  API_URL_SEPLOIA,
  PRIVATE_KEY,
  POLYGONSCAN_API_KEY,
  ETHERSCAN_API_KEY,
} = process.env;
module.exports = {
  solidity: "0.8.24",

  networks: {
    maticmum: {
      networkId: 80001,
      url: API_URL_POLYGON,
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
      // bscTestnet : BSCSCAN_API_KEY,
      // optimisticGoerli: OPTISCAN_API_KEY,
      // arbitrumGoerli: ARBISCAN_API_KEY,
      // baseGoerli: BASESCAN_API_KEY
    },
    // customChains: [
    //   {
    //     network: "baseGoerli",
    //     chainId: 84531,
    //     urls: {
    //       apiURL: "https://api-goerli.basescan.org/api",
    //       browserURL: "https://goerli.basescan.org"
    //     }
    //   }
    // ]
  },
};
