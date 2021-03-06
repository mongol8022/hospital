<?php
// configuration
    require("../includes/config.php"); 
 // if user reached page via GET (as by clicking a link or via redirect)
    if ($_SERVER["REQUEST_METHOD"] == "GET")
    {
     $iserror = false;
     if (!isset($_GET["id"]) or empty($_GET["id"]) or !isset($_GET["surname"]) or empty($_GET["surname"]) or !isset($_GET["name"]) or empty($_GET["name"]) or !isset($_GET["lastname"]) or empty($_GET["lastname"]) or !isset($_GET["dateborn"]) or empty($_GET["dateborn"]) or !isset($_GET["email"]) or empty($_GET["email"]))
        {
            $title = "Ошибка!";
            $message = "Не все необходимые поля заполнены.";
            $iserror = true;
        }
     else
        {
            //$confirmcode =  randomKey(20, 1, 1, 1);
            //генерация уникального псевдослучайного кода подтверждения бронирования
            do {
                    $confirmcode =  randomKey(20, true, true, true);
                } while (count(CS50::query("SELECT id from queues WHERE confirm_code = ? ", $confirmcode)));
            $result = CS50::query("UPDATE queues SET person_surname = ?, person_name = ?, person_lastname = ?, date_born = ?, confirm_code = ?, confirm_time = ?  WHERE id = ?  and (confirm_time is NULL or TIMESTAMPDIFF(MINUTE, confirm_time, ? ) >= 20) and cancel_code is NULL", $_GET["surname"], $_GET["name"], $_GET["lastname"], $_GET["dateborn"], $confirmcode, date("Y-m-d H:i:s"),  $_GET["id"], date("Y-m-d H:i:s"));
            //если запись не обновилась, значит е' нет в БД, ошибка
            if(!$result)
            {
                $title = "Ошибка!";
                $message = "Выбранный прием отсутствует, либо уже занят/забронирован.";
                $iserror = true;
            }
            //иначе отправка письма со ссілкой для подтверждения записи на прием
            else
            {
                sendmail($_GET["email"], "Завершите запись на прием", "<h3>Для завершения процедуры записи на прием к врачу, пожалуйста перейдите по <a href=".(isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] != 'off' ? 'https' : 'http')."://".$_SERVER['SERVER_NAME']."/booking_complete.php?code=".$confirmcode.">ссылке</a>.</h3><br><br><br><br>С уважением,<br>команда проекта \"Онлайн-регистратура г.Краматорска\".");
                $title = "Уважаемый клиент!";
                $message = "По указанному Вами адресу электронной почты <b>".$_GET["email"]."</b> было отправлено письмо с инструкциями по завершению процедуры предварительной записи на прием. В течение следующих 20 минут выбранный прием считается забронированным и не будет доступен другим клиентам, однако если Вы не завершите процедуру записи, по истечении указанного времени бронь будет аннулирована.";
            }
        }
    require("../views/booking_form.php");    
        // else render form
//        render("register_form.php", ["title" => "Register"]);
    }
?>
