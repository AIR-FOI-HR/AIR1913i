function Validation() {
    var username = $("#txtUsername").val();
    var password = $("#txtPassword").val();
    var confirmed_pass = $("#txtConfirmedPassword").val();
    var name = $("#txtFirstName").val();
    var surname = $("#txtLastName").val();
    var email = $("#txtMail").val();

    var errors = ValidateMailAndPassword(email, username, password, confirmed_pass)

    if (username.length <= 5) {
        errors.push({ code: "000", message: "Unesite korisničko ime (više od 5 znakova)" });
    }

    if (name.length == 0) {
        errors.push({ code: "030", message: "Unesite ime" });
    }

    if (surname.length == 0) {
        errors.push({ code: "040", message: "Unesite prezime" });
    }

    if (errors.length > 0) {
        ShowErrors(errors);
        return false;
    }
    else
        return true;
}

function ValidateMailAndPassword(mail, username, pass, conf_pass) {
    var errors = [];
    ValidateEmailAndUsername(mail, username, errors);
    ValidatePassword(pass, conf_pass, errors);
    return errors;
}

function validate_regex_mail(email) {
    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(String(email).toLowerCase());
}

function ValidateEmailAndUsername(email, username, errors) {
    ValidateEmail(email, errors);

    var obj = {};
    obj.username = $.trim(username);
    obj.mail = $.trim(email);
    $.ajax({
        type: "POST",
        url: "/Client/ajax/ValidateLogin.aspx/CheckParameters",
        data: JSON.stringify(obj),
        async: false,

        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (r) {
            if (r.d == true)
                errors.push({ code: "012", message: "E-mail ili korisničko ime već postoje" });
        }
    });
}

function ValidateEmail(email, errors) {
    if (email.length > 0) {
        if (!validate_regex_mail(email)) {
            errors.push({ code: "010", message: "Neispravan e-mail" });
        }
    }
    else {
        errors.push({ code: "011", message: "Unesite e-mail" });
    }
}

function ValidatePassword(pass, conf_pass, errors) {
    var lower = /[a-z]/g;
    if (!pass.match(lower)) {
        errors.push({ code: "020", message: "Lozinka - Nemate malih slova" });
    }

    var upper = /[A-Z]/g;
    if (!pass.match(upper)) {
        errors.push({ code: "021", message: "Lozinka - Nemate kapitaliziranih slova" });
    }

    var number = /[0-9]/g;
    if (!pass.match(number)) {
        errors.push({ code: "022", message: "Lozinka - Nemate brojeva" });
    }

    if (pass.length < 8) {
        errors.push({ code: "023", message: "Lozinka - Prekratka" });
    }

    if (pass != conf_pass) {
        errors.push({ code: "024", message: "Lozinka i potvrđena lozinka nisu identične" });
    }

    return errors;
}

function ShowErrors(errors) {
    var e = "";
    for (i = 0; i < errors.length; i++) 
        e += errors[i].code + " - " + errors[i].message + "<br>";
    
    $("#ListOfErrors").html(e);
    $(".error_container").show();
}