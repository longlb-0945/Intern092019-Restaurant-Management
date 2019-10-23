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
  total_amount = $('#order-total-amount').text();
  if(Number(total_amount) <= 0){
    alert("You don't have any product!");
    return;
  }
  let id = $('.btn_pay').attr('data-id');
  update_status(id, 3);
});

