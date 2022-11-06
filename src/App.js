import './App.css';
import { WorldIDWidget } from '@worldcoin/id';
import { defaultAbiCoder as ABI } from 'ethers/lib/utils';
import { useState } from 'react';
import { Wallet } from 'ethers';

//0x13881

function App() {

  const [wallet_status, set_wallet_status] = useState('Connect Wallet');
  const [account, set_account] = useState('');
  const [chain_id, set_chain_id] = useState('');
  const [network_status, set_network_status] = useState('Not Connected');
  const {ethereum} = window;

  const networks = {
    "0x1": "ETH Mainnet",
    "0x89": "Polygon",
    "0x3": "Ropsten",
    "0x2a": "Kovan",
    "0x4": "Rinkeby",
    "0x5": "Goerli",
    "0x13881": "Mumbai"
  }

  function handleVerification(verification) {
    console.log(verification);

    let { merkle_root, nullifier_hash, proof } = verification;
    let depackedProof = ABI.decode(['uint256[8]'], proof)[0];
    console.log(depackedProof);
  }

  async function handleConnect(new_account) {
    set_account(new_account);
    set_wallet_status("Connected as " + new_account.substring(0,6) + "..." + new_account.slice(-4));
    let connected_chain = await ethereum.request({method: "eth_chainId"});
    set_chain_id(connected_chain);
    set_network_status("Connected to: " + (networks[connected_chain] || connected_chain));
    ethereum.on('chainChanged', (_chainId) => window.location.reload());
    console.log(connected_chain);
  }

  async function connectWallet() {
    try {
      let accounts = await ethereum.request({ method: 'eth_requestAccounts' });
      handleConnect(accounts[0]);
    } catch(error) {
      console.error(error);
    }
  }

  window.onload = async function() {
    if (typeof window.ethereum !== 'undefined') {
      let accounts = await ethereum.request({method: 'eth_accounts'});       
      if (accounts.length) {
        handleConnect(accounts[0]);
      }
    }
  }

  return (
    <div id='container'>
      <div id='connect_wallet' onClick={connectWallet}>
        <span id='connect_wallet_text'>{wallet_status}</span>
      </div>
      <div id='network_status'>
        <div id='network_status_icon' style={{
          backgroundColor: network_status == "Connected to: Mumbai" ? "lightgreen" : "red",
          boxShadow: network_status == "Connected to: Mumbai" ? "0px 0px 5px 2px lightgreen" : "0px 0px 5px 2px red"
        }}></div>
        <div id='network_status_text'>{network_status}</div>
      </div>

      <WorldIDWidget 
        actionId='wid_staging_98fe2043489b113103d09c334475f84a'
        signal='sign-in-staging'
        onSuccess={(verificationResponse) => handleVerification(verificationResponse)}
        onError={(error) => console.error(error)}
        debug={true}
      />
    </div>
  );
}

export default App;
