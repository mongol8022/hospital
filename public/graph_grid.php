<?php 
require("../includes/config.php"); 
//include the information needed for the connection to MySQL data base server. 
// we store here username, database and password 
//include("dbconfig.php");
 
// to the url parameter are added 4 parameters as described in colModel
// we should get these parameters to construct the needed query
// Since we specify in the options of the grid that we will use a GET method 
// we should use the appropriate command to obtain the parameters. 
// In our case this is $_GET. If we specify that we want to use post 
// we should use $_POST. Maybe the better way is to use $_REQUEST, which
// contain both the GET and POST variables. For more information refer to php documentation.
// Get the requested page. By default grid sets this to 1. 
$page = $_GET['page']; 
 
// get how many rows we want to have into the grid - rowNum parameter in the grid 
$limit = $_GET['rows']; 
 
// get index row - i.e. user click to sort. At first time sortname parameter -
// after that the index from colModel 
$sidx = $_GET["sidx"]; 
 
// sorting order - at first time sortorder 
$sord = $_GET["sord"]; 
 
// if we not pass at first time index use the first column for the index or what you want
if(!$sidx) $sidx =1; 

$contents = file_get_contents(__DIR__ . "/../config.json");
$config = json_decode($contents, true);
 
// connect to the MySQL database server 
$db = mysqli_connect($config["database"]["host"], $config["database"]["username"], $config["database"]["password"]) or die("Connection Error: " . mysqli_error()); 
mysqli_set_charset($db,'utf8');  
 
// select the database 
mysqli_select_db($db, $config["database"]["name"]) or die("Error connecting to db."); 
// calculate the number of rows for the query. We need this for paging the result 
////$result = CS50::query("SELECT count(*) as count FROM schedule, services, users WHERE schedule.service_id=services.id and schedule.worplace_id=users.workplace_id and users.id= ?", $_SESSION["user_id"]);
$result = mysqli_query($db, "SELECT count(*) as count FROM schedule, services, users WHERE schedule.service_id=services.id and schedule.worplace_id=users.workplace_id and users.id=".$_SESSION["user_id"]); 
$row = mysqli_fetch_array($result); 
$count = $row['count']; 
////$count = $result[0]["count"]; 
 
// calculate the total pages for the query 
if( $count > 0 && $limit > 0) { 
              $total_pages = ceil($count/$limit); 
} else { 
              $total_pages = 0; 
} 
 
// if for some reasons the requested page is greater than the total 
// set the requested page to total page 
if ($page > $total_pages) $page=$total_pages;
 
// calculate the starting position of the rows 
$start = $limit*$page - $limit;
 
// if for some reasons start position is negative set it to 0 
// typical case is that the user type 0 for the requested page 
if($start <0) $start = 0; 
 
// the actual query for the grid data 
$SQL = "SELECT schedule.id, schedule.service_id, schedule.worplace_id, schedule.week_day, CONCAT(services.name,' (', services.duration, ' мин.)') service, CASE schedule.week_day WHEN 0 THEN '1. Понедельник' WHEN 1 THEN '2. Вторник' WHEN 2 THEN '3. Среда' WHEN 3 THEN '4. Четверг' WHEN 4 THEN '5. Пятница' WHEN 5 THEN '6. Суббота' WHEN 6 THEN '7. Воскресенье' END as weekday_name, schedule.time_begin, schedule.count, schedule.valid_from, schedule.valid_to FROM schedule, services, users WHERE schedule.service_id=services.id and schedule.worplace_id=users.workplace_id and users.id=".$_SESSION["user_id"]." order by ".$sidx." ".$sord." LIMIT ".$start." , ".$limit; 
//echo  $sidx;
//, $sord, $start, $limit;
////$result = CS50::query("SELECT schedule.id, schedule.service_id, schedule.worplace_id, schedule.week_day, CONCAT(services.name,' (', services.duration, ' мин.)') service, CASE schedule.week_day WHEN 0 THEN 'Понедельник' WHEN 1 THEN 'Вторник' WHEN 2 THEN 'Среда' WHEN 3 THEN 'Четверг' WHEN 4 THEN 'Пятница' WHEN 5 THEN 'Суббота' WHEN 6 THEN 'Воскресенье' END as weekday_name, schedule.time_begin, schedule.count, schedule.valid_from, schedule.valid_to FROM schedule, services, users WHERE schedule.service_id=services.id and schedule.worplace_id=users.workplace_id and users.id= ? order by ? ? ", $_SESSION["user_id"], $sidx, $sord);
$result = mysqli_query($db, $SQL) or die("Couldn't execute query.".mysqli_error()); 
 
// we should set the appropriate header information. Do not forget this.
header("Content-type: text/xml;charset=utf-8");
 
$s = "<?xml version='1.0' encoding='utf-8'?>";
$s .=  "<rows>";
$s .= "<page>".$page."</page>";
$s .= "<total>".$total_pages."</total>";
$s .= "<records>".$count."</records>";
 
// be sure to put text data in CDATA
//while($row = mysql_fetch_array($result,MYSQL_ASSOC)) {
////foreach ($result as $row) {
while($row = mysqli_fetch_array($result)) {
    $s .= "<row id='". $row['id']."'>";            
    $s .= "<cell>". $row['service']."</cell>";
    $s .= "<cell>". $row['weekday_name']."</cell>";
    $s .= "<cell>". $row['time_begin']."</cell>";
    $s .= "<cell>". $row['count']."</cell>";
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
?>