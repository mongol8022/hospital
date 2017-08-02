<?php 
 require("../includes/config.php"); 
 if (!empty($_SESSION["user_id"]))
  {
     $contents = file_get_contents(__DIR__ . "/../config.json");
     $config = json_decode($contents, true);
     $db = mysqli_connect($config["database"]["host"], $config["database"]["username"], $config["database"]["password"]) or die("Connection Error: " . mysqli_error()); 
     mysqli_set_charset($db,'utf8');  
     mysqli_select_db($db, $config["database"]["name"]) or die("Error connecting to db."); 
    switch ($_GET["oper"]) {
        case 'select':
//            $contents = file_get_contents(__DIR__ . "/../config.json");
//            $config = json_decode($contents, true);
//            $db = mysqli_connect($config["database"]["host"], $config["database"]["username"], $config["database"]["password"]) or die("Connection Error: " . mysqli_error()); 
//            mysqli_set_charset($db,'utf8');  
//            mysqli_select_db($db, $config["database"]["name"]) or die("Error connecting to db."); 
            $page = $_GET['page']; 
            $limit = $_GET['rows']; 
            $sidx = $_GET["sidx"]; 
            $sord = $_GET["sord"]; 
//            if (!$sidx) 
//                $sidx = "7"; 
            $result = mysqli_query($db, "SELECT count(*) as count FROM schedule, services, users WHERE schedule.service_id=services.id and schedule.worplace_id=users.workplace_id and users.id=".$_SESSION["user_id"]); 
            $row = mysqli_fetch_array($result); 
            $count = $row['count']; 
            if( $count > 0 && $limit > 0) { 
            $total_pages = ceil($count/$limit); 
            } else { 
                $total_pages = 0; 
            } 
            if ($page > $total_pages) $page=$total_pages;
            $start = $limit*$page - $limit;
            if($start <0) $start = 0; 
            $SQL = "SELECT schedule.id, schedule.holiday_work, schedule.service_id, schedule.worplace_id, schedule.week_day, CASE schedule.holiday_work WHEN 0 THEN 'Нет' ELSE 'Да' END AS holiday_work_name, CONCAT(services.name,' (', services.duration, ' мин.)') service, CASE schedule.week_day WHEN 0 THEN '1. Понедельник' WHEN 1 THEN '2. Вторник' WHEN 2 THEN '3. Среда' WHEN 3 THEN '4. Четверг' WHEN 4 THEN '5. Пятница' WHEN 5 THEN '6. Суббота' WHEN 6 THEN '7. Воскресенье' END as weekday_name, schedule.time_begin, schedule.count, schedule.valid_from, schedule.valid_to FROM schedule, services, users WHERE schedule.service_id=services.id and schedule.worplace_id=users.workplace_id and users.id=".$_SESSION["user_id"]." order by ".$sidx." ".$sord." LIMIT ".$start." , ".$limit; 
            $result = mysqli_query($db, $SQL) or die("Couldn't execute query.".mysqli_error()); 
            header("Content-type: text/xml;charset=utf-8");
            $s = "<?xml version='1.0' encoding='utf-8'?>";
            $s .=  "<rows>";
            $s .= "<page>".$page."</page>";
            $s .= "<total>".$total_pages."</total>";
            $s .= "<records>".$count."</records>";
            while($row = mysqli_fetch_array($result)) {
                $s .= "<row id='". $row['id']."'>";      
                $s .= "<cell>". $row['service']."</cell>";
                $s .= "<cell>". $row['weekday_name']."</cell>";
                $s .= "<cell>". $row['time_begin']."</cell>";
                $s .= "<cell>". $row['count']."</cell>";
                 $s .= "<cell>". $row['holiday_work_name']."</cell>";
                $s .= "<cell>". $row['holiday_work']."</cell>";
                $s .= "<cell>". $row['valid_from']."</cell>";
                $s .= "<cell>". $row['valid_to']."</cell>";
                $s .= "<cell>". $row['id']."</cell>";
                $s .= "<cell>". $row['service_id']."</cell>";
                $s .= "<cell>". $row['worplace_id']."</cell>";
                $s .= "<cell>". $row['week_day']."</cell>";
                $s .= "</row>";
            }
            $s .= "</rows>"; 
            echo $s;
            break;
        
        case 'selservices':
                echo '<select  id="service_id" class="service_id">';
                $SQL=mysqli_query($db, "SELECT id, CONCAT(services.name,' (', services.duration, ' мин.)') name FROM services order by 2");
                while ($row = mysqli_fetch_array($SQL))
                {  
                    echo "<option value='".$row['id']."'>".$row['name']."</option>";
                }
 //               echo '</option>';
               echo '</select>';
               break;
        
        case 'add':
                if (isset($_GET["time_begin"]) and isset($_GET["count"]) and isset($_GET["valid_from"]) and isset($_GET["service_id"]) and isset($_GET["week_day"]) and isset($_GET["worplace_id"]) and isset($_GET["valid_to"]) and isset($_GET["holiday_work"]))
                {
                 if ($_GET["valid_to"] === 'null') { $valid_to = 'NULL';}
                 else {$valid_to = date("Y-m-d", strtotime($_GET["valid_to"]));}
                    $result = mysqli_query($db, "INSERT INTO schedule (time_begin, count, valid_from, valid_to, service_id, worplace_id, week_day, holiday_work) VALUES ('".$_GET["time_begin"].":00', '".$_GET["count"]."', '".date("Y-m-d", strtotime($_GET["valid_from"]))."', ".$valid_to.", '".$_GET["service_id"]."', '".$_GET["worplace_id"]."', '".$_GET["week_day"]."', '".$_GET["holiday_work"]."')"); 
                    echo $result;
                }
                else
                {
                    echo 'fail';
                }
                break;
        case 'edit':
                if (isset($_GET["time_begin"]) and isset($_GET["count"]) and isset($_GET["valid_from"]) and isset($_GET["service_id"]) and isset($_GET["week_day"]) and isset($_GET["worplace_id"]) and isset($_GET["valid_to"]) and isset($_GET["id"]))
                {
                    if ($_GET["valid_to"] === 'null') { $valid_to = 'NULL';}
                    else {$valid_to = date("Y-m-d", strtotime($_GET["valid_to"]));}
                    $result = mysqli_query($db, "UPDATE schedule SET time_begin = '".$_GET["time_begin"].":00', count = '".$_GET["count"]."', valid_from = '".date("Y-m-d", strtotime($_GET["valid_from"]))."', valid_to = ".$valid_to.", service_id = '".$_GET["service_id"]."', worplace_id = '".$_GET["worplace_id"]."', week_day = '".$_GET["week_day"]."', holiday_work = '".$_GET["holiday_work"]."' WHERE id = ".$_GET["id"]); 
                    echo $result;
                }
                else
                {
                    echo 'fail';
                }
                break;
        case 'del':
                if (isset($_GET["id"]))
                {
                    $result = mysqli_query($db, "DELETE FROM schedule WHERE id = ".$_GET["id"]); 
                    echo $result;
                }
                else
                {
                    echo 'fail';
                }
                break;
    }        
mysqli_close ($db);
}
else
{
    redirect("/");
}
?>