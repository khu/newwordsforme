window.addEventListener("load", function(e) {
        var selectedWord = "";

        document.getElementById("contentAreaContextMenu").addEventListener("popupshowing", function(event) {
                selectedWord = getSelection(document.popupNode);
                document.getElementById("menuitem_flashcard_add").hidden = (selectedWord.length == 0);
                document.getElementById("separator_flashcard").hidden = (selectedWord.length == 0);

                document.getElementById("menuitem_flashcard_add").setAttribute("label", '把" ' + selectedWord + ' "加入我的单词本');
            },
            false);

        document.getElementById("menuitem_flashcard_add").addEventListener("click", function(event) {
                if (Keepin.isLogin()) {
                    var result = Keepin.postMessage(selectedWord);
                    popup("Notification", selectedWord + "已经成功加入你的单词本.");
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

    return Keepin.login(name, password);
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
            showAlertNotification("chrome://flashcard/skin/icon.png", title, text, false, '', null);
    } catch(e) {
        var image = null;
	    var win = Components.classes['@mozilla.org/embedcomp/window-watcher;1'].
			getService(Components.interfaces.nsIWindowWatcher).
		    openWindow(null, 'chrome://global/content/alerts/alert.xul', '_blank', 'chrome,titlebar=no,popup=yes', null);
		win.arguments = [image, null, text, false, '']; 
    }
}
