<?php


require("../includes/config.php");

global $iserror, $feedbacks;

$_REQUEST['new-feedback'] = isset($_REQUEST['new-feedback']) ? $_REQUEST['new-feedback'] : null;
$_REQUEST['pacient_name'] = isset($_REQUEST['pacient_name']) ? $_REQUEST['pacient_name'] : null;
$_REQUEST['pacient_feedback'] = isset($_REQUEST['pacient_feedback']) ? $_REQUEST['pacient_feedback'] : null;
$_REQUEST['pacient_email'] = isset($_REQUEST['pacient_email']) ? $_REQUEST['pacient_email'] : null;
$iserror = false;
$captcha_error = false;
$message = "";

if ($_REQUEST['new-feedback']) {


    if ($_REQUEST['g-recaptcha-response']) {
        


        require_once '../vendor/recaptcha/recaptchalib.php';

        $secret = "6LdqRisUAAAAAAvXmBrs3KOVKUCl7dzA08l3IbFu";


        $response = NULL;

        // check secret key
        $reCaptcha = new ReCaptcha($secret);
        $response = $reCaptcha->verifyResponse(
            $_SERVER["REMOTE_ADDR"],
            $_REQUEST['g-recaptcha-response']
        );
        if (!$response->success) {
        
            $captcha_error = 1;
        }

    } else {
        
        $captcha_error = 1;
    }

    if (!$_REQUEST['pacient_name'] || !$_REQUEST['pacient_email'] || !$_REQUEST['pacient_feedback']) {
        $title = "Ошибка!";
        $message = "Не все необходимые поля заполнены.";
        $iserror = true;
        
    } elseif ($captcha_error) {
        
        $title = "Ошибка!";
        $message = "Ошибка капчи - отправьте форму повторно";
        $iserror = true;
    } else {

CS50::query("INSERT INTO feedbacks SET
           pacient_name = ?, pacient_feedback = ?, pacient_email = ?, datetime = ?",$_REQUEST['pacient_name'], $_REQUEST['pacient_feedback'], $_REQUEST['pacient_email'], date("Y-m-d H:i"));
           
            
            $_REQUEST['pacient_name'] =  null;
            $_REQUEST['pacient_feedback'] =  null;
            $_REQUEST['pacient_email'] =  null;
    }
    
    
    
    

//                    $result = CS50::query("UPDATE queues SET person_surname = ?, person_name = ?, person_lastname = ?, date_born = ?, confirm_code = ?, confirm_time = ?  WHERE id = ?  and (confirm_time is NULL or TIMESTAMPDIFF(MINUTE, confirm_time, ? ) >= 20) and cancel_code is NULL", $_GET["surname"], $_GET["name"], $_GET["lastname"], $_GET["dateborn"], $confirmcode, date("Y-m-d H:i:s"),  $_GET["id"], date("Y-m-d H:i:s"));

}
    $feedbacks = CS50::query("SELECT * FROM feedbacks ORDER BY id DESC");
    


    render("feedback_page.php", ["title" => "Отзывы пациентов", "message" => $message, "iserror" => $iserror, 'feedbacks' => $feedbacks]);

?>
