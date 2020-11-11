var ctrlPressed = false;

// Handles all keyboard controls on web
function HandleKeyDOWN(e) {
    switch (e.which) {
        case 27:
            $(".iamhelping").hide();
            break;
        case 16:
            e.preventDefault();
            ShiftDOWNEvent();
            break;
        case 17:
            e.preventDefault();
            ctrlPressed = true;
            break;
        case 37:
            e.preventDefault();
            LeftArrow();
            break;
        case 38:
            e.preventDefault();
            UpArrow();
            break;
        case 39:
            e.preventDefault();
            RightArrow();
            break;
        case 40:
            e.preventDefault();
            DownArrow();
            break;
        case 13:
            // ENTER for finished example
            e.preventDefault();
            HandleEnterClick();
            break;
        case 8:
            // BACKSPACE for previous entity
            //PreviousEntity();
            break;
        case 107:
        case 187:
            // PLUS and PLUS on numpad
            //PositiveSentiment();
            break;
        case 109:
        case 189:
            // MINUS and MINUS on numpad
            //NegativeSentiment();
            break;
        case 48:
        case 96:
            // ZERO and ZERO on numpad
            //NeutralSentiment();
            break;
        case 33:
            // PAGEUP
            e.preventDefault();
            JumpToExample(false);
            break;
        case 34:
            // PAGEDOWN
            e.preventDefault();
            JumpToExample(true);
            break;
        case 35:
            // END
            e.preventDefault();
            if (!ctrlPressed)
                LastEntityInExample();
            else
                LastEntityInProject();
            break;
        case 36:
            // HOME
            e.preventDefault();
            if (!ctrlPressed)
                FirstEntityInExample();
            else
                FirstEntityInProject();
            break;
    }
}

function HandleKeyUP(e) {
    switch (e.which) {
        case 16:
            e.preventDefault();
            ShiftUPEvent();
            break;
        case 17:
            e.preventDefault();
            ctrlPressed = false;
            break;
    }
}

function HandleKeyPress(e) {
    current = $(".current");
    if (current.length == 0)
        return;

    var exampleId = $(current).attr("id").split("_")[1];
    // if focus on textbox, don't check for clicked category
    var FocusOnTextBox = false;
    $("#rsidebar_" + exampleId) > $("[id^=rbv_]").each(function () {
        if ($(this).hasClass("focus-visible")) {
            FocusOnTextBox = true;
        }
    });
    if (FocusOnTextBox)
        return;

    //var ids = $(current).attr("id").split("_");
    //var category = $("#Category_E" + ids[1]).children().first().children().first().attr("id").split("_")[1];

    var letter = String.fromCharCode(e.which);
    for (i = 0; i < listOfCategories.length; i++) {
        if (listOfCategories[i].Shortcut == letter/* && listOfCategories[i].CategoryID == category*/ && listOfCategories[i].ExampleId == exampleId) {
            var handle = "";
            var rb = $("#Category_E" + exampleId + " #rb_" + listOfCategories[i].SubCategoryID);
            if (rb.length > 0) {
                if ($(rb).is(":checked"))
                    $(rb).prop("checked", false);
                else
                    $(rb).prop("checked", true);
                handle = $(rb);
                Mark(listOfCategories[i].SubCategoryID, handle);
            }

            var rbv = $("#rsidebar_" + exampleId + " #rbv_" + listOfCategories[i].SubCategoryID);
            if (rbv.length > 0) {
                if (rbv.attr("type") == "text") {
                    $(rbv).focus();
                }
                else {
                    if (rbv.is(":checked"))
                        $(rbv).prop("checked", false);
                    else
                        $(rbv).prop("checked", true);
                    handle = $(rbv);
                    Mark(listOfCategories[i].SubCategoryID, handle);
                }
            }

            break;
        }
    }
}

// Jumps from one to another example using PAGE DOWN and PAGE UP
function JumpToExample(next) {
    var id;
    if (next == true) {
        var next_child = $(".current").parent().parent().parent().next().children("div");
        if (next_child.length > 0 && next_child.is(":visible")) {
            //$('html, body').scrollTop(next_child.offset().top);
            id = $(".current").parent().parent().parent().next().children("div")[0].id;
        }
    }
    else {
        var prev_child = $(".current").parent().parent().parent().prev().children("div");
        if (prev_child.length > 0 && prev_child.is(":visible")) {
            //$('html, body').scrollTop(prev_child.offset().top);
            id = $(".current").parent().parent().parent().prev().children("div")[0].id;
        }
    }

    current = $(".current");
    if (current.length == 0)
        FirstEntity();

    if (id == undefined)
        return;

    content = "#" + id;
    sentence = "#" + $(content).children().first().attr("id");
    entity = $(sentence).children().first().attr("id");

    sentence = entity.split("_")[2];
    entity = entity.split("_")[3];

    // remove current after finding next element
    $(".current").removeClass("current");
    // get new current element and assign it
    CurrentElement(true);
}

