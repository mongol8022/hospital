<!DOCTYPE html>

<html>

    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0">
        <!-- http://getbootstrap.com/ -->
        <link href="css/bootstrap.min.css" rel="stylesheet"/>

        <link href="css/styles.css" rel="stylesheet"/>

        <?php if (isset($title)): ?>
            <title>Электронная регистратура: <?= htmlspecialchars($title) ?></title>
        <?php else: ?>
            <title>Электронная регистратура</title>
        <?php endif ?>

        <!-- https://jquery.com/ -->
        <script src="/js/jquery-3.2.1.min.js"></script>

        <!-- http://getbootstrap.com/ -->
        <script src="/js/bootstrap.min.js"></script>

        <script src="/js/scripts.js"></script>

        <!-- bootstrap datetimepicker -->
        <script src="/js/moment-with-locales.min.js"></script>
        <script src="/js/bootstrap-datetimepicker.min.js"></script>
        <link href="/css/bootstrap-datetimepicker.min.css" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    </head>

    <body>

        <header class="head-wrap">
            <div class="container">
                <div class="head-cont">
                    <div class="logo">
                            <a href="/index.php" title="Перейти на главную страничку">
                                <img src="img/snake.jpg" alt="#" id="logo">
                            </a>
                    </div>
                    <div>
                        <div class="head-text">
                                <h3>Онлайн-регистратура г.&nbspКраматорска</h3>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <div class="container">            
            <nav class="navbar navbar-default">
                <div class="container-fluid">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>                        
                </button>
                    <div class="collapse navbar-collapse" id="myNavbar">
                    <ul class="nav navbar-nav">
                        <?php if (!empty($_SESSION["user_id"]) && $_SESSION["usertype"] == 'employ'): ?>
                        <?php if ($view == "doc_graphic.php")
                        {
                            print("<li class=\"active\">");
                        }
                        else
                        {
                            print("<li>");
                        }
                        ?>
                        <a href="index.php">Моё расписание</a></li>
                        <?php if ($view == "doc_queue_form.php")
                        {
                            print("<li class=\"active\">");
                        }
                        else
                        {
                            print("<li>");
                        }
                        ?>
                        <a href="doc_queue.php">Мой График приёма</a></li>
                    </ul>
                    <ul class="nav navbar-nav navbar-right">
                           
                            <p class="navbar-text"> <span class="glyphicon glyphicon-user"></span>
                                <?php 
                                if (isset($_SESSION["person"]))
                                {
                                    echo ' '.$_SESSION["person"];
                                }
                                else
                                {
                                    echo ' '.$_SESSION["user_id"];
                                }
                                ?>
                                </p>                        
                         <li><a data-toggle="modal" href="#logoutmodal"><span class="glyphicon glyphicon-log-out"></span> Выйти</a></li>
                    </ul>
                    <?php endif ?>
                    <?php if (!empty($_SESSION["user_id"]) && $_SESSION["usertype"] == 'admin'): ?>
                        <li><a href="schedule.php">Расписания</a></li>
                        <li><a href="livequeue.php">Графики в реальном времени</a></li>
                        <li class="dropdown">
                            <a class="dropdown-toggle" data-toggle="dropdown" href="#">Справочники
                                <span class="caret"></span></a>
                                <ul class="dropdown-menu">
                                    <li><a href="firms.php">Учреждения</a></li>
                                    <li><a href="departments.php">Отделения</a></li>
                                    <li><a href="workplaces.php">Рабочие места</a></li>
                                </ul>
                        </li>
                        <ul class="nav navbar-nav navbar-right">
                            <li><a data-toggle="modal" href="#logoutmodal"><span class="glyphicon glyphicon-log-out"></span> Выйти</a></li>
                        </ul>
                        <?php endif ?>
                        <?php if (empty($_SESSION["user_id"])): ?>
                        <?php
                        if ($view == "getticket.php")
                        {
                            print("<li class=\"active\">");
                        }
                        else
                        {
                            print("<li>");
                        }
                        ?>
                        <a href="index.php"><span class="glyphicon glyphicon-ok"></span> Записаться на прием</a></li>
                        <?php
                        if ($view == "cancel_form.php")
                        {
                            print("<li class=\"active\">");
                        }
                        else
                        {
                            print("<li>");
                        }
                        ?>
                        <a data-toggle="modal" href="#cancelmodal"><span class="glyphicon glyphicon-remove"></span> Отмена приема</a></li>
                        <li
                        <?php
                            if ($view == "medical_page.php")
                            {
                                print(" class=\"active\"");
                            }
                        ?>    
                        ><a href="medical.php"><span class="glyphicon glyphicon-list-alt"></span> Мед. учреждения города</a></li>
                        
                        </ul>
                        
                        <ul class="nav navbar-nav navbar-right">
                        <?php
                        if ($view == "login_form.php")
                        {
                            print("<li class=\"active\">");
                        }
                        else
                        {
                            print("<li>");
                        }
                        ?>
                            <a data-toggle="modal" href="#LoginModal"><span class="glyphicon glyphicon-log-in"></span> Войти</a></li>
                        </ul>
                        <?php endif ?>

                        
                        <ul class="nav navbar-nav navbar-right">
                            <li>
                                <a data-toggle="modal" href="#AboutModal" title="О разработчиках"><span class="glyphicon glyphicon-info-sign"></span> О нас</a>
                            </li>
                        </ul>
                        

                        </div>
                    </div>
                </div>
            </nav>
        </div>

    <?php
    require("../views/about_form.php");
    if (empty($_SESSION["user_id"]))
        {
            require("../views/login_form.php");
            require("../views/cancel_modal.php");
        }
    else 
        {
            require("../views/logout_form.php");
        }
        ?>
        <!--            <div id="middle"> -->
