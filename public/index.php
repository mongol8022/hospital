<?php
    // configuration
    require("../includes/config.php");
 if ($_SERVER["REQUEST_METHOD"] == "GET")
    {
        //если на главную зашли незалогинившись, значит відаем форму заказа талона
        if (empty($_SESSION["user_id"]))
        {
            $positions=[];
            $datasets=[];
            $firms = CS50::query("SELECT firms.id, CONCAT(firms.name, '  (', CONCAT_WS(', ', firms.postindex, cities.name, firms.street, firms.house), ')') as name, firms.info FROM firms, cities where firms.city_id=cities.id order by 2");
            $datasets["firms"] = $firms;
            if (!empty($_GET["firm"]) && isset($datasets["firms"]) && $datasets["firms"])
            {
                $departments = CS50::query("SELECT departments.id, departments.name FROM firms, departments where departments.firm_id=firms.id and firms.id = ? order by 2", $_GET["firm"]);
                $datasets["departments"] = $departments;
                $positions["firms"] =  $_GET["firms"];
            }
            if (!empty($_GET["department"]) && isset($datasets["departments"]) && $datasets["departments"])
            {
                $workplaces = CS50::query("SELECT workplaces.id, CONCAT(empl_surname, ' ', empl_name, ' ', empl_lastname, '. ', workplaces.name) as name FROM departments,workplaces where workplaces.department_id=departments.id and departments.id = ? order by 2", $_GET["department"]);
                $positions["departments"] =  $_GET["department"];
                $datasets["workplaces"] = $workplaces;
            }
            //форме передается массив firms, содержащий id и name
            if (!empty($_POST["workplace"]) && isset($datasets["workplaces"]) && $datasets["workplaces"])
            {
                if (!empty($_POST["appointmentdate"]))
                {
                    $cur_date = $_POST["appointmentdate"];
                    print($cur_date);
                }
                else
                {
                    $cur_date = date('Y-m-d');
                }
                $appointments = CS50::query("SELECT queues.id, services.name AS servicename, CONCAT( TIME( queues.time_begin ), '-', TIME( queues.time_begin + INTERVAL services.duration "
                . "MINUTE ) ) AS name "
                . "FROM queues, schedule, services, workplaces "
                . "WHERE queues.schedule_id = schedule.id "
                . "AND schedule.service_id = services.id "
                . "AND workplaces.id = schedule.worplace_id "
                . "AND workplaces.id = ? "
                . "AND ( queues.confirm_code IS NULL OR TIMESTAMPDIFF ( MINUTE, queues.confirm_time, ? )  > 20 ) "
                . "AND schedule.week_day = WEEKDAY( ? )", $_POST["workplace"], date("Y-m-d H:i:s"), $cur_date);
                $positions["workplaces"] =  $_POST["workplace"];
                $positions["cur_date"] = $cur_date;
                }
            render("getticket.php", ["title" => "Онлайн-регистратура г. Краматорска", "datasets" => $datasets, "positions" => $positions]);
        }
    }    
 
 
 
 
 
 
 else if ($_SERVER["REQUEST_METHOD"] == "POST")
 {
       //если пост-запрос отправил неавторизованный пользователь, то обрабатываем его с помощью формы getticket.php
     if (empty($_SESSION["user_id"]))
     {
        $positions=[];
        $datasets=[];
        $firms = CS50::query("SELECT firms.id, CONCAT (firms.name, '  (', CONCAT_WS(', ', firms.postindex, cities.name, firms.street, firms.house), ')') as name, firms.info FROM firms, cities where firms.city_id=cities.id order by 2");
        $datasets["firms"] = $firms;
        $positions["firms"] =  $_POST["firm"];
        if (!empty($_POST["firm"]) && isset($datasets["firms"]) && $datasets["firms"])
        {
            $departments = CS50::query("SELECT departments.id, departments.info, departments.name FROM firms, departments where departments.firm_id=firms.id and firms.id = ? order by 2", $_POST["firm"]);
            $datasets["departments"] = $departments;
        }
        if (!empty($_POST["department"]) && isset($datasets["departments"]) && $datasets["departments"])
        {
            $workplaces = CS50::query("SELECT workplaces.id, CONCAT(empl_surname, ' ', empl_name, ' ', empl_lastname, '. ', workplaces.name) as name FROM departments,workplaces where workplaces.department_id=departments.id and departments.id = ? order by 2", $_POST["department"]);
            $positions["departments"] =  $_POST["department"];
            $datasets["workplaces"] = $workplaces;
        }
        if (!empty($_POST["workplace"]) && isset($datasets["workplaces"]) && $datasets["workplaces"])
        {
            if (!empty($_POST["appointmentdate"]))
            {
                //print(date('Y-m-d', strtotime($_POST["appointmentdate"])));
                 $cur_date = $_POST["appointmentdate"];
            }
            else
            {
                $gmtTimezone = new DateTimeZone('EEST');
                $cur_date = new DateTime(date('Y-m-d H:i:s'), $gmtTimezone);
                $cur_date =  date_format($cur_date, 'Y-m-d');
                //$cur_date = date('Y-m-d');
                
            }
            $appointments = CS50::query("SELECT queues.id, services.name AS servicename, TIME_FORMAT (TIME( queues.time_begin), '%H:%i' ) "
    . " AS name "
    . "FROM queues, schedule, services, workplaces "
    . "WHERE queues.schedule_id = schedule.id "
    . "AND schedule.service_id = services.id "
    . "AND workplaces.id = schedule.worplace_id "
    . "AND workplaces.id = ? "
    . "AND queues.cancel_code IS NULL "
    . "AND ( queues.confirm_time IS NULL OR TIMESTAMPDIFF ( MINUTE, queues.confirm_time, ? )  >= 20 ) "
    . "AND schedule.week_day = WEEKDAY( ? ) "
    . "AND DATE(queues.time_begin) = ? "
    . "AND queues.time_begin > ? ", $_POST["workplace"], date("Y-m-d H:i:s"),  $cur_date, $cur_date, date("Y-m-d H:i:s"));
            $positions["workplaces"] =  $_POST["workplace"];
            $positions["cur_date"] = $cur_date;
            $datasets["appointments"] = $appointments;
        }
        //форме передается массив массивов данных для заполнения данными элементов формы, а также массив выбранных значений для каждого элемента (если они есть)
        render("getticket.php", ["title" => "Запись на приём", "positions" => $positions, "datasets" => $datasets]);
     }
 }
?>