// Scrolls to selected (el) element
// Update is needed (runs slow if smashing enter or backspace)
function ScrollToElement(el) {
    var elOffset = el.offset().top;
    var elHeight = el.height();
    var windowHeight = $(window).height();
    var offset;

    if (isElementInViewport(el))
        return;

    if (elHeight < windowHeight) {
        offset = elOffset - ((windowHeight / 2) - (elHeight / 2));
    }
    else {
        offset = elOffset;
    }
    //$('html, body').animate({ scrollTop: offset }, 700);
    $('html, body').scrollTop(offset);
}

function isElementInViewport(el) {
    if (typeof jQuery === "function" && el instanceof jQuery) {
        el = el[0];
    }
    var rect = el.getBoundingClientRect();
    return (
        rect.top >= 0 &&
        rect.left >= 0 &&
        rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) && /* or $(window).height() */
        rect.right <= (window.innerWidth || document.documentElement.clientWidth) /* or $(window).width() */
    );
}

// goes to next span with class entity
// sets current class to next element and removes current class on last element
function NextEntity() {
    if ($(".current").length) {
        var next_element = $(".entity").eq($(".entity").index($(".current")) + 1);
        var wi = 1;
        while (next_element.parent().parent().parent().css("display") == "none") {
            next_element = $(".entity").eq($(".entity").index($(".current")) + wi);
            wi++;
        }
        $(".current").removeClass("current");
        $(next_element).addClass("current");
        ScrollToElement($(next_element));
    }
    else {
        ScrollToElement($(".entity"));
        $(".entity").first().addClass("current");
        next_element = $(".entity").first();
    }
    entity = $(".current");

    ShowContentBar(next_element);
}

function getBreakingPoints() {
    var text = $(content).text(),
        len = text.length,
        width = $(content).width(),
        charWidth = 6.8,
        charsPerRow = Math.floor(width / charWidth);

    var breakingIndexes = [],
        gRowStart = 0,
        gRowEnd = charsPerRow;

    while (gRowEnd < len) {
        var rowEnd = text.substring(gRowStart, gRowEnd).lastIndexOf(' ');
        breakingIndexes.push(gRowStart + rowEnd);
        gRowStart = gRowStart + rowEnd + 1; // next start is the next char
        gRowEnd = gRowStart + charsPerRow;
    }

    console.log(
        '\ntext len:\t' + len +
        '\ncontainer w:\t' + width +
        '\nchar w:\t\t' + charWidth +
        '\ncharsPerRow:\t' + charsPerRow +
        '\nbreakingIndexes:\t' + breakingIndexes
    );

    for (var i = 0; i < breakingIndexes.length; i++) {
        start = breakingIndexes[i];
    }

    return breakingIndexes;
}

var content;
var sentence;
var entity;
var current;

var left_right = 0;

function CurrentElement(remove) {
    if (remove && current != null) {
        current.removeClass("current");
    }

    if (!shiftdownpressed) {
        $(".current_space").each(function () {
            $(this).removeClass("current_space");
        });
    }
    if (left_right < lr)
        $(content + "_" + sentence + "_" + entity).prev().addClass("current_space");
    else if (left_right > lr)
        $(content + "_" + sentence + "_" + entity).next().addClass("current_space");
    left_right = lr;

    $(content + "_" + sentence + "_" + entity).addClass("current");

    ShowContentBar($(".current"));
    ScrollToElement($(".current"));
    current = $(".current");

    if (lr > 1 || lr < -1) {
        if (lr > 0) {
            current = $(".current").last();
        }
        else {
            current = $(".current");
        }
    }
    //if (!remove)
    //$(content + "_" + sentence + "_" + entity).prev().addClass("current_space");

    CurrentExample(content);
}

function CurrentExample(content) {
    $("[class^=ex_counter]").each(function () {
        $(this).css("color", "grey");
        $("." + $(this).children()[0].className).css("color", "transparent");
    });
    var id = content.match(/\d+/)[0];
    $(".ex_counter_" + id).css("color", "black");
    $($(".ex_counter_" + id).children()[0]).css("color", "red");
}

