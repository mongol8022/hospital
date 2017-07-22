<?php

    // configuration
    require("../includes/config.php"); 

    // if user reached page via GET (as by clicking a link or via redirect)
//    if ($_SERVER["REQUEST_METHOD"] == "GET")
//    {
        // else render form
//        render("login_form.php", ["title" => "Log In"]);
//    }

    // else if user reached page via POST (as by submitting a form via POST)
    if ($_SERVER["REQUEST_METHOD"] == "POST")
    {
        // validate submission
        if (empty($_POST["username"]))
        {
            echo 'необходимо указать имя пользователя';
        }
        else if (empty($_POST["password"]))
        {
            echo 'необходимо указать пароль';
        }
        else
        {
        // query database for user
        if ($rows = CS50::query("SELECT users.id, users.name, users.pass, usertypes.code FROM users, usertypes WHERE users.name = ? and usertypes.id=users.type", $_POST["username"]) and password_verify($_POST["password"], $rows[0]["pass"]))
            {
                    $_SESSION["user_id"] = $rows[0]["id"];
                    $_SESSION["username"] = $rows[0]["name"];
                    $_SESSION["usertype"] = $rows[0]["code"];
//                    echo 'ok';

            }
        else 
            {
                echo 'Неверное имя пользователя или пароль';
            }
        }
    }
?>
