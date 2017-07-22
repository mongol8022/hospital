<?php
require_once("../public/phpGrid/conf.php");
$doctor = CS50::query("select CONCAT(workplaces.empl_surname, ' ', LEFT(workplaces.empl_name, 1), '. ', LEFT(workplaces.empl_lastname, 1), '.') as fio, users.workplace_id from workplaces, users where users.workplace_id=workplaces.id and users.id= ? ", $_SESSION["user_id"]);
echo '<div class="container">';
$dg = new C_DataGrid("SELECT schedule.id, schedule.service_id, schedule.worplace_id, schedule.week_day,  CONCAT(services.name,' (', services.duration, ' мин.)') service, CASE schedule.week_day WHEN 0 THEN 'Понедельник' WHEN 1 THEN 'Вторник' WHEN 2 THEN 'Среда' WHEN 3 THEN 'Четверг' WHEN 4 THEN 'Пятница' WHEN 5 THEN 'Суббота' WHEN 6 THEN 'Воскресенье' END as weekday_name, schedule.time_begin, schedule.count, schedule.valid_from, schedule.valid_to FROM schedule, services, users WHERE schedule.service_id=services.id and schedule.worplace_id=users.workplace_id and users.id=".$_SESSION["user_id"], "id", 'schedule');
//$dg -> enable_autowidth(true);
$dg -> set_theme('start');
$dg -> set_locale("ru");
//для поля workplace_id устанавлимваем постоянное значение
$dg -> set_col_default('worplace_id', $doctor[0]["workplace_id"]);
//скрываем служебные поле id и из сетки и из формы редактирования
$dg -> set_col_hidden('id, worplace_id', false);
//скрываем служебные поля из сетки (нужны для формы редактирования)
$dg -> set_col_hidden('service_id, week_day');
//скрываем информационные поля для сетки из формы редактирования 
$dg->set_col_property('fio, service, weekday_name', array('editable'=>false,'hidedlg'=>true));
//$dg->set_col_property('COLUMN_NAME', array('editable'=>false,'hidedlg'=>true));
//даем полям названия, понятные пользователю
$dg -> set_col_title("service", "Тип приёма");
$dg -> set_col_title("service_id", "Тип приёма");
$dg -> set_col_title("weekday_name", "День недели");
$dg -> set_col_title("week_day", "День недели");
$dg -> set_col_title("time_begin", "Время начала");
$dg -> set_col_title("service", "Тип приёма");
$dg -> set_col_title("count", "Количество");
$dg -> set_col_title("valid_from", "Действителен с");
$dg -> set_col_title("valid_to", "Действителен по");
$dg -> set_caption('Расписание приема: '.$doctor[0]["fio"]);
//перечисляем поля, обязательные для заполнения
$dg -> set_col_required("count, service_id, time_begin, valid_from, week_day");
//форматируем поля для формы редактирования
$dg -> set_col_date("valid_from", "Y-m-d", "d.m.Y", "d.m.Y");
$dg -> set_col_date("valid_to", "Y-m-d", "d.m.Y", "d.m.Y");
$dg -> set_col_edittype("service_id", "select", "select id, CONCAT(name, ' (', duration, ' мин.)') as name from services",false);
$dg -> set_col_edittype("week_day", "select", "0:Понедельник;1:Вторник;2:Среда;3:Четверг;4:Пятница;5:Суббота;6:Воскресенье", false);
$dg -> set_col_format("count", "integer",  array('thousandsSeparator'=>',', 'defaultValue'=>'1'));
$dg -> set_col_date("time_begin", "H:i:s", "H:i:s", "H:i:s");
//разрешаем редактирование записей в отдельной форме;
$dg -> enable_edit('FORM', 'RU');
//показіваем сетку на странице
$dg -> display();
echo '</div>';
?>