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
  $('.alert').delay(5000).fadeOut();

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

  $(document).on('mouseover', '#menu-notification', function() {
    $('#notification-navbar-ul').css('display', 'block');
  });

  $(document).on('mouseout', '#menu-notification', function() {
    $('#notification-navbar-ul').css('display', 'none');
  });

  $(document).on('click', '.edit_notification', function(){
    this.submit();
  });

  $(document).on('click', '#mark-noti-submit', function(){
    $('#mark-noti-form').submit();
  });

  $("#datetimepicker2").datetimepicker();

  $("#datetimepicker").datetimepicker();
});