function FirstEntityInExample() {
    if (current != null) {
        content = "#" + $(current).parent().parent().attr("id");
        sentence = "1";
        entity = "1";
        CurrentElement(true);
    }
    else {
        FirstEntity();
    }
}

function LastEntityInProject() {
    var e = $("[id^=Content_]").last().attr("id").split("_");
    content = "#" + e[0] + "_" + e[1];
    sentence = "1";
    entity = "1";
    CurrentElement(true);
}

function FirstEntityInProject() {
    content = "#" + $("[id^=Content_]").first().attr("id");
    sentence = "1";
    entity = "1";
    CurrentElement(true);
}

function LastEntityInExample() {
    if (current != null) {
        var cID = $(current).parent().parent();
        content = "#" + cID.attr("id");
        //var eID = cID.children().last().children().last();

        var kids = cID.children().last().children();
        for (i = kids.length - 1; i >= 0; i--) {
            if (kids[i].id != "" && kids[i].id != undefined) {
                eID = $(kids[i]);
                break;
            }
        }

        var SE = eID.attr("id").split("_");
        sentence = SE[2];
        entity = SE[3];
        CurrentElement(true);
    }
    else {
        FirstEntity();
    }
}

function FirstEntity() {
    content = "#" + $("[id^=Content_]:visible:first").attr("id");
    sentence = "1";
    entity = "1";
    CurrentElement(true);
}

function MouseOver(e) {
    var id = $(e.target);
    if (id == null || id == undefined)
        return;

    var subID = undefined;
    if (id != 0 && $(id).attr("id") != null) {
        var check = $(id).attr("id").split("_").length;
        if (check <= 3)
            return;
        subID = id.attr("data-subcategory");
    }

    var name = "";
    var color = "";
    if (subID != undefined) {
        name = $("#cat_" + subID).text().trim();
        color = $("#cat_" + subID).css("background-color");
    }
    else {
        color = id.css("background-color");
        $("[id^=cat_]:visible").each(function () {
            if ($(this).css("background-color") == color && $(this).css("background-color") != "rgba(0, 0, 0, 0)") {
                name = $(this).text().trim();
            }
        });
    }

    var d = $("#Description_MouseOver");
    d.css("top", id.position().top - 15);
    d.css("left", id.position().left);
    d.text(name);
    d.css("background-color", color);
    d.show();
}

function rgbToHex(r, g, b) {
    return "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1);
}

function RemoveMouseOver(e) {
    $("#Description_MouseOver").hide();
}

function MouseClick(e) {
    var id = e.target.id;
    if (id == null || id == undefined || id == 0)
        return;

    var check = id.split("_").length;
    if (check == 3) {
        content = "#" + id.split("_")[0] + "_" + id.split("_")[1];
        sentence = id.split("_")[2];
        entity = 1;
        CurrentElement(true);
    }
    if (check <= 3)
        return;

    $(".current").each(function () {
        $(this).removeClass("current");
    });
    $("#" + id).addClass("current");

    current = $(".current");
    if (current.length && current.is(":visible")) {
        content = "#" + $(current).parent().parent().attr("id");
        sentence = $(current).attr("id").split("_")[2];
        entity = $(current).attr("id").split("_")[3];
        CurrentElement(true);
    }
    else {
        FirstEntity();
    }
}

var startX;
var endX;

function StartMousePosition(e) {
    startX = e.pageX;
}

function SelectFromTo(e, from, to) {
    $(".current_space").each(function () {
        $(this).removeClass("current_space");
    });

    $(".current").each(function () {
        $(this).removeClass("current");
    });

    endX = e.pageX;

    if ((from.attr("id") == undefined && to.attr("id") == undefined)) {
        from = from.next();
        to = to.next();
    }

    if (from.attr("id") == to.attr("id")) {
        from.addClass("current");
    }
    else {
        if (endX >= startX)
            from.nextUntil(to).addBack().add(to).each(function () {
                if ($(this).parent().get(0).tagName == "SPAN") {
                    if ($(this).attr("id") != "" && $(this).attr("id") != undefined)
                        $(this).addClass("current");
                    else if ($(this).parent().attr("id") != undefined)
                        $(this).addClass("current_space");
                    else
                        return;
                }
            });
        else
            from.prevUntil(to).addBack().add(to).each(function () {
                if ($(this).parent().get(0).tagName == "SPAN") {
                    if ($(this).attr("id") != "" && $(this).attr("id") != undefined)
                        $(this).addClass("current");
                    else if ($(this).parent().attr("id") != undefined)
                        $(this).addClass("current_space");
                    else
                        return;
                }
            });
    }

    current = $(".current");
    ShowContentBar(current);
    ScrollToElement(current);
    var split = current.attr("id").split("_");
    content = "#" + split[0] + "_" + split[1];
    CurrentExample(content);
    window.getSelection().empty();
}

