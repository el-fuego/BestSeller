$ ->
  options = $('[name=model_id]')
  .children()
  .hide()
  $('[name=manufacturer_id]').change (e)->
    options.hide()
    .filter("[manufacturer_id=#{$(e.target).val()}],[value=0]")
    .show()
  .change()