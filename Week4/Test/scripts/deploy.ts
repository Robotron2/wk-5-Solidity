import { ethers } from "hardhat"

async function main() {
	console.log("Deploying StudentRegistry...")

	const StudentRegistry = await ethers.getContractFactory("StudentRegistry")

	const studentRegistry = await StudentRegistry.deploy()

	await studentRegistry.waitForDeployment()

	console.log(`StudentRegistry deployed to: ${await studentRegistry.getAddress()}`)
}

main().catch((error) => {
	console.error(error)
	process.exitCode = 1
})
