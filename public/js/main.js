
$(document).ready(function(e) {
    //if ($(window).width() < 992) {
    //    $(".plan-table").hide();
    //   $(".single-plan-header").click(function () {
    //        $(this).next().slideToggle("slow");
    //        $(this).find(".glyphicon").toggleClass("glyphicon-menu-up");
    //        $(this).children(".plan-title").toggleClass("selected-blue");
    //       $(this).children(".plan-price").toggleClass("selected-blue");
    //       $(this).children(".plan-period").toggleClass("selected-blue");
    //        $(this).children(".plan-price").children(".plan-currency").toggleClass("selected-blue");
    //    });
    //};


    // if ($(window).width() < 1366) {
    //     $("#menu a").each(function(event ) {
    //         if ( $('this').attr("href") == '#' ) {
    //             event.preventDefault();
    //         };
    //     });
    // };
    // var linkArray = [94, 98, 99, 103,163,632];
    // var menu = $('.responsive-menu .nav-responsive .menu-top-menu-container .nav.navbar-nav');
    // menu.empty();
    // for (var i = 0; i < linkArray.length; i++) {
    //    $(menu).append('<li id="'+linkArray[i]+'">'+$('.menu-item-'+linkArray[i]).html()+'</li>');
    // }

    $('.menu-btn-responsive').on('click', function(e) {
        e.preventDefault();
    });

    if ($(window).width() <= 1000) {
        $('.menu-item-has-children').on('click', function () {
            $('.menu-item-has-children').not(this).find('.dropdown-menu').css('display', 'none');
        });
    }



    $(".feature-list-dropdown").hide();
    $(".feature-list-header").click(function(){
        $(this).next().slideToggle("slow");
        $(this).find(".glyphicon").toggleClass("glyphicon-menu-up");
    });
    $(".button-arrow").click(function(){
        $(this).parent().slideToggle("slow");
    });

    $(".menu-btn-responsive").click(function(){
        $(".responsive-menu").animate({bottom:"0px"},{ queue: false, duration: 300, easing: 'linear' }).animate({top:"0px"}, { queue: false, duration: 0 });
    });
    $(".menu-btn-responsive-close").click(function(){
        $(".responsive-menu").animate({bottom:"100%"},{ queue: false, duration: 300 }).animate({top: "-100vh"},{ queue: false, duration: 0 });
    });

    $("#menu-footer-menu > li").addClass("col-lg-1-5 col-xs-6 footer-nav-column");
    try {
        $("body #webmenu-small.msddd").msDropDown("");
        $("body #webmenu-big.msddd").msDropDown("");
        $("body #tablet-menu.msdd4").msDropDown("");
        $("body #footer-phones.msdddd").msDropDown("");
        $("body #contact-icon-dropdown.msdd3").msDropDown("");
    } catch(e) {
        alert(e.message);
    }

    $('.numbers-dropdown').on('click', function(e){
        $('body').bind("click", function(e){
            if (!$(e.target).hasClass('selected-item') && !$(e.target).parent().hasClass('selected-item')){
                $('.numbers-list').removeClass('open');
                console.log('test2');
            }else{
                $('.numbers-list').addClass('open');
                console.log('test3');
            }

        })
    });
    $('.numbers-dropdown-contact').on('click', function(e){
        $('#page, footer').bind("click", function(e){
            if (!$(e.target).hasClass('selected-item-contact') && !$(e.target).parent().hasClass('selected-item-contact')){
                $('.numbers-list-contact').removeClass('open');
                console.log('test5');
            }else{
                $('.numbers-list-contact').addClass('open');
                console.log('test6');
            }
        });
    });
    if ($(window).width() < 992) {
        $('#page, footer').bind("click" ,function (e) {
            if ($(e.target).hasClass('dropdown-toggle')) {
                $(e.target).parent().find('.dropdown-menu').toggle();
            };
        });
    };
    $('.numbers-item').each(function(){
        $(this).click(function(){
            let currentNumber = $(this).find('.numbers-item-number').text();
            let currentClassList = $(this).find('.numbers-item-flag').attr("class").substring(17);
            $('.selected-item-flag').removeClass().addClass('selected-item-flag');
            $('.selected-item-flag').addClass(currentClassList);
            $('.selected-item-number').text(currentNumber);
            console.log(currentNumber, 'test333');
            setTimeout('window.location="tel:'+currentNumber.split(' ').join('')+'";', 500);
        });
    });
    $('.numbers-item-contact').each(function(){
        $(this).click(function(){
            var currentNumber = $(this).find('.numbers-item-number').text();
            var currentClassList = $(this).find('.numbers-item-flag').attr("class").substring(17);
            $('.selected-item-contact .selected-item-flag').removeClass().addClass('selected-item-flag');
            $('.selected-item-contact .selected-item-flag').addClass(currentClassList);
            $('.selected-item-contact .selected-item-number').text(currentNumber);
        });
    });



    var tableTrHeight = function(){
        var height = 0;
        $('.price-plan-select li').each(function(){
            if ($(this).outerHeight() > height){
                height = $(this).outerHeight()
            };
        });
        $('.price-plan-select li').each(function(){
            $(this).outerHeight(height)
        });
    };


    if ($(window).width() > 992) {
        tableTrHeight();
    }

    $( window ).resize(function() {
        if ($(window).width() > 992) {
            tableTrHeight();
        }
    });


    $('.scroll').click(function() {
        $('html, body').animate({
            scrollTop: ($('#form-partner').offset().top-70)
        }, 1000);
    });

    $('.your-country select option:nth-child(1)').prop('disabled', true);


    /*calendly widget, show on click in button get Demo (in top menu)*/
    $('.home-signup__demo-link').click(function(e){
        e.preventDefault();
        document.getElementsByClassName('calendly-badge-content')[0].click();
    });

    $('.calendly-badge-widget').css({'opacity' : '0', 'height':'0'})

    // Call widget to save your time - text
    $('.call-widget_header .learn_more').on('click', function() {
        $(this).toggleClass('learn_more--active');
        $('.call-widget_text').toggleClass('call-widget_text--active');
        if ($('.call-widget_text').hasClass('call-widget_text--active')) {
            $(this).find('span').html('less');
        }
        else {
            $(this).find('span').html('more');
        }
    });

    $('.landing-seo__wrapper .landing-seo__more').on('click', function() {
        $(this).toggleClass('landing-seo__more--active');
        $('.landing-seo__text').toggleClass('landing-seo__text--active');
        if ($('.landing-seo__text').hasClass('landing-seo__text--active')) {
            $(this).find('span').html('less');
        }
        else {
            $(this).find('span').html('more');
        }
    });

    $('.landing-seo__text').css('max-height', $('.landing-seo__text').find('p:first-of-type').height() + 'px');

    // Call widget to save your time - slider
    $('.widget_menu-item').on('click', function() {
        $('.call-widget_image').attr('src', $('.call-widget_image').attr('src').slice(0, $('.call-widget_image').attr('src').length - 6) + $(this).attr('data-image') + '.png');
        $('.widget_title').html($(this).children('p').text());
        $('.widget_text').html($(this).attr('data-content'));
        $('.widget_menu-item').removeClass('widget_menu-item--active');
        $(this).addClass('widget_menu-item--active');
    });

    // Pricing - faq
    $('.faq__item').on('click', function() {
       if (!$(this).hasClass('faq__item--apla')) {
           $(this).toggleClass('faq__item--active');
       }
    });

    $('.post-search__form').submit(function(e){
        // check logic here
        if ($('.post-search__input').val() == "") {
            e.preventDefault()
        }
    });

    $('.post-search__button').on('click', function() {
            $('.landing-wrapper--blog .search-field').toggleClass('landing-wrapper--blog search-field--active').focus();
            $(this).toggleClass('post-search__button--active');
    });

    if ($('body').hasClass('search')) {
        $('.landing-wrapper--blog .search-field').toggleClass('landing-wrapper--blog search-field--active').focus();
        $('.post-search__button').toggleClass('post-search__button--active');
    }

    // Free minutes - apla
    $('.faq__item--apla, .countries_open').on('click', function() {
       $('.apla').fadeIn(250);
        $('body').css('overflow', 'hidden');
    });
    $('.apla .close').on('click', function() {
       $('.apla').fadeOut(250);
        $('body').css('overflow', 'auto');
    });
    $('.apla').on('click', function(e) {
        if (e.target === this) {
            $('.apla').fadeOut(250);
            $('body').css('overflow', 'auto');
        }
    });
    $(document).keyup(function(e) {
        if (e.keyCode == 27) {
            $('.apla').fadeOut(250);
            $('body').css('overflow', 'auto');
        }
    });

    $('.anchor').on('click', function(e) {
        e.preventDefault();
        $('html, body').animate({
            scrollTop: $('.cheap_international_calls').offset().top - 100
        }, 500);
    });

    $('.live_chat').on('click', function(e) {
        e.preventDefault();
        var LC = LC_API || {};
        LC.open_chat_window();
    });

    $('.power-dialer_btns .power-dialer_btn').on('click', function() {
        $('.power-dialer_btns .power-dialer_btn').removeClass('power-dialer_btn--active');
        $(this).addClass('power-dialer_btn--active');
        var src = $(this).attr('data-img');
        $('.power-dialer_btns .power-dialer_image').fadeTo('250ms', 0.8, function()
        {
            $('.power-dialer_btns .power-dialer_image').attr('src', src);
        }).fadeTo('250ms', 1);
    });

    $('.power-dialer_item .power-dialer_btn').on('click', function() {
        $('.power-dialer_item').removeClass('power-dialer_item--active');
        $('.power-dialer_item .power-dialer_btn').removeClass('power-dialer_btn--active');
        $(this).addClass('power-dialer_btn--active');
        $(this).parents('.power-dialer_item').addClass('power-dialer_item--active');
    });

    $('.feature-slider .feature-slider__btn').on('click', function() {
        $('.feature-slider .feature-slider__btn').removeClass('feature-slider__btn--active');
        $(this).addClass('feature-slider__btn--active');
        var src = $(this).attr('data-img');
        $('.feature-slider .feature-slider__img').fadeTo('250ms', 0.8, function()
        {
            $('.feature-slider .feature-slider__img').attr('src', src);
        }).fadeTo('250ms', 1);
    });

    $('.footer-menu_title').on('click', function(e) {
        e.preventDefault();
        if ($(window).width() < 768) {
            $(this).parent('.footer-menu_group').children('ul').toggle();
        }
    })

    $('ul.nav li.dropdown').hover(function() {
        $('ul.nav li.dropdown > ul.dropdown-menu').css('display', 'none');
        $(this).children('ul.dropdown-menu').css('display', 'block');
    }, function() {
       $('ul.nav li.dropdown > ul.dropdown-menu').css('display', 'none');
    });
});

