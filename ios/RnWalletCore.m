#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(RnWalletCore, NSObject)



RCT_EXTERN_METHOD(cleanup)

RCT_EXTERN_METHOD(createWallet:(NSString *) mnemonic 
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getKeyPair:(NSString *) coin
                  derivationPath:(NSString *) derivationPath
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(signRawTransaction:(NSString *) coin
                  transactionRaw:(NSDictionary *) transactionRaw
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

@end

