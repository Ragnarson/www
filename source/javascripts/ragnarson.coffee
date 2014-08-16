#= require zepto

detectAltHeader = ->
  header = $('[data-alt-header]')
  scrollPosition = $(window).scrollTop()
  triggerPosition = header.attr('data-alt-header')

  header.toggleClass('header--alt', scrollPosition >= triggerPosition)


rwdNav = (event) ->
  event.preventDefault()

  nav = $(event.target).attr('data-rwd-nav')
  $(nav).toggleClass('nav--main--rwd')


smoothScroll.init({offset: 116})

$(window).on 'scroll', detectAltHeader
$('[data-rwd-nav]').on 'click', rwdNav
