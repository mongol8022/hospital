<?php

    /**
     * helpers.php
     *
     * Computer Science 50
     * Problem Set 7
     *
     * Helper functions.
     */

    require_once("config.php");

    /**
     * Apologizes to user with message.
     */
    function apologize($message)
    {
        render("apology.php", ["message" => $message]);
    }

    /**
     * Facilitates debugging by dumping contents of argument(s)
     * to browser.
     */
    function dump()
    {
        $arguments = func_get_args();
        require("../views/dump.php");
        exit;
    }

    /**
     * Logs out current user, if any.  Based on Example #1 at
     * http://us.php.net/manual/en/function.session-destroy.php.
     */
    function logout()
    {
        // unset any session variables
        $_SESSION = [];

        // expire cookie
        if (!empty($_COOKIE[session_name()]))
        {
            setcookie(session_name(), "", time() - 42000);
        }

        // destroy session
        session_destroy();
    }

     /**
     * Redirects user to location, which can be a URL or
     * a relative path on the local host.
     *
     * http://stackoverflow.com/a/25643550/5156190
     *
     * Because this function outputs an HTTP header, it
     * must be called before caller outputs any HTML.
     */
    function redirect($location)
    {
        if (headers_sent($file, $line))
        {
            trigger_error("HTTP headers already sent at {$file}:{$line}", E_USER_ERROR);
        }
        header("Location: {$location}");
        exit;
    }

    /**
     * Renders view, passing in values.
     */
    function render($view, $values = [])
    {
        // if view exists, render it
        if (file_exists("../views/{$view}"))
        {
            // extract variables into local scope
            extract($values);

            // render view (between header and footer)
            require("../views/header.php");
            require("../views/{$view}");
            require("../views/footer.php");
            exit;
        }

        // else err
        else
        {
            trigger_error("Invalid view: {$view}", E_USER_ERROR);
        }
    }

//send e-mail message
function sendmail($address, $subject, $body)
{
    require("libphp-phpmailer/class.phpmailer.php");
   
    $mail = new PHPMailer();
    $mail->IsSMTP();
    $mail->SMTPAuth = true;
    $mail->SMTPSecure = "tls";
    $mail->Host = "smtp.gmail.com"; // change to your email host
    $mail->Port = 587; // change to your email port
    $mail->CharSet = 'UTF-8';
    $mail->Username = "vasyapupkinkram123@gmail.com"; // change to your username
    $mail->Password = "kf,jhfnjhyfzrhscf"; // change to your email password
    $mail->setFrom("vasyapupkinkram123@gmail.com", "Онлайн-регистратура"); // change to your email password
   
    $mail->AddAddress($address); // change to user's email address
   
    $mail->Subject = $subject; // change to email's subject
    $mail->Body = $body; // change to email's body, add the needed link here
    $mail->IsHTML(true);
    if ($mail->Send() == false)
    {
        return false;
        //die($mail->ErrInfo);
    }
    else
    {
        return true;
        //echo "It worked!\n";
    }
}
function randomKey($length, $is_digits, $is_lower, $is_upper) {
    $pool = [];
    if ($is_digits)
    {
        $pool = array_merge($pool, range(0,9));
    }
    if ($is_lower)
    {
        $pool = array_merge($pool, range('a', 'z'));
    }
    if ($is_upper)
    {
        $pool = array_merge($pool, range('A', 'Z'));
    }
    //$pool = array_merge(range(0,9), range('a', 'z'),range('A', 'Z'));
    $key = "";
    for($i=0; $i < $length; $i++) {
        $key .= $pool[mt_rand(0, count($pool) - 1)];
    }
    return $key;
}
?>
