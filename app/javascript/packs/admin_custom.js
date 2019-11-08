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
});
