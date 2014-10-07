#= require zepto

toggleAltHeader = (event) ->
  windowScrollTop = $(window).scrollTop()
  $('.js-header').toggleClass('header-alt', windowScrollTop >= event.data.breakpoint)

toggleRwdMainNav = (event) ->
  event.preventDefault()
  event.stopPropagation()
  $('.js-nav-main').toggleClass('nav-main-rwd')
  $(document).on 'click', toggleRwdMainNav

scrollToSection = (event) ->
  event.preventDefault()

  smoothScroll = (el, to, duration) ->
    difference = to - $(window).scrollTop()
    perTick = difference / duration * 10
    @scrollToTimerCache = setTimeout(( ->
      unless isNaN(parseInt(perTick, 10))
        window.scrollTo 0, $(window).scrollTop() + perTick
        smoothScroll(el, to, duration - 10)
    ).bind(@), 10)

  target = $(event.target).attr("href")
  offset = $(target).offset().top + event.data.offset
  smoothScroll($(window), offset, event.data.duration)

$(window).on 'scroll', breakpoint: 400, toggleAltHeader
$('.js-nav-main-rwd-navicon').on 'click', toggleRwdMainNav
$('.js-smooth-scroll').on 'click', {offset: -116, duration: 300}, scrollToSection

navMenuHeight = undefined
sections = undefined
navMenu = undefined

setSections = () ->
  navMenu = $('.js-nav-main')
  navMenuHeight = navMenu.height()
  sections = []
  $navbarlinks = navMenu.find('a')
  $navbarlinks.map( ->
    item = ($($(this).attr('href')))
    sections.push item
  )

scrollSpy = () ->
  id = null
  fromTop = $(this).scrollTop() + navMenuHeight * 3

  for section in sections
    if fromTop > section.offset().top
      scrolled_id = section.attr('id')
  if scrolled_id != id
    id = scrolled_id
    $('a', navMenu).removeClass('current')
    $('a[href="#' + id + '"]', navMenu).addClass('current')
    console.log 'menu change' + id

$(document).ready ->
  setSections()
$(window).scroll ->
  scrollSpy()
