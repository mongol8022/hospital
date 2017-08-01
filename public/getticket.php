<?php 
 require("../includes/config.php");
 $positions=[];
 $datasets=[];
 if (!count($_GET)) {
 //(!isset($_GET["firm_id"]) or empty($_GET["firm_id"])) {
    $datasets["firms"] = CS50::query("SELECT firms.id, CONCAT(firms.name, '  (', CONCAT_WS(', ', firms.postindex, cities.name, firms.street, firms.house), ')') as name, firms.info FROM firms, cities where firms.city_id=cities.id order by 2");
    render("getticketform.php", ["title" => "Запись на приём","datasets" => $datasets]);
 }
 elseif (isset($_GET["firm_id"]) and !empty($_GET["firm_id"])) {
        $datasets["departments"] = CS50::query("SELECT departments.id, departments.info, departments.name FROM firms, departments where departments.firm_id=firms.id and firms.id = ? order by name", $_GET["firm_id"]);
        echo '<div class="form-group" id="departmentdiv">';
        if ($datasets["departments"]) {
            echo '<label for="department">Отделение:</label><select class="form-control" name="department" id="department" onchange="if (this.value>0) { change_complete(\'departmentdiv\'); }"><option disabled selected>Ничего не выбрано</option>';
            foreach ($datasets["departments"] as $element)
            {
                 echo '<option value="'.$element["id"].'">'.$element["name"].'</option>\n';
             }
        echo '</select>';    
        }
        else 
            echo '<div class="alert alert-info">К сожалению в данный момент нет доступных медицинских учреждений.</div>';
        echo '</div>';
        if ($result=CS50::query("SELECT info from firms where id = ? ", $_GET["firm_id"])) {
            echo $result[0]["info"];
        }
        
}
elseif (isset($_GET["department"]) and !empty($_GET["department"])) {
        $datasets["workplaces"] = CS50::query("SELECT workplaces.id, CONCAT(empl_surname, ' ', empl_name, ' ', empl_lastname, '. ', workplaces.name) as name FROM departments,workplaces where workplaces.department_id=departments.id and departments.id = ? order by 2", $_GET["department"]);
        echo '<div class="form-group" id="workplacediv">';
        if ($datasets["workplaces"]) {
            echo '<label for="workplace">Отделение:</label><select class="form-control" name="workplace" id="workplace" onchange="if (this.value>0) { change_complete(\'workplacediv\'); }"><option disabled selected>Ничего не выбрано</option>';
            foreach ($datasets["workplaces"] as $element)
            {
                 echo '<option value="'.$element["id"].'">'.$element["name"].'</option>\n';
             }
        echo '</select>';    
        }
        else 
            echo '<div class="alert alert-info" id="infoalert"><span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span> К сожалению для выбранного подразделения отсутствуют врачи</div>';
        echo '</div>';
}
elseif (isset($_GET["workplace"]) and !empty($_GET["workplace"])) {
            if (!isset($_GET["appointmentdate"]) or empty($_GET["appointmentdate"])) {
                $gmtTimezone = new DateTimeZone('EEST');
                $cur_date = new DateTime(date('Y-m-d H:i:s'), $gmtTimezone);
                $cur_date =  date_format($cur_date, 'Y-m-d');
            }
            else
                $cur_date = $_GET["appointmentdate"];
            $datasets["appointments"] = CS50::query("SELECT queues.id, CONCAT(services.name, ' (', services.duration, ' мин.)') AS servicename, TIME_FORMAT (TIME( queues.time_begin), '%H:%i' ) "
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
    . "AND queues.time_begin > ? ORDER BY 2,3", $_GET["workplace"], date("Y-m-d H:i:s"),  $cur_date, $cur_date, date("Y-m-d H:i:s"));
            //$positions["workplaces"] =  $_GET["workplace"];
            //$positions["cur_date"] = $cur_date;
    if (!empty($_GET["workplace"]) and empty($_GET["appointmentdate"]))
        echo '<div class="form-group" id="datediv"><div class="panel panel-default"><div class="panel-heading"><b>Дата приема</b></div><div class="panel-body"><div id="datetimepicker12" data-date-min-date="'.date("Y-m-d").'" data-date-locale="ru" data-date-inline="true" data-date-format="YYYY-MM-DD" name="datetimepicker12"></div></div></div></div><script type="text/javascript">$(\'#datetimepicker12\').datetimepicker({inline: true,}); $("#datetimepicker12").datetimepicker().on("dp.change",function(e){change_complete("datediv");});</script>';
    echo '<div class="panel panel-default">';
	    echo '<div class="panel-heading"><b>Доступные приемы</b></div>';
	        echo '<div class="panel-body">';
		        if ($datasets["appointments"]) {
			        $servname = $datasets["appointments"][0]["servicename"];
			        echo '<div class="panel panel-default"><div class="panel-heading"><b>'.$datasets["appointments"][0]["servicename"].'</b></div><div class="panel-body">';
			        foreach ($datasets["appointments"] as $appointment) {
				        if ($servname <> $appointment["servicename"]) {
					        echo '</div></div>';
					        echo '<div class="panel panel-default"><div class="panel-heading"><b>'.$appointment["servicename"].'</b></div><div class="panel-body">';
                             $servname = $appointment["servicename"];
				        }
			        echo '<div class="btn-group"><button type="button" id="freeappts" name="'.$appointment["id"].'" data-toggle="modal" data-target="#mymodal"  class="btn btn-success btn-lg" role="button" onclick="window.queue_id = this.getAttribute(\'name\');">'.$appointment["name"].'</button></div>';
			        }
			        echo '</div></div>';
		        }
		        else
		           echo '<div id="infoalert" class="alert alert-info"><span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span> Отсутствуют доступные приемы</div>';
	        echo '</div>';
        echo '</div>';              
}

?>