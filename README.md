# 記一記帳

記一記帳 is a free budgeting app that tracks users’ spending, optimizes users’ budget and helps users save money.

<img width="400" height="865" src="https://github.com/terry86062/mSaving/blob/develop/教學-新增帳.gif"/> <img width="400" height="865" src="https://github.com/terry86062/mSaving/blob/develop/教學-新增預算.gif"/>
<img width="400" height="865" src="https://github.com/terry86062/mSaving/blob/develop/教學-掃QR-code記帳.gif"/> <img width="400" height="865" src="https://github.com/terry86062/mSaving/blob/develop/教學-使用Siri記帳.gif"/>

* ## Design Pattern 
    Structured with MVC architecture. Use Delegation and Notification Center Patterns to communicate and pass informations between objects.

* ## Database 
    Use Core Data as the database. Build Relationships between different entities to fetch and revise data more efficiently.

* ## Third Party API 
    Through scanning the QR-code on E-Invoice, send a request to E-Invoice API of the Ministry of Finance, R.O.C.. Parse the response from the server to get the information of E-Invoice for users recording their spending.

* ## SiriKit 
    Users can say the keyword “支付帳單O元” which provide in INPayBillIntent and Siri will create new spending for users if they enabled Siri function.

* ## Maintenance 
    Use SOLID principle and Unit Test to keep improving the quality of Codes being more reusable, decoupling and fewer bugs.
    
![](https://github.com/terry86062/mSaving/blob/develop/IMG_0327_iphonexspacegrey_portrait.png)
![](https://github.com/terry86062/mSaving/blob/develop/IMG_0328_iphonexspacegrey_portrait.png)
![](https://github.com/terry86062/mSaving/blob/develop/IMG_0337_iphonexspacegrey_portrait.png)
