import Foundation
import RealmSwift

class App {
    static let shared = App()

    private let fallbackLanguage = "en"

    let realmFactory: IRealmFactory

    let secureStorage: ISecureStorage
    let localStorage: ILocalStorage
    let wordsManager: IWordsManager

    let pinManager: IPinManager
    let lockRouter: LockRouter
    let lockManager: ILockManager
    let blurManager: IBlurManager

    let localizationManager: LocalizationManager
    let languageManager: ILanguageManager

    let randomManager: IRandomManager
    let systemInfoManager: ISystemInfoManager

    let adapterFactory: IAdapterFactory
    let walletManager: IWalletManager

    let coinManager: ICoinManager
    let transactionManager: ITransactionManager

    let exchangeRateManager: IExchangeRateManager

    init() {
        let realmFileName = "bank.realm"

        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let realmConfiguration = Realm.Configuration(fileURL: documentsUrl?.appendingPathComponent(realmFileName))

        realmFactory = RealmFactory(configuration: realmConfiguration)

        localStorage = UserDefaultsStorage()
        secureStorage = KeychainStorage(localStorage: localStorage)
        wordsManager = WordsManager(secureStorage: secureStorage, localStorage: localStorage)

        pinManager = PinManager(secureStorage: secureStorage)
        lockRouter = LockRouter()
        lockManager = LockManager(localStorage: localStorage, wordsManager: wordsManager, lockRouter: lockRouter)
        blurManager = BlurManager(lockManager: lockManager)

        localizationManager = LocalizationManager()
        languageManager = LanguageManager(localizationManager: localizationManager, localStorage: localStorage, fallbackLanguage: fallbackLanguage)

        randomManager = RandomManager()
        systemInfoManager = SystemInfoManager()

        adapterFactory = AdapterFactory()
        walletManager = WalletManager(adapterFactory: adapterFactory)

        coinManager = CoinManager(wordsManager: wordsManager, walletManager: walletManager)
        transactionManager = TransactionManager(walletManager: walletManager, realmFactory: realmFactory)

        exchangeRateManager = ExchangeRateManager()
    }

}