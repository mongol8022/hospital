<!DOCTYPE html>

<html>

    <head>
        <meta charset="UTF-8">

        <!-- http://getbootstrap.com/ -->
        <link href="/css/bootstrap.min.css" rel="stylesheet"/>

        <link href="/css/styles.css" rel="stylesheet"/>

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
        <script src="/js/moment.min.js"></script>
        <script src="/js/bootstrap-datetimepicker.min.js"></script>
        <link href="/css/bootstrap-datetimepicker.min.css" rel="stylesheet"/>
    </head>

    <body>

        <div class="container">

            <div id="top">
                    <a href="/"><img alt="C$50 Finance" src="/img/logo.png"/></a>
                </div>
                    <nav class="navbar navbar-default">
                      <div class="container-fluid">
                         <ul class="nav navbar-nav">
                <?php if (!empty($_SESSION["user_id"]) && $_SESSION["usertype"] = 'employ'): ?>
                        <li><a href="schedule.php">Моё расписание</a></li>
                        <li><a href="livequeue.php">График в реальном времени</a></li>
                    </ul>
                    <ul class="nav navbar-nav navbar-right">
                         <li><a href="#"><span class="glyphicon glyphicon-log-out"></span> Выйти</a></li>
                    </ul>
                <?php endif ?>
                <?php if (!empty($_SESSION["user_id"]) && $_SESSION["usertype"] = 'admin'): ?>
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
                        <li><a href="logout.php"><strong>Выйти</strong></a></li>
                    </ul>
                    <ul class="nav navbar-nav navbar-right">
                         <li><a href="#"><span class="glyphicon glyphicon-log-out"></span> Выйти</a></li>
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
                         <a href="cancellation.php"><span class="glyphicon glyphicon-remove"></span> Отмена приема</a></li>
                        <li><a href="medical.php"><span class="glyphicon glyphicon-list-alt"></span> Мед. учреждения города</a></li>
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
                             <a href="login.php"><span class="glyphicon glyphicon-log-in"></span> Войти</a></li>
                        </ul>
                <?php endif ?>
                    </div>
                </nav>
<!--            <div id="middle"> -->
