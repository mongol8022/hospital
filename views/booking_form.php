 <div>
     <h1><?php echo $title; ?></h1>
      <p><?php echo $message; ?></p>
      <h2 id=time></h2>
  </div>
 <button type="button" class="btn btn-default" data-dismiss="modal" onclick="document.getElementById('appoint').submit();">Ok</button>
<script>
 function startTimer(duration, display) {
    var timer = duration, minutes, seconds;
    setInterval(function () {
        minutes = parseInt(timer / 60, 10);
        seconds = parseInt(timer % 60, 10);

        minutes = minutes < 10 ? "0" + minutes : minutes;
        seconds = seconds < 10 ? "0" + seconds : seconds;

        display.text(minutes + ":" + seconds);

        if (--timer < 0) {
            timer = 0;
            document.getElementById("time").style.color = "#FF0000";
        }
    }, 1000);
}

jQuery(function ($) {
    var fiveMinutes = 60 * 20,
        display = $('#time');
    startTimer(fiveMinutes, display);
});
 </script>