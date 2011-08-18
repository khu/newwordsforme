/**
 * Created by JetBrains RubyMine.
 * User: twer
 * Date: 8/16/11
 * Time: 5:39 PM
 * To change this template use File | Settings | File Templates.
 */


$(function() {

    $("#play-button").live("click", function() {

        ajax_get_words();
        switchPlayAndStop();
    });
    $('.sponsorFlip').live("click", function() {

        var elem = $(this);

//        alert(elem.offset().top + "," + elem.height());

        if (elem.data('flipped')) {
            elem.revertFlip();
            elem.data('flipped', false);
//            elem.addClass("box-shadow");
        } else {
            var word_id = elem.attr('word_id');
            elem.flip({
                direction:'lr',
                speed: 350,
                onBefore: function() {
                    elem.html(elem.siblings('.sponsorData').html());
                },
                onEnd:function() {
//                    elem.addClass("box-shadow");
                }
            });
            elem.data('flipped', true);
        }
    });

    function switchPlayAndStop() {

        if ($("#play-image").css("display") == "none") {
            stopCards();
            $("#play-image").css({
                display:""
            });
            $("#stop-image").css({
                display:"none"
            });
        } else {
            playCards();
            $("#play-image").css({
                display:"none"
            });
            $("#stop-image").css({
                display:""
            });
        }
    }

    function highlight(element) {
        $(element).addClass("highlight");
        window.setTimeout(function() {
            $(element).removeClass('highlight');
        }, 1000);
    }

    function playCards() {
        $("#cards-container").animate({
            "opacity":"hide"
        }, 600, function() {
            $("#featured-box").show("scale", {}, 1000);
        });
    }

    function stopCards() {
        $("#featured-box").hide("scale", {}, 800, function() {
            $("#cards-container").animate({
                "opacity": "show"
            }, 500);
        });
    }

    function ajax_get_words() {

        $.ajax({
            url: "/users/" + '<%= @user.id %>' + "/tag/all",
            type: "POST",
            dataType: "json",
            success :function(data) {
                alert(date.toString());
            },
            error: function() {
                window.log("error");
            }
        });
    }

})