$ ->
  # переход с учетом нажатия ctrl
  redirectTo = (e, url, isNewWindow)->
    if e.ctrlKey || e.shiftKey || isNewWindow
      window.open url
    else
      document.location.href = url

  # переходим по ссылке в названии при клике на строку в списке товаров или пользователей
  $('.items>div').click (e)->
    $el = $(@).find('>.name a')
    redirectTo e, $el.attr('href'), $el.attr('target') == '_blank'
  $('.items>div>.name a, .items>div>a>img').click (e)->
    e.stopPropagation()
