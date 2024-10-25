// This script can be used to deploy the "Storage" contract using ethers.js library.
// Please make sure to compile "./contracts/1_Storage.sol" file before running this script.
// And use Right click -> "Run" from context menu of the file to run the script. Shortcut: Ctrl+Shift+S

import { deploy } from './ethers-lib'

(async () => {
  try {
    // https://www.quicknode.com/guides/defi/lending-protocols/how-to-make-a-flash-loan-using-aave
    // https://aave.com/docs/resources/addresses
    // const result = await deploy('ArbitrageBot', ["0x2f39d218133AFaB8F2B819B1066c7E434Ad94E9e"]) // Mainnet: PoolAddressesProvider
    // const result = await deploy('ArbitrageBot', ["0x012bAC54348C0E635dCAc9D5FB99f06F24136C9A"]) // Sepolia (test): PoolAddressesProvider
    const result = await deploy('ArbitrageBot', []) // Sepolia (test): PoolAddressesProvider
    // const result = await deploy('EmitExample', [])
    console.log(`address: ${result.address}`)
  } catch (e) {
    console.log(e.message)
  }
})()