
import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

    const initialListingFee = 100;
    const initialFeeRecipient = 20;

    const NFTMarketModule = buildModule ( "NFTmarketPlaceModule", (m) => {

    const NFTMarket = m.contract("NFTMarket",[initialListingFee, initialFeeRecipient]);

    return { NFTMarket };
});

export default NFTMarketModule;


// StreamPay contract addr - 0x64BA35F47326A8F356888440eB6159863b5B66d6

