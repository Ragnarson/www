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
  offset = $(target).offset().top - event.data.offset
  smoothScroll($(window), offset, event.data.duration)

initScrollSpy = ->
  document.sections = []
  $('.js-nav-main').find('a').each ->
    document.sections.push $(@).attr('href')

scrollSpy = ->
  scrollPosition = $(window).scrollTop() + event.data.offset
  for section in document.sections
    if scrollPosition >= $(section).offset().top
      activeSection = $(section).attr('id')

  navMain = $('.js-nav-main')
  navMain.find('a').removeClass('active')
  navMain.find("a[href='##{activeSection}']").addClass('active')

contactForm = ->
  form = $('.js-contact-form')
  form.submit (event) ->
    form = $(@)
    $.ajax
      type: form.attr("method")
      url: form.attr("action")
      dataType: 'json'
      data: form.serialize()
      succes: (data) ->
        alert "ok"
    event.preventDefault()

$(window).on 'scroll', breakpoint: 400, toggleAltHeader
$(window).on 'scroll', offset: 117, scrollSpy
$(document).on 'ready', initScrollSpy
$(document).on 'ready', contactForm
$('.js-nav-main-rwd-navicon').on 'click', toggleRwdMainNav
$('.js-smooth-scroll').on 'click', {offset: 116, duration: 300}, scrollToSection