var lr = 0;
function RightArrow() {
    var remove = true;
    if (shiftdownpressed) {
        remove = false;
        lr++;
        console.log(lr);
    }

    current = $(".current");
    if (current.length && current.is(":visible")) {
        if (ElementChange(current, 1))
            CurrentElement(remove);
    }
    else {
        FirstEntity();
    }
}

function LeftArrow() {
    var remove = true;
    if (shiftdownpressed) {
        remove = false;
        lr--;
        console.log(lr);
    }

    current = $(".current");
    if (current.length && current.is(":visible")) {
        if (ElementChange(current, -1))
            CurrentElement(remove);
    }
    else {
        FirstEntity();
    }
}

function DownArrow() {
    current = $(".current");
    if (!current.length || !current.is(":visible")) {
        FirstEntity();
        return;
    }

    $(".current_space").each(function () {
        $(this).removeClass("current_space");
    });

    var breaking_indexes = getBreakingPoints();
    var index = 0;
    $(".current").parent().prevUntil().each(function () {
        // rečenice
        index += $(this).text().length;
    });

    var counter = 0;
    $(".current").prevUntil().each(function () {
        // unutar rečenice
        var space = 1; // postoji space
        if (counter == 0)
            space = 0;

        //var match = $(this).text().match("[^\w\s]"); // potrebno provjeravati punkcijske znakove
        index += $(this).text().length + space;

        counter++;
    });

    var start, end;
    for (i = 0; i < breaking_indexes.length; i++) {
        if (index > breaking_indexes[i])
            start = breaking_indexes[i]
        else {
            end = breaking_indexes[i]
            break;
        }
    }

    if (start == undefined)
        start = 0;

    var wanted_index = (index - start) + end;
    var ids = $(".current").attr("id").split("_");
    var contentID = ids[1];

    if (isNaN(wanted_index) || wanted_index >= $("#" + ids[0] + "_" + ids[1]).text().length || end == breaking_indexes[breaking_indexes.length - 1]) {
        content = "#" + ids[0] + "_" + ids[1];
        if ($(content).parent().next().children()[1] != null && $(content).parent().next().children().is(":visible")) {
            content = "#" + $(content).parent().next().children()[1].id;
            sentence = $(content).children().first().attr("id").split("_")[2];
            entity = $(content + "_" + sentence).children().first().attr("id").split("_")[3];
            CurrentElement(true);
        }
        return;
    }
    else if (end >= breaking_indexes[breaking_indexes.length - 2] && end <= breaking_indexes[breaking_indexes.length - 1]) {
        LastEntityInExample();
        //content = "#" + ids[0] + "_" + ids[1];
        //if ($(content).parent().next().children()[1] != null && $(content).parent().next().children().is(":visible")) {
        //    //content = "#" + $(content).parent().next().children()[1].id;
        //    sentence = $(content).children().last().attr("id").split("_")[2];
        //    entity = $(content + "_" + sentence).children().last().attr("id").split("_")[3];
        //    CurrentElement(true);
        //}
        //return;
    }

    $("[id^=Content_" + contentID + "_]").each(function () {
        if ($(this).attr("id").split("_").length == 4) {
            var startIndex = $(this).attr("data-startindex");
            var endIndex = $(this).attr("data-endindex");
            if (startIndex <= wanted_index && endIndex >= wanted_index) {
                var idz = $(this).attr("id").split("_");
                content = "#" + idz[0] + "_" + idz[1];
                sentence = idz[2];
                entity = idz[3];
                CurrentElement(true);
                return;
            }
        }
    });
}

