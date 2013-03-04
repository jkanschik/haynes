//= require jquery
//= require jquery_ujs
//= require_tree .

// Allow the recognition of IE 6 because IE 6 has a bug which makes the AJAX for the quicksearch impossible.
Prototype.Browser.IE6 = Prototype.Browser.IE && parseInt(
navigator.userAgent.substring 
(navigator.userAgent.indexOf("MSIE")+5))==6;


// Toggles the details on works/show
function toggle(details_id, link_id, text) {
	details = document.getElementById(details_id);
	link = document.getElementById(link_id);
	if (details.style.display == "none") {
		details.style.display = "block";
		link.firstChild.nodeValue = "Hide " + text;
	} else {
		details.style.display = "none";
		link.firstChild.nodeValue = "Show " + text;
	}
}

// Latest events: 
function show_events(type) {
	deselect('all');
	deselect('new');
	deselect('changes');
	menu_item = document.getElementById("event_menu_" + type);
	menu_item.className = "selected";
	events = document.getElementById("events_" + type);
	events.style.display = 'block';
}
function deselect(type) {
	menu_item = document.getElementById("event_menu_" + type);
	menu_item.className = "";
	events = document.getElementById("events_" + type);
	events.style.display = 'none';
}

// Toggles the submenus on the left 
function toggle_menu(name) {
	submenu = document.getElementById("submenu_" + name)
	if (submenu.style.display == "none")
		submenu.style.display = "block";
	else
		submenu.style.display = "none";
}
