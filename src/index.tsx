import { NativeModules, Platform } from 'react-native';
import type { RnWalletCoreType } from './types';

const LINKING_ERROR =
  `The package 'react-native-rn-wallet-core' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

const RnWalletCore = NativeModules.RnWalletCore
  ? NativeModules.RnWalletCore
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export default RnWalletCore as RnWalletCoreType;
export * from './types';
