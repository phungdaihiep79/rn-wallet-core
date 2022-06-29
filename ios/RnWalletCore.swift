import Foundation
import WalletCore


@objc(RnWalletCore)
class RnWalletCore: NSObject {
    
    
    private let ERROR_INVALID_MNEMONIC = "ERROR_INVALID_MNEMONIC"
    private let ERROR_INVALID_HEXSTRING = "ERROR_INVALID_HEXSTRING"
    private let ERROR_NO_WALLET_LOADED = "ERROR_NO_WALLET_LOADED"
    private let ERROR_UNSUPPORTED_COIN = "ERROR_UNSUPPORTED_COIN"
    private let ERROR_INVALID_SIGNING_PARAMS = "ERROR_INVALID_SIGNING_PARAMS"
    
    
    
    @objc
    func createWallet(mnemonic: String,resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void{
        if(!mnemonic){
            reject(ERROR_INVALID_MNEMONIC,"The mnemonic is invalid !",nil)
        }
        resolve(HDWallet(mnemonic: mnemonic, passphrase: "")) 
    }
    
    
    
}
