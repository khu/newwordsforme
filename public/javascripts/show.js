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

    function switchPlayAndStop(){

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

})