function UpArrow() {
    current = $(".current");
    if (!current.length || !current.is(":visible")) {
        FirstEntity();
        return;
    }

    $(".current_space").each(function () {
        $(this).removeClass("current_space");
    });

    var breaking_indexes = getBreakingPoints();

    var index = 0;
    $(".current").parent().prevUntil().each(function () {
        // rečenice
        index += $(this).text().length;
    });

    var counter = 0;
    $(".current").prevUntil().each(function () {
        // unutar rečenice
        var space = 1; // postoji space
        if (counter == 0)
            space = 0;

        //var match = $(this).text().match("[^\w\s]"); // potrebno provjeravati punkcijske znakove
        index += $(this).text().length + space;

        counter++;
    });

    var start, end;
    for (i = 0; i < breaking_indexes.length; i++) {
        if (i == breaking_indexes.length - 1) {
            start = breaking_indexes[i - 1];
            end = breaking_indexes[i];
            break;
        }
        if (index > breaking_indexes[i])
            start = breaking_indexes[i]
        else {
            end = breaking_indexes[i]
            break;
        }
    }

    if (start == undefined)
        start = 0;

    if (end == undefined)
        end = $(content).text().length;

    var wanted_index = start + (index - end);
    var ids = $(".current").attr("id").split("_");
    var contentID = ids[1];

    wanted_index = wanted_index - 30;
    if (wanted_index < 0) {
        content = "#" + ids[0] + "_" + ids[1];
        if ($(content).parent().prev().children()[1] != null) {
            var _id = $(content).parent().prev().children()[1].id
            if (_id != "") {
                _content = "#" + _id;
                if ($(_content).is(":visible")) {
                    content = _content;
                    sentence = $(content).children().first().attr("id").split("_")[2];

                    var kids = $(content + "_" + sentence).children().first();
                    entity = kids.attr("id").split("_")[3];
                    CurrentElement(true);
                }
            }
        }
        else
            FirstEntity();
        return;
    }

    var lastIndex = $("[id^=Content_" + contentID + "_]").last().attr("data-endindex");
    if (lastIndex <= start) {
        wanted_index = parseInt(lastIndex) + (index - end);
    }

    $("[id^=Content_" + contentID + "_]").each(function () {
        if ($(this).attr("id").split("_").length == 4) {
            var startIndex = $(this).attr("data-startindex");
            var endIndex = $(this).attr("data-endindex");
            if (startIndex <= wanted_index && endIndex >= wanted_index) {
                var idz = $(this).attr("id").split("_");
                content = "#" + idz[0] + "_" + idz[1];
                sentence = idz[2];
                entity = idz[3];
                CurrentElement(true);
                return;
            }
        }
    });
}

var shiftdownpressed = false;
function ShiftDOWNEvent() {
    shiftdownpressed = true;
}

function ShiftUPEvent() {
    shiftdownpressed = false;
}

function ElementChange(current, next) {
    if (next == 1)
        current = $(".current").last();
    else if (next == -1)
        current = $(".current").first();
    var eID = parseInt(current.attr("id").split("_")[3].match(/\d+/)[0]);
    var next_eID = eID + next;
    entity = next_eID;
    sentence = current.attr("id").split("_")[2];
    var _content = content;
    if ($(content + "_" + sentence + "_" + entity).length == 0) {
        next_sentence = parseInt(sentence) + next;
        if (parseInt($(content).children().last().attr("id").split("_")[2].match(/\d+/)[0]) < next_sentence) {
            if ($(content).parent().next().children()[1] != null) {
                var _id = $(content).parent().next().children()[1].id;
                if (_id != "") {
                    content = "#" + _id;
                    next_sentence = 1;
                }
            }
        }

        if (next_sentence == 0 && next_eID == 0) {
            if ($(content).parent().prev().children()[1] != null) {
                if ($(content).parent().prev().children()[1].id != "") {
                    content = "#" + $(content).parent().prev().children()[1].id;
                    if ($(content).children().last().attr("id") != undefined)
                        next_sentence = $(content).children().first().attr("id").split("_")[2];
                }
            }
        }

        if (next_sentence <= 0)
            return;

        if (!$(content).is(":visible")) {
            content = _content;
            return;
        }

        if ($(content + "_" + next_sentence).length == 0)
            return;

        sentence = next_sentence;
        if (next == 1) {
            entity = $(content + "_" + sentence).children().first().attr("id").split("_")[3];
        }
        else if (next == -1) {
            var kids = $(content + "_" + sentence).children().first();
            entity = kids.attr("id").split("_")[3];
            //for (i = kids.length - 1; i >= 0; i--) {
            //    if (kids[i].id != "" && kids[i].id != undefined) {
            //        entity = kids[i].id.split("_")[3];
            //        break;
            //    }
            //}
        }
    }
    else {
        content = "#" + $(current).parent().parent().attr("id");
    }

    if (entity == "#undefined")
        return false;

    return true;
}

