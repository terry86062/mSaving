# 記一記帳

記一記帳 is a free budgeting app that tracks users’ spending, optimizes users’ budget and helps users save money.

TestFlight  https://testflight.apple.com/join/zDn3SOEg

# Feature
* ### 新增帳
<img width="200" height="433" src="https://github.com/terry86062/mSaving/blob/develop/教學-新增帳.gif"/>

* ### 新增預算
<img width="200" height="433" src="https://github.com/terry86062/mSaving/blob/develop/教學-新增預算.gif"/>

* ### 掃描 QR-code 新增帳
<img width="200" height="433" src="https://github.com/terry86062/mSaving/blob/develop/教學-掃QR-code記帳.gif"/>

* ### 使用 Siri 新增帳
<img width="200" height="433" src="https://github.com/terry86062/mSaving/blob/develop/教學-使用Siri記帳.gif"/>

# Key Function
* ### Core Data 
Build Relationships between different entities to fetch and revise data more efficiently.
![image](https://github.com/terry86062/mSaving/blob/develop/CoreData.png)

* ### Third Party API 
Through scanning the QR-code on E-Invoice, send a request to E-Invoice API of the Ministry of Finance, R.O.C.. Parse the response from the server to get the information of E-Invoice for users recording their spending.

* ### SiriKit 
Users can say the keyword “支付帳單O元” which provide in INPayBillIntent and Siri will create new spending for users if they enabled Siri function.
<pre><code>
import Intents

class IntentHandler: INExtension { }

extension IntentHandler: INPayBillIntentHandling {

    func handle(intent: INPayBillIntent, completion: @escaping (INPayBillIntentResponse) -> Void) {

        guard let amount = intent.transactionAmount?.amount?.amount?.doubleValue else {...}

        let category = CategoryProvider().expenseCategories

        guard category != [] else {...}

        let account = AccountProvider().accounts

        guard account != [] else {...}

        guard let occurDate = createOccurDate(selectedDate: Date()) else { return }

        AccountingProvider().createAccounting(occurDate: occurDate, createDate: Date(),
                                                                        amount: Int64(amount), account: account[0],
                                                                        category: .expense(category[0]))

        completion(INPayBillIntentResponse(code: .success, userActivity: nil))

    }

    func createOccurDate(selectedDate: Date) -> Date? {...}

}
</code></pre>

# ScreenShot
<img width="400" height="400" src="https://github.com/terry86062/mSaving/blob/develop/IMG_0327_iphonexspacegrey_portrait.png"/>
<img width="400" height="400" src="https://github.com/terry86062/mSaving/blob/develop/IMG_0328_iphonexspacegrey_portrait.png"/>
<img width="400" height="400" src="https://github.com/terry86062/mSaving/blob/develop/IMG_0337_iphonexspacegrey_portrait.png"/>

# Library
* #### FSCalendar
* #### Charts
* #### SwiftMessages
* #### BetterSegmentedControl
* #### IQKeyboardManagerSwift
* #### Firebase/Core
* #### Fabric
* #### Crashlytics
* #### SwiftLint

# Requirement
* #### iOS 11.0+
* #### XCode 10.2+

# Contacts
Terry Huang
terry86062@gmail.com

