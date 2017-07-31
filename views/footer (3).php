        </div>
        <footer class="container  visible-md visible-lg">
            <div class="panel-group">
            <div class="panel panel-default">
            <div class="panel-heading">
            <div class="row">
                <div class="col-md-3 footer-left">
                    <h5>Онлайн регистратура в медицинских учреждениях г.&nbspКраматорска</h5>
                    <a data-toggle="modal" href="#LicenseModal" title="Лицензии">license</a>
                </div>
                    <?php require("../views/license_form.php");?>
                <div class="col-md-3 footer-middle-left">
                    <h5>Разработано при поддержке</h5>
                            <a href="https://brainbasket.org/ru/technology-nation-3/" target="_blank">
                                <img src="https://brainbasket.org/wp-content/uploads/logo-2.png" style="width: 200px; height: 42px;" alt="BrainBasket Foundation">
                            </a>
                        </div>
                        <div class="col-md-3 footer-middle-right">
                            <h5>Поделиться на своей странице</h5>
                            <?php
                            $url = 'http://e-cherga.pp.ua/index.php';
                            ?>
                            <a href="http://www.facebook.com/sharer.php?s=100&p[url]=<?php echo urlencode( $url ); ?>" onclick="window.open(this.href, this.title, 'toolbar=0, status=0, width=548, height=325'); return false" title="Поделиться ссылкой в Фейсбуке" class="fa fa-facebook-official" style="font-size:42px"></a>
                            &nbsp
                            <!--<a href="#">-->
                            <!--    <i class="fa fa-twitter" style="font-size:42px"></i>-->
                            <!--</a>-->
                            <?php
                            $url = 'http://e-cherga.pp.ua/index.php';
                            $hashtags = 'brain Basket, online-registration Kramatorsk';
                            ?>
                            <a href="http://twitter.com/share?text=<?php echo $title; ?>&via=twitterfeed&related=truemisha&hashtags=<?php echo $hashtags ?>&url=<?php echo $url; ?>" title="Поделиться ссылкой в Твиттере" onclick="window.open(this.href, this.title, 'toolbar=0, status=0, width=548, height=325'); return false" class="fa fa-twitter" style="font-size:42px"></a>

                        </div>
                        <div class="col-md-3 footer-right"> 
                            <p>Свяжитесь с нами</p>
                            <p><span class="glyphicon glyphicon-earphone">:&nbsp</span><b>+38-050-878 36 96</b></p>
                            <p><span class="glyphicon glyphicon-envelope">:&nbsp</span><b>medtalononline@gmail.com</b></p>
                        </div>                    
                </div>
                </div>
                </div>
                </div>
            
        </footer>

        <!-- <footer class="footer-center">
            <div class="panel panel-default">
                <div class="panel-footer">
                    <div class="row">
                        <div class="col-md-5 footer-left">
                            <h5>Онлайн регистратура в медицинских учреждениях г. Краматорска</h5>
                        </div>
                        <div class="col-md-3 footer-middle-left">
                            <h5>Разработано при поддержке</h5>
                            <a href="https://brainbasket.org/ru/technology-nation-3/">
                                <img src="https://brainbasket.org/wp-content/uploads/logo-2.png" style="width: 200px; height: 42px;" alt="BrainBasket Foundation">
                            </a>
                        </div>
                        <div class="col-md-2 footer-middle-right">
                            <h5>Новости проекта</h5>
                            <a href="#">
                                <i class="fa fa-facebook-official" style="font-size:42px"></i>
                            </a>
                            &nbsp
                            <a href="#">
                                <i class="fa fa-twitter" style="font-size:42px"></i>
                            </a>
                        </div>
                        <div class="col-md-2 footer-right">
                            <p>Свяжитесь с нами</p>
                            <p><span class="glyphicon glyphicon-earphone">:&nbsp</span><b>+38-050-878 36 96</b></p>
                            <p><span class="glyphicon glyphicon-envelope">:&nbsp</span>bro@bro.ua</b></p>
                        </div>
                    </div>
                </div>
            </div>
        </footer> -->
    </body>
</html>
