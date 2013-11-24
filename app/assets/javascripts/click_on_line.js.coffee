$ ->
  # переход с учетом нажатия ctrl
  redirectTo = (e, url)->
    if e.ctrlKey || e.shiftKey
      window.open url
    else
      document.location.href = url

  # переходим по ссылке в названии при клике на строку в списке товаров или пользователей
  $('.items>div').click (e)->
    redirectTo e, $(@).find('>.name a').attr('href')
  $('.items>div>.name a, .items>div>a>img').click (e)->
    e.stopPropagation()
