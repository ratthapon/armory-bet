const TAIL = 0;
const HEAD = 1;

async function main() {
    // Retrieve accounts 
    const accounts = await ethers.provider.listAccounts();

    // Set up an ethers contract, representing our deployed instance
    const address = "0xE4083e8e2fA38C8C18c5c8854d87266b06b48a2c"
    const ArmoryBet = await ethers.getContractFactory("ArmoryBet");
    const armoryBet = await ArmoryBet.attach(address);

    // armoryBet.on("BetSubmit", (invoker, bet, requestId) => {
    //     console.log(invoker, bet, requestId);
    // });

    const requestID = await armoryBet.betCoin(TAIL);

    console.log("Bet TAIL", TAIL);
    console.log("requestID is", requestID.data);
}

main()
.then(() => process.exit(0))
.catch(error => {
    console.error(error);
    process.exit(1);
});