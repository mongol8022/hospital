<?php
    require("../includes/config.php"); 

 if ($_SERVER["REQUEST_METHOD"] == "GET")
    {
         render("kmu_hosp2_form.php", ["title" => "КМУ Городская больница №2",]);
    }    
?>