// goes to previous span with class entity
// sets current class to previous element and removes current class on last element
function PreviousEntity() {
    if ($(".current").length) {
        var prev_element = $(".entity").eq($(".entity").index($(".current")) - 1);
        if (prev_element.parent().parent().parent().css("display") == "none")
            return;
        $(".current").removeClass("current");
        $(prev_element).addClass("current");
        ScrollToElement($(prev_element));
    }
    else {
        ScrollToElement($(".entity"));
        $(".entity").first().addClass("current");
        prev_element = $(".entity").first();
    }
    entity = $(".current");

    ShowContentBar(prev_element);
}

// show all relevant data for current example
function ShowContentBar(next_element) {
    if ($(next_element).length == 0)
        return;

    var id = $(next_element).parent().parent().attr("id").match(/\d+/)[0];
    $("[id^=Category_E]").each(function () {
        $(this).hide();
    });

    // show info (left sidebar)
    $("[id^=Category_E" + id + "]").each(function () {
        $(this).show();
    });
    $("#current_example").show();
    $("#current_subcategory").show();
    $("#current_example").html("<div>Primjer ID: " + id + "</div><div class='word'>Riječ: " + SetWordText($(".current")) + "</div><div class='desc_word'>" + SetWordText($(".current")) + "</div>");

    UpdateSubcategory();
}

function SetWordText(current) {
    var text = "";
    current.each(function () {
        text += $(this).text() + " ";
    });
    return text;
}

// sets positive sentiment to the entity
function PositiveSentiment() {
    MarkHandle("+");
    UpdateSubcategory();
}

// sets negative sentiment to the entity
function NegativeSentiment() {
    MarkHandle("-");
    UpdateSubcategory();
}

// sets neutral sentiment to the entity
function NeutralSentiment() {
    MarkHandle("0");
    UpdateSubcategory();
}

// updates subcategory name on sidebar
function UpdateSubcategory() {
    current = $(".current");

    var subcategory_id = $(current).attr("data-subcategory");
    var exampleID = $(current).attr("id").split("_")[1];

    $("[id^=rb_]").each(function () {
        $(this).prop("checked", false);
    });

    var n = "";
    var text = $(current).attr("data-text");
    if (text == undefined) {
        $("#txt_input").val("");
    }
    else if (text != undefined) {
        $("#txt_input").val(text);
        return;
    }

    if (subcategory_id == undefined) {
        n = "/";
        $("#current_subcategory").html("<div>Subkategorija: " + n + "</div>");
        return;
    }

    var ids = subcategory_id.split("_");
    for (i = 0; i < ids.length; i++) {
        //var name = $("#cat_" + ids[i]).clone().children().remove().end().text();
        var name = $("#cat_" + ids[i]).text();
        if (name != "")
            $("#Category_E" + exampleID + " #rb_" + ids[i]).prop("checked", true);
        else
            $("#rb_dummy").prop("checked", true);

        n += name == "" ? "/" : name;
        $("#current_subcategory").html("<div>Subkategorija: " + n + "</div>");
    }
}


//var already_marked = false;
function Mark(id, handle) {
    // provjera je li postoji već neki označen
    //if ($(".current").length > 1)
    //    $(".current").each(function () {
    //        var ids = $(current).attr('id').split("_");
    //        if ($(this).attr("data-subcategory") != undefined)
    //            if ($(this).attr("data-subcategory") == id.toString()) {
    //                already_marked = true;
    //                MarkEntity(ids[3], ids[1], ids[2], id.toString(), "");
    //            }
    //    });

    $(".current").each(function () {
        current = $(this);
        var ids = $(current).attr('id').split("_");
        var exampleId = ids[1];
        var sentenceId = ids[2];
        var entityId = ids[3];
        var subcategoryId = id.toString();
        var marked = MarkEntity(entityId, exampleId, sentenceId, subcategoryId, "");
        if (marked) {
            ColorEntity(entityId, exampleId, sentenceId, subcategoryId, $(handle).is(":checked"));
            UpdateSubcategory();
        }
    });
}

function MarkTextOnExample(handle) {
    $(".current").each(function () {
        current = $(this);
        // check current and sidebar ID
        var sidebarID = $(handle).parent().parent().parent().attr("id").match(/\d+/)[0];
        //var ids = $(current).attr('id').split("_");
        //var exampleId = ids[1];
        // current nije na istom mjestu kao i textbox s desne strane
        //if (sidebarID != exampleId)
        //    return;

        var subID = handle.id.match(/\d+/).toString();
        var txtID = "#rsidebar_" + sidebarID + " #" + $(handle).attr("id");
        var text = $(txtID).val();

        MarkEntity(null, sidebarID, null, subID, text);
    });
}

