window.addEventListener("load",function(e) {
    var selectedWord = "";

    document.getElementById("contentAreaContextMenu").addEventListener("popupshowing",function(event) {
        selectedWord = getSelection(document.popupNode);
        document.getElementById("menuitem_flashcard_add").hidden = (selectedWord.length == 0);
        document.getElementById("separator_flashcard").hidden = (selectedWord.length == 0);

        document.getElementById("menuitem_flashcard_add").setAttribute("label", '把" ' + selectedWord + ' "加入我的单词本');
    },
    false);

    document.getElementById("menuitem_flashcard_add").addEventListener("click",function(event) {
        if (Keepin.isLogin()) {
            var result = Keepin.postMessage(selectedWord);
            PopupNotifications.show(gBrowser.selectedBrowser, "flashcard-add",
            '"' + selectedWord + '" 已经成功加入你的单词本',
            null,
            {
                label: "确定",
                accessKey: "D",
                callback: function() {
                    }
            },
            [
            {
                label: "Reset",
                accessKey: "R",
                callback: function() {
                    Browser.Preferences.clearUserPref("userid");
                }
            },
            ]);
            return;
        }

        showLoginDialog();

    },
    false);
},
false);

function showLoginDialog() {
    PopupNotifications.show(gBrowser.selectedBrowser, "flashcard-add",
    '登陆到您的Keepin。',
    null,
    {
        label: "登陆",
        accessKey: "D",
        callback: function() {
            window.openDialog("chrome://flashcard/content/login.xul", "chrome, dialog");
        }
    },
    null);
}

function login() {
    var name = document.getElementById("txt_flashcard_name").value;
    var password = document.getElementById("txt_flashcard_password").value

    return Keepin.login(name,password);
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
