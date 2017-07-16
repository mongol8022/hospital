<?php
    require("../includes/config.php"); 

 if ($_SERVER["REQUEST_METHOD"] == "GET")
    {
         render("medical_page.php", ["title" => "Медицинские учреждения г. Краматорска",]);
    }    
?>
