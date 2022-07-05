/**
 * public enum CoinType: UInt32, CaseIterable {
    case aeternity = 457
    case aion = 425
    case binance = 714
    case bitcoin = 0
    case bitcoinCash = 145
    case bitcoinGold = 156
    case callisto = 820
    case cardano = 1815
    case cosmos = 118
    case dash = 5
    case decred = 42
    case digiByte = 20
    case dogecoin = 3
    case eos = 194
    case ethereum = 60
    case ethereumClassic = 61
    case fio = 235
    case goChain = 6060
    case groestlcoin = 17
    case icon = 74
    case ioTeX = 304
    case kava = 459
    case kin = 2017
    case litecoin = 2
    case monacoin = 22
    case nebulas = 2718
    case nuls = 8964
    case nano = 165
    case near = 397
    case nimiq = 242
    case ontology = 1024
    case poanetwork = 178
    case qtum = 2301
    case xrp = 144
    case solana = 501
    case stellar = 148
    case tezos = 1729
    case theta = 500
    case thunderToken = 1001
    case neo = 888
    case tomoChain = 889
    case tron = 195
    case veChain = 818
    case viacoin = 14
    case wanchain = 5718350
    case zcash = 133
    case firo = 136
    case zilliqa = 313
    case zelcash = 19167
    case ravencoin = 175
    case waves = 5741564
    case terra = 330
    case harmony = 1023
    case algorand = 283
    case kusama = 434
    case polkadot = 354
    case filecoin = 461
    case elrond = 508
    case bandChain = 494
    case smartChainLegacy = 10000714
    case smartChain = 20000714
    case oasis = 474
    case polygon = 966
    case thorchain = 931
    case bluzelle = 483
    case optimism = 10000070
    case arbitrum = 10042221
    case ecochain = 10000553
    case avalancheCChain = 10009000
    case xdai = 10000100
    case fantom = 10000250
    case cryptoOrg = 394
    case celo = 52752
    case ronin = 10002020
    case osmosis = 10000118
    case ecash = 899
    case cronosChain = 10000025
    case smartBitcoinCash = 10000145
    case kuCoinCommunityChain = 10000321
    case boba = 10000288
    case metis = 1001088
    case aurora = 1323161554
    case evmos = 10009001
    case nativeEvmos = 20009001
    case moonriver = 10001285
    case moonbeam = 10001284
    case klaytn = 10008217
}
 */

import type { BigNumber } from 'bignumber.js';

export enum CoinType {
  bitcoin = '0',
  ethereum = '60',
  solana = '501',
}

export type CreateWalletResponse = {
  mnemonic: string;
  seed: string;
};

export type GetKeyPairResponse = {
  address: string;
  privateKey: string;
};

export type SolanaNativeTransactionRawParams = {
  recipient?: string;
  value?: number;
};

export type SolanaSPLTransactionRawParams = {
  tokenMintAddress?: string;
  senderTokenAddress?: string;
  recipientTokenAddress?: string;
  amount?: BigNumber;
  decimals?: BigNumber;
};

export type SolanaTransactionRawParams = {
  isNative: boolean;
  recentBlockhash: string;
  privateKey: string;
} & SolanaNativeTransactionRawParams &
  SolanaSPLTransactionRawParams;

export type RnWalletCoreType = {
  CoinType: CoinType;
  createWallet(mnemonic: string): Promise<CreateWalletResponse>;
  getKeyPair(
    coin: CoinType,
    derivationPath: string
  ): Promise<GetKeyPairResponse>;
  signRawTransaction(
    coin: CoinType,
    transactionRaw: SolanaTransactionRawParams
  ): Promise<string>;
};
