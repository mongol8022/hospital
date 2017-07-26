<?php
 require("../includes/config.php"); 
 if (!empty($_SESSION["user_id"]) and $_SESSION["usertype"] == 'employ' and $_SERVER["REQUEST_METHOD"] == "GET")
  {
     render("doc_queue_form.php", ["title" => "Кабинет врача. Графики приема."]);
  }
 else
{
    redirect("/");
}
 
?>