function MarkText(handle) {
    $(".current").each(function () {
        current = $(this);
        var ids = $(current).attr('id').split("_");
        var exampleId = ids[1];
        var sentenceId = ids[2];
        var entityId = ids[3];
        var markit = $("#Content_" + exampleId + "_" + sentenceId + "_" + entityId);
        markit.css("background-color", "#2C83D6");
        var txtID = "#" + $(handle).attr("id");
        var text = $(txtID).val();
        markit.attr("data-text", text);

        MarkEntity(entityId, exampleId, sentenceId, null, text);
    });
}

// marks entity
// 1. Take parameters for Database
// 2. Get color of subcategory and mark it in HTML
// 3. Saves entity to Database (Ajax)
function MarkHandle(sentiment) {
    var parent = $(current).parent()[0];
    $("#Category_E" + parent.parentElement.id.match(/\d+/)[0] + " .category").each(function (e) {
        if ($(this).data("sentiment") == sentiment) {
            var entityId = $(current).attr('id');
            var textId = $(current).parent()[0].parentElement.id;
            var sentenceId = $(current).parent()[0].id;
            var subcategoryId = $(this).attr('id');
            ColorEntity(entityId, textId, sentenceId, subcategoryId);
            MarkEntity(entityId, textId, sentenceId, subcategoryId, "");
        }
    });
}

// Colors entity in HTML
function ColorEntity(entityId, textId, sentenceId, subcategoryId, isChecked) {
    var color = GetSubcategoryColor(subcategoryId);
    var markit = $("#Content_" + textId + "_" + sentenceId + "_" + entityId);
    if (isChecked == true) {
        if ($(markit).attr("data-subcategory") == undefined)
            $(markit).attr("data-subcategory", subcategoryId.match(/\d+/)[0]);
        else {
            var data;
            if ($("#Category_E" + textId).children().first().children().last().attr("type") != "radio") {
                // ovo je potrebno za checkbox
                //var predata = $(markit).attr("data-subcategory");
                //if (predata != "")
                //data = predata + "_" + subcategoryId.match(/\d+/)[0];
                //else
                data = subcategoryId.match(/\d+/)[0];
            }
            else
                data = subcategoryId.match(/\d+/)[0];
            $(markit).attr("data-subcategory", data);
        }
    }
    else {
        if ($(markit).attr("data-subcategory") == undefined)
            return;
        var data = $(markit).attr("data-subcategory").split("_");
        var new_data = "";
        for (i = 0; i < data.length; i++) {
            if (data[i] != subcategoryId) {
                color = GetSubcategoryColor(data[i]);
                new_data += data[i] + "_";
            }
        }
        new_data = new_data.slice(0, -1);
        $(markit).attr("data-subcategory", new_data);
        if (new_data == "")
            color = "#fff";
    }

    if ($(markit).next().hasClass("current_space"))
        $(markit).next().css("background-color", color);

    $(markit).css("background-color", color);
}

// Outputs color from Database
function GetSubcategoryColor(subcategoryId) {
    var obj = {};
    obj.SubcategoryId = subcategoryId.match(/\d+/)[0];

    var color = "";
    $.ajax({
        type: "POST",
        url: "/Client/ajax/DataHelper.aspx/GetSubcategoryColor",
        data: JSON.stringify(obj),
        async: false,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (r) {
            color = r.d;
        }
    });

    return color;
}

// handles word selection for saving and deleting entities
function WordSelection(class_name) {
    $("." + class_name).click(function (e) {
        if (!$('#cbHandleEntities').is(":checked"))
            return;

        var target = e.target;
        var textId = e.currentTarget.id;

        var s = window.getSelection();
        s.modify('extend', 'backward', 'word');
        var b = s.toString();

        s.modify('extend', 'forward', 'word');
        var a = s.toString();
        s.modify('move', 'forward', 'character');

        // restriction so that you can't mark more than one word.
        if (b.split(' ').length > 1 && a.split(' ').length > 1)
            return;

        // removing blank spaces
        var word = b.replace(" ", "") + a.replace(" ", "");

        // g modifier global (all matches - don't return on first match)
        // if the words are same in one sentence, it will mark both of them... NEEDS fixing
        var reg = new RegExp(word, 'g');

        if (target.classList.contains("entity")) {
            if (confirm('Želite li obrisati "' + word + '" kao entitet?')) {
                var sentenceId = target.parentElement.id;
                // add word after <span>
                $("#" + textId + " #" + sentenceId + " #" + target.id).after(word);
                // remove span
                $("#" + textId + " #" + sentenceId + " #" + target.id).remove();
                RemoveIfMarked(target.id, sentenceId, textId);
                SaveEntity(textId);
            }
            return;
        }
        else {
            if (confirm('Spremite "' + word + '" kao entitet?')) {
                var sentenceId = target.id;

                var textSentence = "";
                $.each($("#" + textId + " #" + sentenceId).html().split(' '), function (i, text) {

                    // start of sentence
                    if (i == 0 && text == "")
                        textSentence += " ";

                    if (text.indexOf(word) >= 0) {
                        if (word.indexOf("entity") < 0) {
                            textSentence += text.replace(word, "<span id='e" + (i + 1) + "' class='entity'>" + word + "</span>");
                            textSentence += " ";
                        }
                    }
                    else
                        if (text != "")
                            textSentence += text + " ";
                });

                // remove current class
                $("#" + textId + " #" + sentenceId).html(textSentence);
                SaveEntity(textId);
            }
        }
    });
}

