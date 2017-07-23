<?php
    require("../includes/config.php"); 

 if ($_SERVER["REQUEST_METHOD"] == "GET")
    {
         render("kmu_hosp3_form.php", ["title" => "КМУ Городская больница №3",]);
    }    
?>
