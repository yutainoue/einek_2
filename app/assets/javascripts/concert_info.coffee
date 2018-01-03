$(document).on 'change', '#q_hall_prefecture_number_eq', ->
  $.ajax(
    type: 'GET'
    url: '/concert_infos/hall_names'
    data: {
      prefecture_id: $(this).val()
    }
  ).done (data) ->
    $('.hall-area').html(data)
    $(".chosen-select").chosen(
      no_results_text: '一致するものがありません:'
    )

$ ->
  $(".chosen-select").chosen(
    no_results_text: '一致するものがありません:'
  )
