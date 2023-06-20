import { Overrides } from 'ethers';
import { ethers } from 'hardhat';

async function deploy() {
  // コントラクトをデプロイするアカウントのアドレスを取得します。
  const [deployer] = await ethers.getSigners();
  console.log('Deploying contract with the account:', deployer.address);

  const funds = 100;

  // コントラクトのインスタンスを作成します。

  // The deployed instance of the contract
  const messenger = await ethers.deployContract("Messenger",{
    value: funds,
  } as Overrides);

  await messenger.waitForDeployment();

  console.log('Contract deployed at:',await messenger.getAddress());
  console.log(
    "Contract's fund is:",
    await await messenger.getAddress()
  );
}

deploy()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
