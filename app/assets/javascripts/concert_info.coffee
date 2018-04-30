$(document).on 'change', '#q_hall_prefecture_number_eq', ->
  $.ajax(
    type: 'GET'
    url: '/concert_infos/hall_names'
    data: {
      prefecture_id: $(this).val()
    }
  ).done (data) ->
    $('.hall_names').html(data)
    $('.chosen-select').chosen(
      no_results_text: '一致するものがありません:'
      search_contains: true
      width: 100
    )

$ ->
  $('.chosen-select').chosen(
    no_results_text: '一致するものがありません:'
    search_contains: true
    width: 100
  )
