$('document').ready(function(){
  $('.dropdown-toggle').on('mouseenter', function () {
    if (!$(this).parent().hasClass('show')) {
        $(this).click();
    }
  });

  $('.btn-group, .dropdown').on('mouseleave', function () {
    if ($(this).hasClass('show')){
      $(this).children('.dropdown-toggle').first().click();
    }
  });

  $('#order-table-select').select2({
    placeholder: I18n.t("pick_table_placeholder")
  });
});

window.showModal = function(table_id){
  $.ajax({
    url: 'tables/' + table_id
  });
}
