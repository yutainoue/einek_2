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

# chosenのオプションでpleaseholderが表示できなかったので、こちらで追加している
$(document).on 'click', '.aaa', ->
  $('#a-modal').modal 'show'
  $('#q_hall_prefecture_number_eq_chosen > div > div > input[type="text"]').attr('placeholder','名前を入力して検索')
  $('#q_hall_number_eq_chosen > div > div > input[type="text"]').attr('placeholder','名前を入力して検索')

$(document).on 'click', '.bbb', ->
  $('#b-modal').modal 'show'

# affixがスムーズに動いて見えるように、スクロール位置によってCSSを追加している
jQuery ->
  jQuery(window).scroll ->
    obj_t_pos = jQuery('#scroll_target').offset().top
    scr_count = jQuery(document).scrollTop()
    if scr_count > obj_t_pos
      $('#concert_info_tbody').addClass 'tbody_margin'
      $('#affix_target').addClass 'affix'
      $('#affix_target').removeClass 'affix_top'
    else
      $('#concert_info_tbody').removeClass 'tbody_margin'
      $('#affix_target').removeClass 'affix'
      $('#affix_target').addClass 'affix_top'
