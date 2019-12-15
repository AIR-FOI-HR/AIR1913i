var entity;

function HandleKeyUP(e) {
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
            break;
        case 34:
            // PAGEDOWN
            break;
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
    $('html, body').animate({ scrollTop: offset }, 700);
}

// goes to next span with class entity
// sets current class to next element and removes current class on last element
function NextEntity() {
    if ($(".current").length) {
        var next_element = $(".entity").eq($(".entity").index($(".current")) + 1);
        $(".current").removeClass("current");
        $(next_element).addClass("current");
        ScrollToElement($(next_element));
    }
    else {
        ScrollToElement($(".entity"));
        $(".entity").first().addClass("current");
    }
    entity = $(".current");
}

// goes to previous span with class entity
// sets current class to previous element and removes current class on last element
function PreviousEntity() {
    if ($(".current").length) {
        var prev_element = $(".entity").eq($(".entity").index($(".current")) - 1);
        $(".current").removeClass("current");
        $(prev_element).addClass("current");
        ScrollToElement($(prev_element));
    }
    else {
        ScrollToElement($(".entity"));
        $(".entity").first().addClass("current");
    }
    entity = $(".current");
}

// sets positive sentiment to the entity
function PositiveSentiment() {
    alert("positive " + $(entity).text() + " ID sentence:" + $(entity).parent()[0].id);
}

// sets negative sentiment to the entity
function NegativeSentiment() {
    alert("negative " + $(entity).text() + " ID sentence:" + $(entity).parent()[0].id);
}

// sets neutral sentiment to the entity
function NeutralSentiment() {
    alert("neutral " + $(entity).text() + " ID sentence:" + $(entity).parent()[0].id);
}