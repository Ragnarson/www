#= require zepto
#= require zepto-touch

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

toggleActiveCard = ->
  $(@).toggleClass('.js-card-active')

$(window).on 'scroll', breakpoint: 400, toggleAltHeader
$(window).on 'scroll', offset: 117, scrollSpy
$(document).on 'ready', initScrollSpy
$('.js-nav-main-rwd-navicon').on 'click', toggleRwdMainNav
$('.js-smooth-scroll').on 'click', {offset: 116, duration: 300}, scrollToSection
$('.js-card').on 'tap', toggleActiveCard

errors = {}

validateLength = (field) ->
  errorMsg = "can't be blank"
  if field.val().trim().length == 0
    field.addClass('invalid')
         .attr('placeholder', errorMsg)
    errors[field.attr('id')] = errorMsg
  else
    field.removeClass('invalid')
    delete errors[field.attr('id')]

validateFormat = (input) ->
  format = /\S+@\S+/
  unless input.val().match(format)
    input.addClass('invalid')
    errors['email address'] = "doesn't seem to be correct"
  else
    input.removeClass('invalid')
    delete errors['email address']

validateForm = (input) ->
  errors = {}
  validateLength($('#name'))
  validateFormat(input)
  validateLength($('#message'))

flashAfterSubmit = ->
  if Object.keys(errors).length == 0
    alert 'OK!'
  else
    errorList =
      for e in Object.keys(errors)
        '\n - ' + e + ' ' + errors[e]
    alert 'Sorry! There were some errors with your form:' + errorList

$('.js-newsletter-email').on 'keyup', ->
  validateFormat($(this))

$('.js-newsletter-form').on 'submit', ->
  errors ={}
  validateFormat($(this).find('#email'))
  flashAfterSubmit()

$('.js-contact-name').on 'keyup', ->
  validateLength($(this))

$('.js-contact-email').on 'keyup', ->
  validateFormat($(this))

$('.js-contact-message').on 'keyup', ->
  validateLength($(this))

$('.js-contact-form').on 'submit', ->
  validateForm($(this).find('#email'))
  flashAfterSubmit()
