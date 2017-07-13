<?php
    require("../includes/config.php"); 

 if ($_SERVER["REQUEST_METHOD"] == "GET")
    {
         render("cancel_form.php", ["title" => "Отмена приема",]);
    }    
?>
