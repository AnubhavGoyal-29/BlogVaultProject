document.getElementById("plugin_radio").addEventListener("click", () => {
	document.getElementById("plugin_option").style.display = "block";
	document.getElementById("theme_option").style.display = "none";
	document.getElementById("js_option").style.display = "none";
});
document.getElementById("theme_radio").addEventListener("click", () => {
        document.getElementById("plugin_option").style.display = "none";
        document.getElementById("theme_option").style.display = "block";
        document.getElementById("js_option").style.display = "none";
});
document.getElementById("js_radio").addEventListener("click", () => {
        document.getElementById("plugin_option").style.display = "none";
        document.getElementById("theme_option").style.display = "none";
        document.getElementById("js_option").style.display = "block";
});

