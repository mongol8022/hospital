<?php
    // configuration
    require("../includes/config.php"); 

 if ($_SERVER["REQUEST_METHOD"] == "GET")
    {
        //если на главную зашли незалогинившись, значит відаем форму заказа талона
        if (empty($_SESSION["user_id"]))
        {
        $firms = CS50::query("SELECT firms.id, CONCAT(firms.name, ' Адрес: ', CONCAT_WS(', ', firms.postindex, cities.name, firms.street, firms.house)) as name FROM firms, cities where firms.city_id=cities.id order by firms.name");
        //форме передается массив firms, содержащий id и name
        render("getticket.php", ["title" => "Получить талон", "firms" => $firms]);
        }
    }    
 else if ($_SERVER["REQUEST_METHOD"] == "POST")
 {
      //если пост-запрос отправил неавторизованный пользователь, то обрабатываем его с помощью формы getticket.php
     if (empty($_SESSION["user_id"]))
     {
        $postitions=[];
        $firms=[];
        $firms = CS50::query("SELECT firms.id, CONCAT (firms.name, '    Адрес: ', CONCAT_WS(', ', firms.postindex, cities.name, firms.street, firms.house)) as name FROM firms, cities where firms.city_id=cities.id order by firms.name");
        $positions["firms"] =  $_POST["firm"];
        $departments=[];
        if (!empty($_POST["firm"]))
        {
            $departments = CS50::query("SELECT departments.id, departments.name FROM firms, departments where departments.firm_id=firms.id and firms.id = ? order by departments.name", $_POST["firm"]);
        }
        $workplaces=[];
        if (!empty($_POST["department"]))
        {
            $workplaces = CS50::query("SELECT workplaces.id, workplaces.name FROM departments,workplaces where workplaces.department_id=departments.id and departments.id = ? order by workplaces.name", $_POST["department"]);
            $positions["departments"] =  $_POST["department"];
        }
        //форме передается массив firms, содержащий id и name
        render("getticket.php", ["title" => "Получить талон", "positions" => $positions, "firms" => $firms, "firms_val" => $_POST["firm"], "departments" => $departments, "workplaces" => $workplaces]);
     }
 }



?>
