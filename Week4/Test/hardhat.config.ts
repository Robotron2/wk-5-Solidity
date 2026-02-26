import { HardhatUserConfig } from "hardhat/config"
import "@nomicfoundation/hardhat-toolbox"
import "dotenv/config"

const { CORE_RPC_URL, PRIVATE_KEY } = process.env

const config: HardhatUserConfig = {
	solidity: "0.8.28",
	networks: {
		core: {
			url: CORE_RPC_URL!,
			accounts: [PRIVATE_KEY!],
			chainId: 1114, // Core mainnet
			ignition: {
				// Fulfills the "minimum needed 60000000000" requirement
				maxPriorityFeePerGas: 60_000_000_000n,
				// Caps the total fee (Base Fee + Tip) at 100 gwei
				maxFeePerGas: 100_000_000_000n,
			},
		},
	},
}

export default config
