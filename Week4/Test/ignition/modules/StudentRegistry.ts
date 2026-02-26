import { buildModule } from "@nomicfoundation/hardhat-ignition/modules"

const StudentRegistryModule = buildModule("StudentRegistryModule", (m) => {
	const studentRegistry = m.contract("StudentRegistry")
	return { studentRegistry }
})

export default StudentRegistryModule
