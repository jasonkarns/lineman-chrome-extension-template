// sample background script
// CoffeeScript is also supported in this directory

chrome.browserAction.onClicked.addListener(function(tab){
  console.log("Hello, World!");
});
