# Bootcamp

專案下載完後，請先開啟終端機，

如果電腦尚未安裝CocoaPods：

### Intel晶片請參考以下步驟(皆在終端機輸入指令操作)：

- Step1. sudo gem install cocoapods

- Step2. 切換到clone下來的folder，

***example: cd /Users/peterlin/Documents/iOS_Project/Storyboard/BodyFatMonitor***

- Step3. pod install --repo-update  

### M1晶片請參考以下步驟(皆在終端機輸入指令操作)：

- Step1. arch -x86_64 sudo gem install cocoapods -n /usr/local/bin

- Step2. arch -x86_64 sudo gem install ffi

- Step3. 重開機

- Step4. 切換到clone下來的folder，

***example: cd /Users/peterlin/Documents/iOS_Project/Storyboard/BodyFatMonitor***

- Step5. arch -x86_64 pod install --repo-update  

等安裝完所有有使用到的資源庫後會出現 **Pod installation complete!**

然後到專案資料夾內開啟 **.xcworkspace**

不要開到 **.xcodeproj**，會找不到資源庫

即可正常建置專案！
