#= require zepto

detectAltHeader = ->
  header = $('.js-header')
  triggerPosition = 400
  scrollPosition = $(window).scrollTop()

  header.toggleClass('header--alt', scrollPosition >= triggerPosition)


rwdNav = (event) ->
  event.preventDefault()
  nav = $('.js-nav-main')

  $(nav).toggleClass('nav--main--rwd')


smoothScroll.init({offset: 116})

$(window).on 'scroll', detectAltHeader
$('.js-nav-main-rwd-navicon').on 'click', rwdNav
