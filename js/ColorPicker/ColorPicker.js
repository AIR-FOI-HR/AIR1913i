var default_colors = ["#6ebaef", "#f7904a", "#1fc996", "#f95c99", "#b575e8", "#18c5d3", "#6674fc", "#dd47bf", "#87a7b3", "#f98282", "#3b7db8"];
var created = false;
var container;

var output;
var button;

function ColorPicker(el, op, btn) {
    output = op;
    button = btn;

    if (!created)
        CreateHTML(el);
    else
        container.toggle();
}

function CreateHTML(el) {
    var html = "";
    html += "<div class='c_container'>";

    for (i = 0; i < default_colors.length; i++) {
        html += "<div class='colors' onclick='ChooseColor(this);' style='background-color:" + default_colors[i] + "'></div>";
    }
    //html += "<span class='hash'>#</span><input class='hexcolor' type='text' /><div class='colors hex' onclick='ChooseColor(this);'></div>";
    html += "</div>";
    $(el).html(html);

    //$(el).on('input', function () {
    //    var c_hex = "#" + $(this).find("input").val();
    //    var hex = $(".hex");
    //    hex.attr("background-color", c_hex);
    //});

    container = $(".c_container");
    created = true;
}

function ChooseColor(el) {
    var background = $(el).attr("style");
    var color = background.replace("background-color:", "");
    output.val(color);
    button.css("background-color", color);
}

$(document).mouseup(function (e) {
    container = $(".c_container");
    if (!container.is(e.target) && container.has(e.target).length === 0 && e.target.id != "btnColor") {
        container.hide();
    }
});