var caseNavigation = $('.case-study_navigation').offset().top;

$(window).on('scroll', function() {
    var currentScroll = $(window).scrollTop();
    var stopFixedNavigation = $('.stop-navigation').offset().top;
    var about = $('.case-study_section[data-section="about"]').offset().top;
    var industry = $('.case-study_section[data-section="industry"]').offset().top;
    var painPoints = $('.case-study_section[data-section="pain-points"]').offset().top;
    var solution = $('.case-study_section[data-section="solution"]').offset().top;
    var results = $('.case-study_section[data-section="results"]').offset().top;

    if (currentScroll >= caseNavigation - 140 && currentScroll <= stopFixedNavigation - 140) {
        $('.case-study_navigation').css({
            position: 'fixed',
            marginTop: '150px',
            'transform': 'none'
        });
    }
    else if (currentScroll > stopFixedNavigation - 140) {
        $('.case-study_navigation').css({
            'position' : 'static',
            'margin-top' : '40px',
            'transform': 'translateY(' + (stopFixedNavigation - $('.case-study_header').outerHeight() - 70) + 'px)'
        });
    }
    else {
        $('.case-study_navigation').css({
            position: 'static',
            marginTop: '40px',
            'transform': 'none'
        });
    }

    if (about - currentScroll <= 100) {
        $('.case-study_navigation li').removeClass('case-study_active');
        $('.case-study_navigation li[data-section="about"]').addClass('case-study_active');
    }
    if (industry - currentScroll <= 100) {
        $('.case-study_navigation li').removeClass('case-study_active');
        $('.case-study_navigation li[data-section="industry"]').addClass('case-study_active');
    }
    if (painPoints - currentScroll <= 100) {
        $('.case-study_navigation li').removeClass('case-study_active');
        $('.case-study_navigation li[data-section="pain-points"]').addClass('case-study_active');

    }
    if (solution - currentScroll <= 100) {
        $('.case-study_navigation li').removeClass('case-study_active');
        $('.case-study_navigation li[data-section="solution"]').addClass('case-study_active');

    }
    if (results - currentScroll <= 100) {
        $('.case-study_navigation li').removeClass('case-study_active');
        $('.case-study_navigation li[data-section="results"]').addClass('case-study_active');

    }
});
$('.case-study_navigation li').on('click', function(e) {
    e.preventDefault();
    var target = $(this).attr('data-section');
    $('html, body').animate({
       scrollTop: $('.case-study_section[data-section="' + target + '"]').offset().top - 99
    }, 1000);
});
