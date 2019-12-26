import consumer from "./consumer"
console.log("Notification?");

consumer.subscriptions.create("NotificationsChannel", {
  received(data){
    if(data.noti){
      $("#notification-navbar-ul li:first").after(render_list(data));
      $(document).attr("title", new_title);
      $("#noti-bell-number").html(parseInt($("#noti-bell-number").html()) + 1);
    }else{
      $(document).attr("title", new_title);
      var current_title = $(".admin-noti").text();
      $(".admin-noti").html(parseInt($(".admin-noti").html()) + 1)
    }
  }
});

function render_list(data){
  var render_text = "<li class='li-notification'><div class='title'>";
  render_text += data.noti.title;
  render_text += "</div><div class='text'>";
  render_text += data.noti.text;
  render_text += "</div></li>";
  return render_text;
}

function new_title(){
  var current_title = $(document).attr("title");
  var wrap_title = current_title.match(/[^\(\d\)]/g);
  var wrap_number = current_title.match(/\(\d*\)/g);
  var title = "";

  wrap_title.forEach(function(value){
    title += value;
  });

  if(wrap_number == null){
    return "(1) " + current_title;
  }

  wrap_number = wrap_number.toString();
  var number = parseInt(wrap_number.slice(1, wrap_number.length - 1)) + 1;

  return "(" + number.toString() + ") " + title;
}
