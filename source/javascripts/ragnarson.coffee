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

smoothScroll.init()
stickyHeader.init()
