# Technical Test

## Remote App Config

- Implement a single view application with an **UIWebView**.
- Implement a remote app config service:
  - The remote app config must be fetched via an API HTTP GET Call
	- The API Endpoint for the remote app config is ```https://mytoysiostestcase1.herokuapp.com/api/config/ios/1.0.0``` and requires the following API-Key ```hz7JPdKK069Ui1TRxxd1k8BQcocSVDkj219DVzzD``` as ```x-api-key``` HTTP request
	  header field.
	- You can preview the response in the terminal if you use curl with the
	  header option to set the x-api-key ``` curl -H 'x-api-key:hz7JPdKK069Ui1TRxxd1k8BQcocSVDkj219DVzzD' https://mytoysiostestcase1.herokuapp.com/api/config/ios/1.0.0 ```
	  
	- The JSON structure of the response ```{ "appAllowToStart" : true, "baseUrl":"https://www.mytoys.de"} ``` contains the flag **appAllowToStart** to check if the app is allowed to startup or not and the **baseUrl** that should be loaded by the UIWebView
