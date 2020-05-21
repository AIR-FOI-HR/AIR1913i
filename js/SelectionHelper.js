var entity;

function HandleKeyDOWN(e) {
    switch (e.which) {
        case 13:
            // ENTER for next entity
            NextEntity();
            break;
        case 8:
            // BACKSPACE for previous entity
            PreviousEntity();
            break;
        case 107:
        case 187:
            // PLUS and PLUS on numpad
            PositiveSentiment();
            break;
        case 109:
        case 189:
            // MINUS and MINUS on numpad
            NegativeSentiment();
            break;
        case 48:
        case 96:
            // ZERO and ZERO on numpad
            NeutralSentiment();
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
    }
}

function JumpToExample(next) {
    var id;
    if (next == true) {
        var next_child = $(".current").parent().parent().parent().next().children("div");
        if (next_child.length > 0) {
            $([document.documentElement, document.body]).animate({
                scrollTop: next_child.offset().top
            }, 2000);
            id = $(".current").parent().parent().parent().next().children("div")[2].id;
        }
    }
    else {
        var prev_child = $(".current").parent().parent().parent().prev().children("div");
        if (prev_child.length > 0) {
            $([document.documentElement, document.body]).animate({
                scrollTop: prev_child.offset().top
            }, 2000);
            id = $(".current").parent().parent().parent().prev().children("div")[2].id;
        }
    }

    var _e = $("#" + id).find(".entity");
    if (_e.length > 0) {
        // remove current after finding next element
        $(".current").removeClass("current");
        // get new current element and assign it
        var first_entity_id = _e[0].id;
        var first_child = $("#" + id).children()[0].id;
        $("#" + id + " #" + first_child + " #" + first_entity_id).addClass("current");
    }
}

// Scrolls to selected (el) element
// Update is needed (runs slow if smashing enter or backspace)
function ScrollToElement(el) {
    var elOffset = el.offset().top;
    var elHeight = el.height();
    var windowHeight = $(window).height();
    var offset;

    if (elHeight < windowHeight) {
        offset = elOffset - ((windowHeight / 2) - (elHeight / 2));
    }
    else {
        offset = elOffset;
    }
    //$('html, body').animate({ scrollTop: offset }, 700);
    $('html, body').scrollTop(offset);
}

// goes to next span with class entity
// sets current class to next element and removes current class on last element
function NextEntity() {
    if ($(".current").length) {
        var next_element = $(".entity").eq($(".entity").index($(".current")) + 1);
        var wi = 1;
        while(next_element.parent().parent().parent().css("display") == "none") {
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

    // prikaz info-a
    $("#Category_E" + id).show();
    $("#current_example").show();
    $("#current_subcategory").show();
    $("#current_example").html("<div>Primjer ID: " + id + "</div><div>Riječ: " + $(".current").text() + "</div>");
    UpdateSubcategory();
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
    var subcategory_id = $(".current").attr("data-subcategory");
    var name = $("#cat_" + subcategory_id).clone().children().remove().end().text();
    name = name == "" ? "/" : name;
    $("#current_subcategory").html("<div>Subkategorija: " + name + "</div>");
}

function MarkHandle(sentiment) {
    var parent = $(entity).parent()[0];
    $("#Category_E" + parent.parentElement.id.match(/\d+/)[0] + " .category").each(function (e) {
        if ($(this).data("sentiment") == sentiment) {
            var entityId = $(entity).attr('id');
            var textId = $(entity).parent()[0].parentElement.id;
            var sentenceId = $(entity).parent()[0].id;
            var subcategoryId = $(this).attr('id');
            ColorEntity(entityId, textId, sentenceId, subcategoryId);
            MarkEntity(entityId, textId, sentenceId, subcategoryId);
        }
    });
}

function ColorEntity(entityId, textId, sentenceId, subcategoryId) {
    var color = GetSubcategoryColor(subcategoryId);
    $("#" + textId + " #" + sentenceId + " #" + entityId).attr("data-subcategory", subcategoryId.match(/\d+/)[0]);
    $("#" + textId + " #" + sentenceId + " #" + entityId).css("background-color", color);
}

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
                //var t = $("#" + textId + " #" + sentenceId).html().replace('<span id="' + target.id + '" class="entity">' + word + '</span>', word);
                //$("#" + textId + " #" + sentenceId).html(t);
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

function MarkEntity(entityId, textId, sentenceId, subcategoryId) {
    var obj = {};
    obj.EntityId = entityId.match(/\d+/)[0];
    obj.ExampleId = textId.match(/\d+/)[0];
    obj.SentenceId = sentenceId.match(/\d+/)[0];
    obj.SubcategoryId = subcategoryId.match(/\d+/)[0];

    $.ajax({
        type: "POST",
        url: "/Client/ajax/DataHelper.aspx/MarkEntity",
        data: JSON.stringify(obj),
        async: false,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (r) {
            //alert(r.d);
        }
    });
}