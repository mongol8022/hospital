<?php
 require("../includes/config.php"); 
 if (!empty($_SESSION["user_id"]) and $_SESSION["usertype"] == 'employ' and $_SERVER["REQUEST_METHOD"] == "GET")
  {
    if (isset($_GET["action"]) and $_GET["action"] == "getappoints" and isset($_GET["date"]) and 
    
     $result = CS50::query("SELECT queues.id, services.name AS servicename, TIME_FORMAT( TIME( queues.time_begin ) ,  '%H:%i' ) AS time_begin, "
."CASE WHEN queues.cancel_code IS NULL "
."THEN 0 "
."ELSE 1 "
."END AS is_reserved, "
."case when TIMESTAMPDIFF ( MINUTE, queues.confirm_time, ?)  < 20 THEN 1 else 0 END as is_booked, "
."CONCAT( queues.person_surname,  ' ', LEFT( queues.person_name, 1 ) ,  '.', LEFT( queues.person_lastname, 1 ) ,  '.' ) AS patient_name, case WHEN RIGHT(TIMESTAMPDIFF( YEAR, date_born, ? ), 1) = 1 then CONCAT(TIMESTAMPDIFF( YEAR, date_born, ? ), ' год') WHEN RIGHT(TIMESTAMPDIFF( YEAR, date_born, ? ), 1) >=2 AND RIGHT(TIMESTAMPDIFF( YEAR, date_born, ? ), 1) <5 then CONCAT(TIMESTAMPDIFF( YEAR, date_born, ? ), ' года') ELSE CONCAT(TIMESTAMPDIFF( YEAR, date_born, ? ), ' лет') END AS age "
."FROM queues, schedule, services, workplaces "
."WHERE queues.schedule_id = schedule.id "
."AND schedule.service_id = services.id "
."AND workplaces.id = schedule.worplace_id "
."AND workplaces.id =1 "
."AND schedule.week_day = WEEKDAY( ? ) "
."AND DATE( queues.time_begin ) = ? ", date("Y-m-d H:i:s"), date("Y-m-d"), date("Y-m-d"), date("Y-m-d"), date("Y-m-d"), date("Y-m-d"), date("Y-m-d"), $_GET["date"], $_GET["date"]))
//     print ("<div class=\"btn-group\">");
 {
     echo '<p><span style="color: #5cb85c;">&block;</span> - Приём свободен&emsp;&emsp;&emsp;&emsp;&emsp;<span style="color: #5bc0de;">&block;</span> - Приём забронирован&emsp;&emsp;&emsp;&emsp;&emsp;<span style="color: #337ab7;">&block;</span> - Приём занят</p><br>';
     foreach ($result as $appointment)
      {
        print("<div class=\"btn-group\"><button type=\"button\" id=\"freeappts\" name=\"".$appointment["id"]."\" data-toggle=\"dropdown\" class=\"dropdown-toggle btn ");
        if ($appointment["is_reserved"] == '1') 
          print ("btn-primary btn-lg\" type=\"button\" onclick=\"window.queue_id = this.getAttribute('name');\">".$appointment["time_begin"]."</button><ul class=\"dropdown-menu\"><li class=\"dropdown-header\">Пациент: ".$appointment["patient_name"].' '.$appointment["age"]."</li><li><a href=\"\" data-toggle=\"modal\" data-target=\"#appointfreemodal\">Освободить приём</a></li><li><a href=\"\" data-toggle=\"modal\" data-target=\"#appointdelmodal\">Удалить приём</a></li></ul></div>");
        else if ($appointment["is_booked"] == '1')
           print ("btn-info btn-lg\" type=\"button\" onclick=\"window.queue_id = this.getAttribute('name');\">".$appointment["time_begin"]."</button><ul class=\"dropdown-menu\"><li class=\"dropdown-header\">Пациент: ".$appointment["patient_name"].' '.$appointment["age"]."</li><li><a href=\"\" data-toggle=\"modal\" data-target=\"#appointcanlmodal\">Отменить бронирование</a></li><li><a href=\"\" data-toggle=\"modal\" data-target=\"#appointdelmodal\">Удалить приём</a></li></ul></div>");
        else 
           print ("btn-success btn-lg\" type=\"button\" onclick=\"window.queue_id = this.getAttribute('name');\">".$appointment["time_begin"]."</button><ul class=\"dropdown-menu\"><li><a href=\"\" data-toggle=\"modal\" data-target=\"#appointmodal\">Записать на приём</a></li><li><a href=\"\" data-toggle=\"modal\" data-target=\"#appointdelmodal\">Удалить приём</a></li></ul></div>");
//        print("btn-lg\" role=\"button\" onclick=\"window.queue_id = this.getAttribute('name');\">".$appointment["name"]."</button>\n");
      }
//    print ("</div>");
    }
    else if (isset($_GET["action"]) and $_GET["action"] == "getappoints" and isset($_GET["date"]) and isset($result) and !$result) {
       echo ('<div id="infoalert" class="alert alert-info"><span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span> Отсутствуют доступные приемы</div>');
    }
    else if (isset($_GET["action"]) and $_GET["action"] == "delappoint" and isset($_GET["id"]) and !empty($_GET["id"]))
    {
        echo '<center>';
        if (CS50::query("DELETE FROM queues where id = ? ", $_GET["id"]))
            echo'<p>Приём успешно удален.</p><br>';
        else
            echo '<p>Ошибка удаления. Выбранный приём не найден в базе данных.</p><br>';
        echo '<button type="button" class="btn btn-default" data-dismiss="modal">Закрыть</button></center>';
    }
      else if (isset($_GET["action"]) and $_GET["action"] == "freeappoint" and isset($_GET["id"]) and !empty($_GET["id"]))
    {
        echo '<center>';
        if (CS50::query("UPDATE queues SET cancel_code = NULL where id = ? ", $_GET["id"]))
            echo'<p>Приём успешно освобожден.</p><br>';
        else
            echo '<p>Ошибка освобождения. Выбранный приём не найден в базе данных.</p><br>';
        echo '<button type="button" class="btn btn-default" data-dismiss="modal">Закрыть</button></center>';
    }
          else if (isset($_GET["action"]) and $_GET["action"] == "cancelappoint" and isset($_GET["id"]) and !empty($_GET["id"]))
    {
        echo '<center>';
        if (CS50::query("UPDATE queues SET confirm_code = NULL, confirm_time = NULL where id = ? ", $_GET["id"]))
            echo'<p>Бронь успешно отменена.</p><br>';
        else
            echo '<p>Ошибка отмены брони. Выбранный приём не найден в базе данных.</p><br>';
        echo '<button type="button" class="btn btn-default" data-dismiss="modal">Закрыть</button></center>';
    }
    else
    {
       render("doc_queue_form.php", ["title" => "Кабинет врача. Приёмы."]);
    }
  }
 else
{
    redirect("/");
}
?>