<?php
    // configuration
    require("../includes/config.php"); 

 if ($_GET[''])
    {
        
    }   
    
    $datasets=[];
        //если на главную зашли незалогинившись, значит відаем форму заказа талона
        if (empty($_SESSION["user_id"]))
        {
        $firms = CS50::query("SELECT firms.id, CONCAT('<h3>', firms.name,'</h3>',  '<div class = \"address-box\"><b class = \"col-xs-3\">Адрес:</b><div class = \"col-xs-9\">', CONCAT_WS(', ', firms.postindex, cities.name, firms.street, firms.house), '</div></div>') as name FROM firms, cities where firms.city_id=cities.id order by 2");
        $datasets["firms"] = $firms;
        //форме передается массив firms, содержащий id и name
        render("medical_page.php", ["title" => "Учреждения Города", "datasets" => $datasets]);
        
        }
        
 
 



?>
