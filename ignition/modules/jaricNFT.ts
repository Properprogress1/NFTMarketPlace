import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const jaricNFTModule = buildModule("jaricNFTModule", (m) => {

    const jaric = m.contract("jaricNFT", []);

    return { jaric };
});

export default jaricNFTModule;
