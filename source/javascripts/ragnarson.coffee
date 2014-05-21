altHeader =
  detectAltHeader: ->
    header = document.querySelector('[data-alt-header]')
    scrollPosition = window.scrollY
    triggerPosition = header.getAttribute('data-alt-header')

    if scrollPosition >= triggerPosition
      header.classList.add('header--alt')
    else
      header.classList.remove('header--alt')

  init: ->
    window.onscroll = @detectAltHeader

rwdNav =
  init: ->
    trigger = document.querySelector('[data-rwd-nav]')

    onClick = (event) ->
      navClass = event.target.getAttribute('data-rwd-nav')
      nav = document.querySelector(navClass)

      event.preventDefault()
      nav.classList.toggle('nav--main--rwd')

    trigger.addEventListener('click', onClick)

smoothScroll.init({offset: 116})
altHeader.init()
rwdNav.init()
