/**
 * Created by JetBrains RubyMine.
 * User: twer
 * Date: 8/16/11
 * Time: 5:39 PM
 * To change this template use File | Settings | File Templates.
 */


$(function() {


    $("#play-button").click(function() {
        switchPlayAndStop();
    });
    $('.sponsorFlip').live("click", function() {

        var elem = $(this);

        if (elem.data('flipped')) {
            elem.revertFlip();
            elem.data('flipped', false)
        } else {
            var word_id = elem.attr('word_id');
            elem.flip({
                direction:'lr',
                speed: 350,
                onBefore: function() {
                    elem.html(elem.siblings('.sponsorData').html());
                },
                onEnd: function() {
                }
            });
            elem.data('flipped', true);
        }
    });
    function switchPlayAndStop() {

        if ($("#play-image").css("display") == "none") {

            $("#play-image").css({
                display:""
            });
            $("#stop-image").css({
                display:"none"
            });
        } else {
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

})