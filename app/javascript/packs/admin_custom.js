function readURL(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();

    reader.onload = function (e) {
      $('.preview-img')
        .attr('src', e.target.result)
        .width(250)
        .height(250);
    };

    reader.readAsDataURL(input.files[0]);
  }
}

$('document').ready(function(){
  $(document).on('change', '.upload-img', function(){
    readURL(this);
  });

  $(document).on('change', '.sort-select', function() {
    this.form.submit();
  });

  $(document).on('change', '.order-detail-change-quantily', function(){
    let data = $(this).data('id').split('-');
    update_amount(data[0], data[1]);
  });

  // prevent order is empty
  $(document).on('submit', '#order-paid-form', function(){
    total_amount = $('#order-total-amount').text();
    if(Number(total_amount) <= 0){
      alert("You don't have any product!");
      return false;
    }
  });

  setInterval(function(){
    $('.alert').remove();
  }, 2000);
});

function update_amount(order_id, order_detail_id){
  id_quantily = '#order-detail-quantily-' + order_detail_id;
  id_amount = '#order-detail-amount-' + order_detail_id;
  quantily = $(id_quantily).val();
  if(quantily <= 0){
    alert(I18n.t("quantily_negative"));
    return;
  }

  $.ajax({
    url: '/admin/orders/' + order_id + '/order_details/' + order_detail_id + '/update_amount',
    data: {
      quantily: quantily
    },
    success: function(result){
      $(id_amount).html(result.amount);
      $('#order-total-amount').html(result.total_amount);
    },
    error: function(){
      location.reload(true);
    }
  });
}

$(document).on('turbolinks:render', function() {
  console.log('Turbolink render...');
  $('.order-table-select').select2({
    placeholder: I18n.t('pick_table_placeholder')
  });
})
