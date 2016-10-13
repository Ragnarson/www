#= require zepto
#= require zeptotouch

toggleRwdMainNav = (event) ->
  event.stopPropagation()
  $('.js-nav-main').toggleClass('nav-main-rwd')
  $(document).on 'click', toggleRwdMainNav

toggleActiveCard = ->
  $(@).toggleClass('.js-card-active')

$('.js-nav-main-rwd-navicon').on 'click', toggleRwdMainNav
$('.js-card').on 'tap', toggleActiveCard
