import Foundation
import WalletCore


@objc
enum Coins: UInt32, CaseIterable {
    case bitcoin = 0
    case ethereum = 60
    case solana = 501
}


@objc(RnWalletCore)
class RnWalletCore: NSObject {
    
    
    private var _wallet: HDWallet? = nil
    
    
    private let ERROR_INVALID_MNEMONIC = "ERROR_INVALID_MNEMONIC"
    private let ERROR_INVALID_HEXSTRING = "ERROR_INVALID_HEXSTRING"
    private let ERROR_NO_WALLET_LOADED = "ERROR_NO_WALLET_LOADED"
    private let ERROR_UNSUPPORTED_COIN = "ERROR_UNSUPPORTED_COIN"
    private let ERROR_INVALID_SIGNING_PARAMS = "ERROR_INVALID_SIGNING_PARAMS"
    
    
    
    
    
    /** Function will return distionary of  keypair */
    func getAddress(address: String, privateKey :String) -> NSDictionary{
        return [
            "address" : address,
            "privateKey" :privateKey
        ]
    }
    
    func getWalletResponse(wallet : HDWallet) -> NSDictionary{
        return [
            "mnemonic" : wallet.mnemonic,
            "seed" : wallet.seed.hexString
        ]
    }
    
    
    /** Function will create wallet */
    @objc
    func createWallet(_ mnemonic: String,resolve: RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) {
        if(mnemonic.isEmpty){
            reject(ERROR_INVALID_MNEMONIC,"The mnemonic is invalid !",nil)
        }
        let wallet = HDWallet(mnemonic: mnemonic, passphrase: "")
        self._wallet = wallet
        resolve(getWalletResponse(wallet: wallet!))
    }
    
    /** Function return distionary of keypair based on CoinType and derivationPath */
    @objc
    func getKeyPair(_ coin: String, derivationPath :String, resolve: RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) {
        if(_wallet == nil){
            reject(ERROR_NO_WALLET_LOADED,"Wallet could not be initialize!",nil)
        }
        
        print("\n📕 Check coin: \(coin)\n")
        print("\n📕 Check solana raw value: \(CoinType.solana.rawValue)\n")
        print("\n📕 Check DerivationPath: \(derivationPath)\n")
        
        switch UInt32(String(coin)) {
        case CoinType.ethereum.rawValue:
            guard let privateKey = _wallet?.getKey(coin: .ethereum, derivationPath: derivationPath) else {
                reject(ERROR_NO_WALLET_LOADED,"Can not get privateKey !",nil)
                break
                
            }
            let address = CoinType.ethereum.deriveAddress(privateKey: privateKey)
            resolve(getAddress(address:address ,privateKey:privateKey.data.hexString))
            break
        case CoinType.solana.rawValue :
            guard let privateKey = _wallet?.getKey(coin: .solana, derivationPath: derivationPath) else {
                reject(ERROR_NO_WALLET_LOADED,"Can not get privateKey !",nil)
                break
            }
            let address = CoinType.solana.deriveAddress(privateKey: privateKey)
            resolve(getAddress(address:address ,privateKey:privateKey.data.hexString))
            break
        default : break
        }
    }
    
    
    //    func signTransactionForEthereum(transactionRaw : NSDictionary) -> EthereumSigningOutput{
    //
    //        //TODO: parse NSDictionary to EthereumSigningInput then put it into input
    //
    //        let transactionRawAfterParse : EthereumSigningInput
    //
    //        return AnySigner.sign(input: transactionRawAfterParse, coin: .ethereum)
    //    }
    
    
    