// deletes marked entity
function RemoveIfMarked(entityId, sentenceId, textId) {
    var obj = {};
    obj.EntityId = entityId.match(/\d+/)[0];
    obj.SentenceId = sentenceId;
    obj.TextId = textId.match(/\d+/)[0];

    $.ajax({
        type: "POST",
        url: "/Client/ajax/DataHelper.aspx/RemoveMarked",
        data: JSON.stringify(obj),
        async: false,
        contentType: "application/json; charset=utf-8",
        dataType: "json"
    });
}

// saves entity to the database
function SaveEntity(textId) {
    var obj = {};
    obj.ExampleId = textId.match(/\d+/)[0];
    obj.Content = $("#" + textId).html();

    $.ajax({
        type: "POST",
        url: "/Client/ajax/DataHelper.aspx/SaveEntity",
        data: JSON.stringify(obj),
        async: false,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (r) {
            //alert(r.d);
        }
    });
}

// Ajax for marking entity
function MarkEntity(entityId, textId, sentenceId, subcategoryId, text) {
    var obj = {};
    obj.EntityId = entityId != null ? entityId.match(/\d+/)[0] : null;
    obj.ExampleId = textId.match(/\d+/)[0];
    obj.SentenceId = sentenceId != null ? sentenceId.match(/\d+/)[0] : null;
    obj.SubcategoryId = subcategoryId != null ? subcategoryId.match(/\d+/)[0] : null;
    obj.InputText = text;
    obj.isChecked = $("#rb_" + subcategoryId).length > 0 ? $("#rb_" + subcategoryId).is(":checked") : $("#rbv_" + subcategoryId).is(":checked");
    //if (already_marked == true)
    //    obj.isChecked = false;

    var return_this = true;
    $.ajax({
        type: "POST",
        url: "/Client/ajax/DataHelper.aspx/MarkEntity",
        data: JSON.stringify(obj),
        async: false,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (r) {
            return_this = r.d;
        }
    });
    return return_this;
}

function HandleEnterClick() {
    if ($(".current") != null && $(".current") != undefined) {
        if ($(".current").attr("id") != undefined) {
            var id = $(".current").attr("id").split("_")[1];
            ChangeStatus($("#btn_" + id));
        }
    }
}

function ChangeStatus(handle) {
    var eId = $(handle).attr("id").split("_")[1];
    var text = $(handle).val();
    var new_status = 0;

    if (text == "☐") {
        //status = 3; nije završeno -> novi status je završeno
        new_status = 2;
    }
    else if (text == "✔") {
        //status = 2; završeno je -> novi status je nezavršeno
        new_status = 3;
    }

    if (text == "" || new_status == 0)
        return;

    var finished = parseInt($("#finished").text());
    var unfinished = parseInt($("#unfinished").text());

    var obj = {};
    obj.ExampleId = eId;
    obj.StatusId = new_status;
    $.ajax({
        type: "POST",
        url: "/Client/ajax/DataHelper.aspx/ChangeStatus",
        data: JSON.stringify(obj),
        async: false,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (r) {
            if (r.d == true) {
                if (new_status == 3) {
                    $(handle).val("☐");
                    $("#finished").text(finished - 1);
                    $("#unfinished").text(unfinished + 1);
                }
                else if (new_status == 2) {
                    $(handle).val("✔");
                    $("#finished").text(finished + 1);
                    $("#unfinished").text(unfinished - 1);
                }
            }
        }
    });
}