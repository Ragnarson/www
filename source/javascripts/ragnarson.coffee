#= require zepto

toggleAltHeader = (event) ->
  windowScrollTop = $(window).scrollTop()
  $('.js-header').toggleClass('header--alt', windowScrollTop >= event.data.breakpoint)

toggleRwdMainNav = (event) ->
  event.preventDefault()
  $('.js-nav-main').toggleClass('nav--main--rwd')

smoothScroll.init({offset: 116})

$(window).on 'scroll', breakpoint: 400, toggleAltHeader
$('.js-nav-main-rwd-navicon').on 'click', toggleRwdMainNav
