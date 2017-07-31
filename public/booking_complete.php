<?php 
 // configuration
    require("../includes/config.php"); 
    if ($_SERVER["REQUEST_METHOD"] == "GET" and ((isset($_GET["code"]) and count($queue_id=CS50::query("SELECT id FROM queues WHERE confirm_code = ? AND TIMESTAMPDIFF ( MINUTE, queues.confirm_time, ? )  < 20 ", $_GET["code"], date("Y-m-d H:i:s")))) or (!empty($_SESSION["user_id"]) and !empty($_GET["id"]) and $queue_id=CS50::query("SELECT id FROM queues WHERE id = ? ", $_GET["id"]) and CS50::query("UPDATE queues SET person_surname = ?, person_name = ?, person_lastname = ?, date_born = ? WHERE id = ?", $_GET["surname"], $_GET["name"], $_GET["lastname"], $_GET["dateborn"], $_GET["id"]))))
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
            //print("success!");
            $talondata = CS50::query("SELECT queues.id, queues.ticket_num, firms.name as firm, departments.name as department, " 
            ."CONCAT (workplaces.name,  ' ', workplaces.empl_surname, ' ', LEFT(workplaces.empl_name , 1), '.', "
            ."LEFT(workplaces.empl_lastname , 1), '.') as doctor, "
            ."CONCAT(services.name, ' (', services.duration, ' мин.)') as appointtype, "
            ."DATE_FORMAT(queues.time_begin, '%d.%m.%Y %H:%i') as date_time, "
            ."CONCAT(queues.person_surname, ' ', LEFT(queues.person_name, 1), '.', LEFT(queues.person_lastname, 1), '.') as client_fio, "
            ."queues.cancel_code FROM queues, firms, departments, workplaces, schedule, services "
            ."WHERE queues.schedule_id=schedule.id and schedule.service_id=services.id and schedule.worplace_id=workplaces.id "
            ."and workplaces.department_id=departments.id and departments.firm_id=firms.id and queues.id = ? ", $queue_id[0]["id"]);

             if (!empty($_SESSION["user_id"]) and isset($_GET["id"]))
                require("../views/booking_complete_form.php");
             else {
             
                render("booking_complete_form.php", ["title" => "Запись на прием подтверждена", "talondata" => $talondata]);
                
             }
        }
    }
    //если не указан код, неверный код или метод пост, то ошибка 404 и завершение
    else 
    {
        http_response_code(404);
        die();
    }
?>