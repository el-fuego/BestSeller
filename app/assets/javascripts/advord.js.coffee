$ ->

  $modelSelector = $('[name=model_id]')
  options = $modelSelector
  .children().clone()


  $('[name=manufacturer_id]').change (e)->
    $modelSelector.children().remove()
    options.filter("[manufacturer_id=#{$(e.target).val()}],[value=0]")
    .clone()
    .appendTo($modelSelector)

  .change()

  setInterval( ->
    Wix.reportHeightChange $(document).height()
  , 300)