    /** Return encoded of transaction*/
    func signTransactionForSolana(transactionRaw :NSDictionary,resolve: RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock){
        
        print("\n📕 Check transactionRaw: \(transactionRaw)\n")
        
        
        
        
        
        guard let isNative = transactionRaw["isNative"] else {
            reject(ERROR_INVALID_SIGNING_PARAMS,"Missing isNative params",nil)
            return
        }
        
        guard let privateKey : String = transactionRaw["privateKey"] as? String else {
            reject(ERROR_INVALID_SIGNING_PARAMS,"Missing privateKey params",nil)
            return
        }
        
        guard let recentBlockhash : String = transactionRaw["recentBlockhash"] as? String else {
            reject(ERROR_INVALID_SIGNING_PARAMS,"Missing recentBlockhash params",nil)
            return
        }
        
        
        print("\n📕 Check isNative: \(isNative)\n")
        
        
        if (isNative as! Bool == true){
            
            // if transfer native token Sol
            
            guard let recipient : String = transactionRaw["recipient"] as? String else {
                reject(ERROR_INVALID_SIGNING_PARAMS,"Missing recipient params",nil)
                return
            }
            
            guard let value : UInt64 = transactionRaw["value"] as? UInt64 else {
                reject(ERROR_INVALID_SIGNING_PARAMS,"Missing value params",nil)
                return
            }
            
        
            
            let transferMessage = SolanaTransfer.with {
                $0.recipient = recipient
                $0.value = value
            }
            
            print("\n📕 Check decode: \(Data(Base58.decodeNoCheck( string: "9YtuoD4sH4h88CVM8DSnkfoAaLY7YeGC2TarDJ8eyMS5")!))\n")
            
            
            
            let input = SolanaSigningInput.with {
                $0.transferTransaction = transferMessage
                $0.recentBlockhash = recentBlockhash
                $0.privateKey = Data(Base58.decodeNoCheck( string: privateKey)!)
            }
            
            let output: SolanaSigningOutput = AnySigner.sign(input: input, coin: .solana)
            
            
            resolve(output.encoded)
            
            
            //            resolve(output.encoded)
            
        } else {
            // if transfer Spl token
            
            guard let tokenMintAddress : String = transactionRaw["tokenMintAddress"] as? String else {
                reject(ERROR_INVALID_SIGNING_PARAMS,"Missing tokenMintAddress params",nil)
                return
            }
            
            guard let senderTokenAddress : String = transactionRaw["senderTokenAddress"] as? String else {
                reject(ERROR_INVALID_SIGNING_PARAMS,"Missing senderTokenAddress params",nil)
                return
            }
            guard let recipientTokenAddress : String = transactionRaw["recipientTokenAddress"] as? String else {
                reject(ERROR_INVALID_SIGNING_PARAMS,"Missing recipientTokenAddress params",nil)
                return
            }
            guard let amount : UInt64 = transactionRaw["amount"] as? UInt64 else {
                reject(ERROR_INVALID_SIGNING_PARAMS,"Missing amount params",nil)
                return
            }
            guard let decimals : UInt32 = transactionRaw["decimals"] as? UInt32 else {
                reject(ERROR_INVALID_SIGNING_PARAMS,"Missing decimals params",nil)
                return
            }
            
            
            
            let tokenTransferMessage = SolanaTokenTransfer.with {
                $0.tokenMintAddress = tokenMintAddress
                $0.senderTokenAddress = senderTokenAddress
                $0.recipientTokenAddress = recipientTokenAddress
                $0.amount = amount
                $0.decimals = decimals
            }
            let input = SolanaSigningInput.with {
                $0.tokenTransferTransaction = tokenTransferMessage
                $0.recentBlockhash = recentBlockhash
                $0.privateKey = Data(Base58.decodeNoCheck( string: privateKey)!)
            }
            
            let output : SolanaSigningOutput =  AnySigner.sign(input: input, coin: .solana)
            
            print("\n📕 Check output: \(output.encoded)\n")
            
            resolve(output.encoded)
        }
        
        
    }
    
    //    func signTransactionForBitcoin(transactionRaw :NSDictionary) -> BitcoinTransactionOutput{
    //
    //        //TODO: parse NSDictionary to SolanaSigningInput then put it into input
    //
    //
    //        let transactionRawAfterParse : BitcoinTransactionInput
    //
    //        return AnySigner.sign(input: transactionRawAfterParse, coin: .bitcoin)
    //    }
    
    
    /** Function sign raw transaction base on coinType */
    @objc
    func signRawTransaction(_ coin : String, transactionRaw :NSDictionary, resolve: RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock){
        if(_wallet == nil){
            reject(ERROR_NO_WALLET_LOADED,"Wallet could not be initialize!",nil)
        }
        
        switch UInt32(String(coin)) {
            //        case CoinType.bitcoin.rawValue :
            //            resolve(signTransactionForBitcoin(transactionRaw: transactionRaw))
            //            break
            //        case CoinType.ethereum.rawValue :
            //            resolve(signTransactionForEthereum(transactionRaw: transactionRaw))
            //            break
        case CoinType.solana.rawValue :
            signTransactionForSolana(transactionRaw: transactionRaw,resolve: resolve,reject:reject)
            break
        default : break
        }
    }
    
    @objc
    func cleanup() -> Void {
        _wallet = nil
    }
    
    
    
}
