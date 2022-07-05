import React, { useCallback, useState, useEffect } from 'react';

import { StyleSheet, View, Text, TouchableOpacity } from 'react-native';

import RNWallerCore, {
  CoinType,
  SolanaTransactionRawParams,
} from 'react-native-rn-wallet-core';
import { decode, encode, decodeUnsafe } from 'bs58';
import { Buffer } from 'buffer';

import {
  Connection,
  PublicKey,
  clusterApiUrl,
  Transaction,
} from '@solana/web3.js';

const endpoint = 'https://api.mainnet-beta.solana.com';

const connection = new Connection(endpoint, 'max');

export const toBuffer = (arr: Buffer | Uint8Array | Array<number>): Buffer => {
  if (Buffer.isBuffer(arr)) {
    return arr;
  } else if (arr instanceof Uint8Array) {
    return Buffer.from(arr.buffer, arr.byteOffset, arr.byteLength);
  } else {
    return Buffer.from(arr);
  }
};

export default function App() {
  const [privateKey, setPrivateKey] = useState<string>('');

  const handleCreateWallet = useCallback(async () => {
    const wallet = await RNWallerCore.createWallet(
      'settle list token tired head lesson strike cliff comic ethics divert increase caught solve plug surround post law lemon drive siege fresh answer treat'
    );
    console.log('check wallete', wallet);
  }, []);

  const handleGetKeyPair = useCallback(async () => {
    try {
      const devivationPath = `m/44'/501'/0'/0'`;
      const keyPair = await RNWallerCore.getKeyPair(
        CoinType.solana,
        devivationPath
      );
      console.log('KeyPair : ', keyPair);
      setPrivateKey(keyPair.privateKey);
    } catch (error) {
      console.log('error', error);
    }
  }, []);

  const handleSignRawTransaction = useCallback(async () => {
    try {
      const recentBlockHash = (await connection.getLatestBlockhash('max'))
        .blockhash;
      // conn.getVersion().then((r) => console.log('version', r));
      console.log('recentBlockHash', recentBlockHash);
      const transactionRaw: SolanaTransactionRawParams = {
        isNative: true,
        privateKey: encode(Buffer.from(privateKey, 'hex')),
        recentBlockhash: recentBlockHash,
        recipient: 'D1PjXi7dVtq3sbrnqLPFb7kszCfKJMHCVoN9Z9hYpgWJ',
        value: 1000000000,
      };
      const encoded = await RNWallerCore.signRawTransaction(
        CoinType.solana,
        transactionRaw
      );
      console.log('encoded', encoded);
      const out = await connection.sendEncodedTransaction(encoded);
    } catch (error) {
      console.log('error', error);
    }
  }, [privateKey]);

  const handleencode = useCallback(() => {
    console.log('encode', encode(Buffer.from(privateKey, 'hex')), privateKey);
  }, [privateKey]);

  useEffect(() => {
    handleCreateWallet();
  }, [privateKey]);

  return (
    <View style={styles.container}>
      <TouchableOpacity onPress={handleGetKeyPair}>
        <Text>get keyPair</Text>
      </TouchableOpacity>
      <TouchableOpacity onPress={handleSignRawTransaction}>
        <Text>sign raw transaction</Text>
      </TouchableOpacity>
      <TouchableOpacity onPress={handleencode}>
        <Text>handleencode</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
