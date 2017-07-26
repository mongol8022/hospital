<div class="container">
    <div class="row">
        <div class="col-sm-4">
            <div class="panel panel-default z-depth-2">
                <div class="panel-heading">Дата</div>
                <div class="panel-body">
                    <div class="datetimepicker" id="datetimepicker12" data-date-locale="ru" data-date-inline="true" data-date-format="YYYY-MM-DD"  name="datetimepicker12"></div>    
                    <script type="text/javascript">
                        $('#datetimepicker12').datetimepicker(
                        {
                            inline: true
                        });
                    </script>
                </div>
            </div>
        </div>
        <div class="col-sm-8">
            <div class="panel panel-default">
                <div class="panel-heading">Приёмы</div>
                <div class="panel-body">
                <div class="alert alert-danger" id="error_msg" style="display: none;"><span class="glyphicon glyphicon-remove-sign" aria-hidden="true"></span> Ошибка связи с сервером</div>
                <div class="loader" id="loader1" style="display: none;"></div>
                <div id="appoints"></div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    function get_appoints(date_appoint) {
        $.ajax({
        type: 'GET',
        url: 'doc_queuee.php',
        beforeSend: function() { $('#loader1').show(); $('#error_msg').hide(); $('#appoints').hide()},
        complete: function() { $('#loader1').hide(); $('#appoints').show()},
        data: '&date=' + date_appoint,
        success: function(data) {
        alert('Success');
//        $("#bookingmodalcontent").html("");
//        $("#bookingmodalcontent").html(data);    
        },
        error: function() {
             $('#error_msg').show(); 
        }
        });
        return false;
    };

$('#datetimepicker12').datetimepicker().on('dp.change',function(e) {
    get_appoints($('#datetimepicker12').datetimepicker().data('DateTimePicker').date().format('Y-M-D'));
});
</script>