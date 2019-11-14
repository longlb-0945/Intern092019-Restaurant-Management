function readURL(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();

    reader.onload = function (e) {
      $('.preview_img')
        .attr('src', e.target.result)
        .width(150)
        .height(150)
        .css('background-image', 'none');
    };

    reader.readAsDataURL(input.files[0]);
  }
}

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

  $(document).on('change', '.sort-select', function() {
    this.form.submit();
  });

  $(document).on('mouseover', '.menu-category', function() {
    $('#menu-category-dropdown').css('display', 'block');
  });

  $(document).on('mouseout', '.menu-category', function() {
    $('#menu-category-dropdown').css('display', 'none');
  });

  $(document).on('mouseover', '.menu-profile', function() {
    $('#menu-profile-dropdown').css('display', 'block');
  });

  $(document).on('mouseout', '.menu-profile', function() {
    $('#menu-profile-dropdown').css('display', 'none');
  });
});
