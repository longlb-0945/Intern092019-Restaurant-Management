function update_status(id, action){
  $.ajax({
    url: '/orders/' + id + '/order_status',
    data: {do_what: action}
  });
}
$('#edit-order-btn-cancel').on('click', function(){
  let id = $('#edit-order-btn-cancel').attr('data-id');
  update_status(id, 2);
});

$('#edit-order-btn-accept').on('click', function(){
  let id = $('#edit-order-btn-accept').attr('data-id');
  update_status(id, 1);
});

$('.btn_pay').on('click', function(){
  let id = $('.btn_pay').attr('data-id');
  update_status(id, 3);
});
