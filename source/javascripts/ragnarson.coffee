stickyHeader =
  detectSticky: ->
    header = document.querySelector('[data-sticky]')
    scrollPosition = window.scrollY
    triggerPosition = header.getAttribute('data-sticky')

    if scrollPosition > triggerPosition
      header.classList.add('header--sticky')
    else
      header.classList.remove('header--sticky')

  init: ->
    window.onscroll = @detectSticky

rwdNav =
  init: ->
    trigger = document.querySelector('[data-rwd-nav]')

    onClick = (event) ->
      navClass = event.target.getAttribute('data-rwd-nav')
      nav = document.querySelector(navClass)

      event.preventDefault()
      nav.classList.toggle('nav--main--rwd')

    trigger.addEventListener('click', onClick)

smoothScroll.init()
stickyHeader.init()
rwdNav.init()
