var Browser = {}

Browser.Preferences = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService).getBranch("Keepin.");
	
Browser.XML_HTTP_REQUEST = Components.classes["@mozilla.org/xmlextras/xmlhttprequest;1"].createInstance(Components.interfaces.nsIXMLHttpRequest),

Browser.openHttpRequest = function(message){
	this.XML_HTTP_REQUEST.open(message.method, message.action, false); 
}
	
Browser.sendHttpRequest = function(message) {
	this.XML_HTTP_REQUEST.setRequestHeader("Content-type", "application/json");
	this.XML_HTTP_REQUEST.send(JSON.stringify(message));
}