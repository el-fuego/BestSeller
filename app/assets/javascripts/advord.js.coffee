$ ->
  options = $('[name=model_id]')
  .children()
  .hide()
  $('[name=manufacturer_id]').change (e)->
    options.hide()
    .filter("[manufacturer_id=#{$(e.target).val()}],[value=0]")
    .show()

    # unselect if hidden is selected
    selected = options.filter(":selected")
    if !options.is(":visible")
      selected.removeAttr 'selected'
      options.filter('[value=0]').attr 'selected', 'selected'
  .change()