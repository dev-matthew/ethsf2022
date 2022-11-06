# VerifID ☑️ - A privacy preserving human-to-ENS verification service

![alt text](./public/verify3.png)

## Overview

VerifID is a platform that allows for the verification of ENS addresses, similar to social media platforms such as Instagram and Twitter. It links human identity to on-chain identity through WorldCoin / WorldID and their ZK technology. This preserves the privacy of the user, while also demonstrating that a blockchain address has been connected to a human identity. This can demonstrate credibility of accounts, since only one account can be linked per human, and other applications can easily refer to these contract functions to view whether or not a certain address / ENS has been verified.

## Technical Details

Sponsors:
- `World Coin / World ID` is used to verify identity and prove humanity on chain. Through retina scans, users are confirmed to be unique, which allows our smart contract to ensure that each human can only have one verified address / ENS domain.
- `ENS` was integrated to convey the social aspect of the service. ENS essentially provides the social media handles, while this service can provide the verification of certain users who want to convey that there is a real human behind the account.
- `Tellor` is used as an oracle on chain. It is made to query the Covalent API to ensure that the ENS domain is owned by the function caller. This acts as a bridge because our main contract is on Polygon Mumbai, while ENS is on Ethereum mainnet.
- `Covalent` is used as an API to get data on NFTs that the user owns. This can tell the service which ENS names it owns, so that they can choose to verify with one of them.
- `Polygon` is the chain that the contracts are deployed to. Worldcoin and Tellor both operate on Polygon as well, so the contracts are able to easily interface with them. The ENS data is confirmed via Tellor.

## Additional Information:

Tellor x WorldID Contract for ENS verification: https://mumbai.polygonscan.com/address/0xf24D9124C6005719F6a04CcB7B47e814F27A100c
```0xf24D9124C6005719F6a04CcB7B47e814F27A100c```

Empiric Network Experimentation: https://blockscout.com/optimism/goerli/address/0xf24D9124C6005719F6a04CcB7B47e814F27A100c
```0xf24D9124C6005719F6a04CcB7B47e814F27A100c```