var NewWordsForMe = {
	POST_URL : "http://newwordsfor.me/sessions",
	POST_WORD_URL : "http://newwordsfor.me/users/placeholder/words"
}

NewWordsForMe.isLogin = function(){
	return  Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService).getBranch("NewWordsForMe.").prefHasUserValue('userid');
};

NewWordsForMe.login = function(email, password){
	var request = new XMLHttpRequest();  
	request.onreadystatechange = function (aEvt) {  
	  if (request.readyState == 4) {  
	     if(request.status == 200) {
		   alert(request.responseText)		
		} else {
		   alert(request.responseText)
		}
	};  
	var formData = new FormData();  
	formData.append("session[email]", "iamkaihu@gmail.com");  
	formData.append("session[password]", 2232500);
	request.open('POST', 'http://newwordsfor.me/sessions');
	request.send(formData);
};


window.addEventListener("load", function(e) {
        var selectedWord = "";
		var contextMenu = document.getElementById("contentAreaContextMenu")
		if (contextMenu) {
	        contextMenu.addEventListener("popupshowing", function(event) {
	                selectedWord = getSelection(document.popupNode);
	                document.getElementById("menuitem_newwordsforme_add").hidden = (selectedWord.length == 0);
	                document.getElementById("separator_newwordsforme").hidden = (selectedWord.length == 0);

	                document.getElementById("menuitem_newwordsforme_add").setAttribute("label", 'add "' + selectedWord + '" to my vocabulary');
	            },
	            false);			
		}
		var menuItem = document.getElementById("menuitem_newwordsforme_add")
		if (menuItem) {
	        menuItem.addEventListener("click", function(event) {
	                if (NewWordsForMe.isLogin()) {
	                    var result = NewWordsForMe.postMessage(selectedWord);
	                    popup("Notification", selectedWord + "successfully added");
	                    return;
	                }

	                showLoginDialog();

	            }, false);
		}
    },
    false);

function showLoginDialog() {
    PopupNotifications.show(gBrowser.selectedBrowser, "newwordsforme-add",
        'Login to your newwordsfor.me',
        null,
        {
            label: "Login",
            accessKey: "D",
            callback: function() {
                window.openDialog("chrome://newwordsforme/content/login.xul", "chrome, dialog");
            }
        },
        null);
}

function login() {
    var name = document.getElementById("txt_newwordsforme_name").value;
    var password = document.getElementById("txt_newwordsforme_password").value
    return NewWordsForMe.login(name, password);
}

function getSelection(popupnode) {
    var nodeLocalName = popupnode.localName.toLowerCase();
    var selection = '';

    if ((nodeLocalName == "textarea") || (nodeLocalName == "input" && popupnode.type == "text")) {

        selection = popupnode.value.substring(popupnode.selectionStart, popupnode.selectionEnd);

    } else if (nodeLocalName == "img") {
        if (popupnode.title) {
            selection = popupnode.title;
        } else if (popupnode.alt) {
            selection = popupnode.alt;
        }

    } else if (nodeLocalName == "a" && popupnode.hasAttribute("href") && (popupnode.textContent != "" || popupnode.hasAttribute("title"))) {

        if (popupnode.textContent != "") {
            selection = popupnode.textContent;

        } else if (popupnode.hasAttribute("title")) {
            selection = popupnode.getAttribute("title");
        }

    } else {
        selection = document.commandDispatcher.focusedWindow.getSelection().toString();
    }

    return selection;
}

function popup(title, text) {
    try {
        Components.classes['@mozilla.org/alerts-service;1'].
            getService(Components.interfaces.nsIAlertsService).
            showAlertNotification("chrome://newwordsforme/skin/icon.png", title, text, false, '', null);
    } catch(e) {
        var image = null;
	    var win = Components.classes['@mozilla.org/embedcomp/window-watcher;1'].
			getService(Components.interfaces.nsIWindowWatcher).
		    openWindow(null, 'chrome://global/content/alerts/alert.xul', '_blank', 'chrome,titlebar=no,popup=yes', null);
		win.arguments = [image, null, text, false, '']; 
    }
}
