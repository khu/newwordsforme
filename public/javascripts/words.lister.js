
    var eventCode = -1;
    var current_word_number = 1;
    var total_words = 0;
    var clickedWords = new Array;
    var has_fetched_words = false;
    var current_tab_name = "all";
    $(function() {
        $('input#word_submit').live("click", function() {
            var word = $('textarea#word_word').val();
            if (word == '') {
                $('textarea#word_word').animate({backgroundColor:'#ffc'}, 150, function() {
                    $('textarea#word_word').animate({backgroundColor :'#F3F1E5'}, 150, function() {
                        $('textarea#word_word').animate({backgroundColor :'#ffc'}, 150, function() {
                            $('textarea#word_word').animate({backgroundColor :'#F3F1E5'}, 150)
                        })
                    })
                })
            } else {
                $('textarea#word_word').attr("disabled", "true");
                $('input#word_submit').attr("disabled", "true");
                add_word_via_ajax(word, user_id);
            }
        });

        $('textarea#word_word').focus();

        $("#play-button").live("click", function() {
            switchPlayAndStop();

        });
        $('.sponsorFlip').live("click", function() {

            var elem = $(this);

            if (elem.data('flipped')) {
                elem.revertFlip();
                elem.data('flipped', false);
            } else {
                var word_id = elem.attr('word_id');
                elem.flip({
                    direction:'lr',
                    speed: 350,
                    onBefore: function() {
                        elem.html(elem.siblings('.sponsorData').html());
                    },
                    onEnd:function() {
                    }
                });
                elem.data('flipped', true);
            }
        });

        $('.sponsor .starred').live("click", function() {
            var word_id = $(this).parents(".sponsorFlip").attr("word_id");
            if ($(this).css("background-position") == "0px 0px") {
                $(this).css({
                    "background-position": "0 100%"
                });
                add_tag_via_ajax(word_id, "starred");
            } else {
                $(this).css({
                    "background-position": "0 0"
                });
                delete_tag_via_ajax(word_id, "starred");
            }
            return false;
        })
        $('.sponsor .important').live("click", function() {
            var word_id = $(this).parents(".sponsorFlip").attr("word_id");
            if ($(this).css("background-position") == "0px 0px") {
                $(this).css({
                    "background-position": "0 95%"
                });
                add_tag_via_ajax(word_id, "important");
            } else {
                $(this).css({
                    "background-position": "0 0"
                });
                delete_tag_via_ajax(word_id, "important");
            }
            return false;
        })

        addListenerForTab();
        addListenerForSlider();
    })

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
            openCards();
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

    function openCards() {
        $("#cards-container").animate({
            "opacity":"hide"
        }, 600, function() {
            $("#slides").css({
                display:"none"
            });
            has_fetched_words = false;
            ajax_get_words();
//            setTimeout("ajax_get_words();", 2000);
            $("#featured-box").show("scale", {}, 1000, function() {
                if (!has_fetched_words) {
                    $(".words-loading-img").fadeIn();
                }
            });
        });
    }

    function playCards() {
        $(".words-loading-img").fadeOut("slow", function() {
            $("#slides").css({
                display:""
            });
            $(".slider-nav").css({
                display:""
            });
            activeSlide();
        });

    }

    function stopCards() {

//        $(".slider-nav").fadeOut();
//        $(".slides_container").fadeOut("slow", function() {

            $("#featured-box").hide("scale", {}, 800, function() {
                $("#cards-container").animate({
                    "opacity": "show"
                }, 500);
            });
//        });

    }

    function ajax_get_words() {
        has_fetched_words = false;
        $.ajax({
            url: "/users/" + user_id + "/tag/" + current_tab_name,
            type: "POST",
            dataType: "json",
            success :function(data) {
                $(".slides_container").empty();
                $.each(data, function(i, word) {
                    has_fetched_words = true;
                    total_words++;
                    var div_string = '<div class="slide"><div class="word" id="word' + word.word.id + '"><div class="content">' + word.word.word
                            + '</div></div><div class="slide_back"><div class="content">' + word.word.translation + '</div></div></div>';
                    $(".slides_container").append(div_string);

                });

                playCards();

            },
            error: function() {
                window.log("error");
            }
        });
    }

    function activeSlide() {
        if ($('.slide').length > 0) {
            $('.slides_container').css("display", "block");
        }
        $('#slides').slides({
            preload: true,
            preloadImage: '/stylesheets/img/slide_images/loading.gif',
            play: 0,
            pause: 2500,
            hoverPause: true ,
            generatePagination: false
        });
        // addListenerForSlider();
    }

    function addListenerForTab() {
        $("#all-tab").live("click", function() {
            current_tab_name = "all";
            $.get("/users/" + user_id + "/tag/all", null, null, "script");
            return false;
        });
        $("#starred-tab").live("click", function() {
            current_tab_name = "starred";
            $.get("/users/" + user_id + "/tag/starred", null, null, "script");
            return false;
        });
        $("#important-tab").live("click", function() {
            current_tab_name = "important";
            $.get("/users/" + user_id + "/tag/important", null, null, "script");
            return false;
        });
        $(".words-stream-tab").click(function() {
            $(this).addClass("active");
            $(this).siblings().removeClass("active");
        });
    }

    function addListenerForSlider() {

        $('.word').live("click", function() {
            var elem = $(this);
            var word_id = elem.attr('id').replace(/[^\d]/g, '');
            clickedWords.push(word_id);
            update_tag_via_ajax(word_id, "familiar", "unfamiliar");
            if (elem.data('flipped')) {
                elem.revertFlip();
                elem.data('flipped', false);
            } else {
                elem.flip({
                    direction: 'tb',
                    color:'#F3F1E5',
                    speed:350,
                    onBefore:function() {
                        elem.html(elem.siblings('.slide_back').html());
                    },
                    onEnd: function() {
                    },
                    onAnimation:function() {
                        elem.css("background-color", "#663300");
                    }
                });
                elem.data('flipped', true);
            }
        });
        $(document).keydown(function(event) {
            if (eventCode < 0)
                eventCode = event.which;
            else
                return;
            operateKeyCode();
        });
        $(".prev").live('click', function() {
            if (--current_word_number <= 0)
                current_word_number = total_words;
            $('#current_word').html(current_word_number);
        });
        $(".prev").live("mousedown", function() {
            var word_id = $('.slides_control > div:visible div[id]').attr('id').replace(/[^\d]/g, '');
            if (jQuery.inArray(word_id, clickedWords) < 0) {
                update_tag_via_ajax(word_id, "unfamiliar", "familiar");
            }
        });
        $(".next").live('click', function() {
            if (++current_word_number > total_words)
                current_word_number = 1;
            $('#current_word').html(current_word_number);
        });
        $(".next").live("mousedown", function() {
            var word_id = $('.slides_control > div:visible div[id]').attr('id').replace(/[^\d]/g, '');
            if (jQuery.inArray(word_id, clickedWords) < 0) {
                update_tag_via_ajax(word_id, "unfamiliar", "familiar");
            }
        });

        /***    for bottom navigation
         $(".bottom_back > a").live("mousedown", function() {
         if (total_words == 1 && clickedWords.length == 0) {
         var word_id = $('.slides_control > div:visible div[id]').attr('id').replace(/[^\d]/g, '');
         update_tag_via_ajax(word_id, "unfamiliar", "familiar");
         } else if (current_word_number == total_words) {
         var word_id = $('.slides_control > div:visible div[id]').attr('id').replace(/[^\d]/g, '');
         if (clickedWords.indexOf(word_id) < 0)
         update_tag_via_ajax(word_id, "unfamiliar", "familiar");
         }
         });
         ***/

    }

    function operateKeyCode() {
        switch (eventCode) {
            case 37 :
                $(".prev").trigger("mousedown");
                $(".prev").trigger("click");
                break;
            case 39 :
                $(".next").trigger("mousedown");
                $(".next").trigger("click");
                break;
            default:
                break;
        }
        setTimeout("resetEventCode()", 1000);
    }

    function resetEventCode() {
        eventCode = -1;
    }

    function update_tag_via_ajax(word_id, oldTag, newTag) {
        $.ajax({
            url: "/words/update_tag",
            type: "POST",
            data: {"word": {"word_id" : word_id,"oldTag": oldTag, "newTag": newTag}},
            dataType: "json",
            success :function(data) {

            },
            error: function() {
            }
        });
    }

    function add_tag_via_ajax(word_id, tag) {
        $.ajax({
            url: "/words/add_tag",
            type: "POST",
            data: {"word": {"word_id" : word_id,"tag": tag}},
            dataType: "json",
            success :function(data) {

            },
            error: function() {
            }
        });
    }

    function delete_tag_via_ajax(word_id, tag) {
        $.ajax({
            url: "/words/delete_tag",
            type: "POST",
            data: {"word": {"word_id" : word_id,"tag": tag}},
            dataType: "json",
            success :function(data) {

            },
            error: function() {
            }
        });
    }

    function add_word_via_ajax(word, user_id) {
        $.ajax({
            url: "/users/" + user_id + "/words",
            type: "POST",
            data: {"word": {"word":word}, "user_id": user_id},
            dataType: "json",
            success :function(data) {
                $('#all-tab').click();
                $('textarea#word_word').val('');
                $('.add_word_success_info').show();
                setTimeout(function() {
                    $('.add_word_success_info').hide(0, function() {
                        $('textarea#word_word').attr("disabled", "");
                        $('input#word_submit').attr("disabled", "");
                        $('textarea#word_word').focus();
                    });
                }, 1000);
            },
            error: function() {
                $('textarea#word_word').attr("disabled", "");
                $('input#word_submit').attr("disabled", "");
            }
        });
    }
