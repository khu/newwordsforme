var Keepin = {
	POST_URL : "http://127.0.0.1:3000/sessions/userid",
	POST_WORD_URL : "http://127.0.0.1:3000/users/placeholder/words"
}

Keepin.isLogin = function(){
	return Browser.Preferences.prefHasUserValue('userid');
};

Keepin.login = function(email, password){
	var message = {
		action: this.POST_URL,
		method: 'POST'
	};

	var params         = {};
	params.email   = email;
	params.password = password;
	
	Browser.XML_HTTP_REQUEST.onload = function(aEvent) {
        var text = aEvent.target.responseText;

		info = eval("(" + text + ")"); 
		if(info.state == "failed"){
			return false;
		}else{
			Browser.Preferences.setCharPref('userid', info.id)
			return true;
		}
    };

	Browser.openHttpRequest(message);
	Browser.sendHttpRequest(params);
};

Keepin.postMessage = function(word) {
	var url = this.POST_WORD_URL.replace("placeholder", Browser.Preferences.getCharPref('userid'));
    var message = {
		action: url,
		method: 'POST'
	};
	
	var params = {};
	params.word = {};
	params.word.word = word;
    ﻿
    ﻿Browser.XML_HTTP_REQUEST.onload = function(aEvent) {
        return true;
    };

    ﻿Browser.openHttpRequest(message);
    ﻿Browser.sendHttpRequest(params);
};