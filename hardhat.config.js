/** @type import('hardhat/config').HardhatUserConfig */

require("dotenv").config();

require("@nomicfoundation/hardhat-toolbox");

const metamask_private_key = process.env.METAMASK_PRIVATE_KEY;
const maticmum_rpc_url = process.env.MATICMUM_RPC_URL;
const polygonscan_api_key = process.env.POLYGONSCAN_API_KEY;
module.exports = {
  solidity: "0.8.19",

  networks: {
    maticmum: {
      networkId: 80001,
      url: maticmum_rpc_url,
      accounts: [metamask_private_key],
    },
  },
  etherscan: {
    apiKey: {
      polygonMumbai: polygonscan_api_key,
      // sepolia : ETHERSCAN_API_KEY,
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
