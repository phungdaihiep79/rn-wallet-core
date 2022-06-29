#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(RnWalletCore, NSObject)


RCT_EXTERN_METHOD(createWallet:(NSString *)mnemonic
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)


@end
