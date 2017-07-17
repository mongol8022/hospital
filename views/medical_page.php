<script>
var slideNow = 1;
var slideCount = $('#slidewrapper').children().length;
var slideInterval = 3000;
var navBtnId = 0;
var translateWidth = 0;

$(document).ready(function() {
    var switchInterval = setInterval(nextSlide, slideInterval);

    $('#viewport').hover(function() {
        clearInterval(switchInterval);
    }, function() {
        switchInterval = setInterval(nextSlide, slideInterval);
    });

    $('#next-btn').click(function() {
        nextSlide();
    });

    $('#prev-btn').click(function() {
        prevSlide();
    });

    $('.slide-nav-btn').click(function() {
        navBtnId = $(this).index();

        if (navBtnId + 1 != slideNow) {
            translateWidth = -$('#viewport').width() * (navBtnId);
            $('#slidewrapper').css({
                'transform': 'translate(' + translateWidth + 'px, 0)',
                '-webkit-transform': 'translate(' + translateWidth + 'px, 0)',
                '-ms-transform': 'translate(' + translateWidth + 'px, 0)',
            });
            slideNow = navBtnId + 1;
        }
    });
});

function nextSlide() {
    if (slideNow == slideCount || slideNow <= 0 || slideNow > slideCount) {
        $('#slidewrapper').css('transform', 'translate(0, 0)');
        slideNow = 1;
    } else {
        translateWidth = -$('#viewport').width() * (slideNow);
        $('#slidewrapper').css({
            'transform': 'translate(' + translateWidth + 'px, 0)',
            '-webkit-transform': 'translate(' + translateWidth + 'px, 0)',
            '-ms-transform': 'translate(' + translateWidth + 'px, 0)',
        });
        slideNow++;
    }
}

function prevSlide() {
    if (slideNow == 1 || slideNow <= 0 || slideNow > slideCount) {
        translateWidth = -$('#viewport').width() * (slideCount - 1);
        $('#slidewrapper').css({
            'transform': 'translate(' + translateWidth + 'px, 0)',
            '-webkit-transform': 'translate(' + translateWidth + 'px, 0)',
            '-ms-transform': 'translate(' + translateWidth + 'px, 0)',
        });
        slideNow = slideCount;
    } else {
        translateWidth = -$('#viewport').width() * (slideNow - 2);
        $('#slidewrapper').css({
            'transform': 'translate(' + translateWidth + 'px, 0)',
            '-webkit-transform': 'translate(' + translateWidth + 'px, 0)',
            '-ms-transform': 'translate(' + translateWidth + 'px, 0)',
        });
        slideNow--;
    }
}
</script>

<div class="container">
    <div class="row">
        <div class="col-md-6">
            <div class="panel panel-default">
                <div class="panel-heading">Перечень медицинских учреждений г. Краматорска</div>
                <div class="panel-body">
                    <div class="list-group">
                        <a href="kmu_hosp1.php" class="list-group-item">Коммунальное медицинское учреждение 
                        "Городская больница №1"</a>
                        <a href="#" class="list-group-item">Коммунальное медицинское учреждение 
                        "Городская больница №2"</a>
                        <a href="#" class="list-group-item">Коммунальное медицинское учреждение 
                        "Городская больница №3"</a>
                        <a href="#" class="list-group-item">Коммунальное учреждение "Центр 
                        первичной медико-санитарной помощи № 2 г.Краматорска"</a>
                        <a href="#" class="list-group-item">Коммунальное медицинское учреждение 
                        «Стоматологическая поликлиника № 1»</a>
                        <a href="#" class="list-group-item">Коммунальное медицинское учреждение 
                        «Стоматологическая поликлиника № 2»</a>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div id="block-for-slider">
        <div id="viewport">
            <ul id="slidewrapper">
                <li class="slide"><img src="img/img1.jpg" alt="1" class="slide-img"></li>
                <li class="slide"><img src="img/img2.jpg" alt="2" class="slide-img"></li>
                <li class="slide"><img src="img/img3.jpg" alt="3" class="slide-img"></li>
                <li class="slide"><img src="img/img4.jpg" alt="4" class="slide-img"></li>
            </ul>
            <ul id="nav-btns">
                <li class="slide-nav-btn"></li>
                <li class="slide-nav-btn"></li>
                <li class="slide-nav-btn"></li>
                <li class="slide-nav-btn"></li>
            </ul>
        </div>
    </div>
        </div>
    </div>
</div>