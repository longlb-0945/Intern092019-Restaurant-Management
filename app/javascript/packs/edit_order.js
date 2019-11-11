function update_status(id, action){
  $.ajax({
    url: '/admin/orders/' + id + '/order_status',
    data: {status_update: action}
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
