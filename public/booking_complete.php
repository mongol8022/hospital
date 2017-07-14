<?php 
 // configuration
    require("../includes/config.php"); 
    if ($_SERVER["REQUEST_METHOD"] == "GET" and isset($_GET["code"]) and count($queue_id=CS50::query("SELECT id FROM queues WHERE confirm_code = ? AND TIMESTAMPDIFF ( MINUTE, queues.confirm_time, ? )  < 20 ", $_GET["code"], date("Y-m-d H:i:s"))))
    {
        //генерация уникального 10-значного цифрового кода отмены талона
        do {
                    $cancelcode =  randomKey(10, true, false, false);
            } while (count(CS50::query("SELECT id from queues WHERE cancel_code = ? ", $cancelcode)));
        if (!CS50::query("UPDATE queues SET cancel_code = ?, confirm_code = NULL, confirm_time = NULL WHERE id = ? ", $cancelcode, $queue_id[0]["id"]))
        {
            $title = "Ошибка";
            $message = "В процессе завершения процедуры записи на приём возникла непредвиденная ошибка.";
        }
        else
        {
            print("success!");
        }
    }
    else 
    {
        http_response_code(404);
        die();
    }
?>