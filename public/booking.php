<?php
// configuration
    require("../includes/config.php"); 
 // if user reached page via GET (as by clicking a link or via redirect)
//    if ($_SERVER["REQUEST_METHOD"] == "GET")
//    {
//     if 
        // else render form
//        render("register_form.php", ["title" => "Register"]);
//    }
?>
 <div>
     <h1>Уважаемый клиент!</h1>
      <p>По указанному Вами адресу электронной почты <b><?php print($_GET["email"]); ?></b> было отправлено письмо с инструкциями по завершению процедуры предварительной записи на прием. В течение следующих 20 минут выбранный прием считается забронированным и не будет доступен другим клиентам, однако если Вы не завершите процедуру записи, по истечении указанного времени бронь будет аннулирована.</p>
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
        }
    }, 1000);
}

jQuery(function ($) {
    var fiveMinutes = 60 * 20,
        display = $('#time');
    startTimer(fiveMinutes, display);
});
 </script>