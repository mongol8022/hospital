<?php
    require("../includes/config.php"); 

 if ($_SERVER["REQUEST_METHOD"] == "GET" and isset($_GET["cancelcode"]) and !empty($_GET["cancelcode"]) and $queue = CS50::query("update queues set cancel_code = NULL where cancel_code = ? and time_begin > ? ", $_GET["cancelcode"], date("Y-m-d H:i:s")))
    {
         $message = "Запись на приём была успешно отменена.";
         //render("cancel_form.php", ["title" => "Отмена приема",]);
    }    
else 
{
     $message = "Не найден приём, соответствующий введенному коду отмены.";
}
require("../views/cancel_form.php");
?>
