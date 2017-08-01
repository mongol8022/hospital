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
<!-- Модальное окно удаления приема -->
<div class="modal fade" id="appointdelmodal" tabindex="-1" role="dialog">
                  <div class="modal-dialog">
                      <div class="modal-content">
                          <div class="modal-header">
                             <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                              <center><h4 id="modaltitle" class="modal-title">Удаление приёма</h4><center>
                          </div>
                          <div class="modal-body">
                              <div id="appointmodelcontent">
                                  <div class="loader" id="loader2" style="display: none;"></div>
                                  <div id=appointdelformdiv>
                                                    <center>
                                                    <p>Вы действительно хотите удалить приём?</p><br><br>
                                                    <button type="button" id="appointdelbutton" class="btn btn-primary">Удалить</button>
                                                    <button type="button" class="btn btn-default" data-dismiss="modal">Закрыть</button>  
                                                    </center>
                                    </div>
                                </div>
                                   <div id="appointdelmodalmsg"></div>
                                   <div class="alert alert-danger" id="error_msg1" style="display: none;"><span class="glyphicon glyphicon-remove-sign" aria-hidden="true"></span> Ошибка связи с сервером</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

<!-- Модальное окно освобождения приема -->
<div class="modal fade" id="appointfreemodal" tabindex="-1" role="dialog">
                  <div class="modal-dialog">
                      <div class="modal-content">
                          <div class="modal-header">
                             <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                              <center><h4 id="modaltitle" class="modal-title">Освобождение приёма</h4><center>
                          </div>
                          <div class="modal-body">
                              <div id="appointmodalcontent">
                                  <div class="loader" id="loader3" style="display: none;"></div>
                                  <div id=appointfreeformdiv>
                                                    <center>
                                                    <p>Вы действительно хотите освободить приём?</p><br><br>
                                                    <button type="button" id="appointfreebutton" class="btn btn-primary">Освободить</button>
                                                    <button type="button" class="btn btn-default" data-dismiss="modal">Закрыть</button>  
                                                    </center>
                                    </div>
                                </div>
                                   <div id="appointfreemodalmsg"></div>
                                   <div class="alert alert-danger" id="error_msg2" style="display: none;"><span class="glyphicon glyphicon-remove-sign" aria-hidden="true"></span> Ошибка связи с сервером</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

<!-- Модальное окно отмены бронирования -->
<div class="modal fade" id="appointcanlmodal" tabindex="-1" role="dialog">
                  <div class="modal-dialog">
                      <div class="modal-content">
                          <div class="modal-header">
                             <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                              <center><h4 id="modaltitle" class="modal-title">Отмена бронирования приёма</h4><center>
                          </div>
                          <div class="modal-body">
                              <div id="appointmodalcontent">
                                  <div class="loader" id="loader4" style="display: none;"></div>
                                  <div id=appointcanlformdiv>
                                                    <center>
                                                    <p>Вы действительно хотите отменить бронирование приёма?</p><br><br>
                                                    <button type="button" id="appointcanlbutton" class="btn btn-primary">Отменить бронь</button>
                                                    <button type="button" class="btn btn-default" data-dismiss="modal">Закрыть</button>  
                                                    </center>
                                    </div>
                                </div>
                                   <div id="appointcanlmodalmsg"></div>
                                   <div class="alert alert-danger" id="error_msg3" style="display: none;"><span class="glyphicon glyphicon-remove-sign" aria-hidden="true"></span> Ошибка связи с сервером</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
<!--модальное окно записи на прием-->
<div class="modal fade" id="appointmodal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                  <div class="modal-dialog">
                      <div class="modal-content" align="center">
                          <div class="modal-header">
                              <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="get_appoints($('#datetimepicker12').datetimepicker().data('DateTimePicker').date().format('Y-M-D'));">&times;</button>
                              <h4 id="modaltitle" class="modal-title">Запись на прием</h4>
                          </div>
                          <div class="modal-body">
                              <div id="bookingmodalcontent">
                                    <div class="loader" id="loader5" style="display: none;"></div>
                                    <div class="alert alert-danger" id="error_msg4" style="display: none;"><span class="glyphicon glyphicon-remove-sign" aria-hidden="true"></span> Ошибка связи с сервером</div>
                                    <div id="formmodalmsg"></div>
                                    <div id=form_container>
                                    <form id="booking1">
                                        <fieldset>
                                            <div class="form-group">
                                                <input autofocus required class="form-control" name="surname" maxlength="255" style="text-transform: capitalize;" placeholder="Фамилия" type="text"/>
                                            </div>
                                            <div class="form-group">
                                                <input required class="form-control" name="name" maxlength="255" style="text-transform: capitalize;" placeholder="Имя" type="text"/>
                                            </div>
                                            <div class="form-group">
                                                <input required class="form-control" name="lastname" maxlength="255" style="text-transform: capitalize;" placeholder="Отчество" type="text"/>
                                            </div>
                                            <div class="form-group">
                                                <label for="dateborn">Дата рождения</label>
                                                <input required class="form-control" name="dateborn" type="date"/>
                                           </div>
                             <!--         <a name=bookingmodal href="#" class="btn btn-primary" role="button">Записаться</a> -->
                                            <div class="form-group">
                                                <button type="submit" class="btn btn-primary">Записать</button>
                                                <button type="button" class="btn btn-default" data-dismiss="modal">Отмена</button>  
                                            </div>
                                        </fieldset>
                                    </form>
                                    </div>
                                </div>
                            </div>
           				</div> <!-- /.modal-content -->
       				</div> <!-- /.modal-dialog -->
				</div>
<script>
	$('#appointdelmodal').on('shown.bs.modal', function() {
             $("#appointdelformdiv").show();
          });
     $('#appointdelmodal').on('hidden.bs.modal', function () {
     	$("#appointdelmodalmsg").hide();
     	 $('#error_msg1').hide();
     });
    
//})
	$( "#appointdelbutton" ).click(function() {
			$.ajax({
    	        type: 'GET',
        	    url: 'doc_queue.php?action=delappoint',
            	data:  '&id=' + window.queue_id,
            	beforeSend: function() { $('#loader2').show(); $('#appointdelformdiv').hide()},
                complete: function() { $('#loader2').hide(); },
                success: function(data) {
                                   //$("#modaltitle").html("Прием забронирован");
                                    //$("#cancelformdiv").hide();
                     $("#appointdelmodalmsg").html("");
                	 $("#appointdelmodalmsg").html(data);
                     $("#appointdelmodalmsg").show();
                     get_appoints($('#datetimepicker12').datetimepicker().data('DateTimePicker').date().format('Y-M-D'));
                },
                error: function() {
                     $('#error_msg1').show(); 
                }
           });
           return false;
    });
	$('#appointfreemodal').on('shown.bs.modal', function() {
             $("#appointfreeformdiv").show();
          });
     $('#appointfreemodal').on('hidden.bs.modal', function () {
     	$("#appointfreemodalmsg").hide();
     	$('#error_msg2').hide();
     });
     
	$( "#appointfreebutton" ).click(function() {
			$.ajax({
    	        type: 'GET',
        	    url: 'doc_queue.php?action=freeappoint',
            	data:  'id=' + window.queue_id,
            	beforeSend: function() { $('#loader3').show(); $('#appointfreeformdiv').hide()},
                complete: function() { $('#loader3').hide(); },
                success: function(data) {
                                   //$("#modaltitle").html("Прием забронирован");
                                    //$("#cancelformdiv").hide();
                     $("#appointfreemodalmsg").html("");
                	 $("#appointfreemodalmsg").html(data);
                     $("#appointfreemodalmsg").show();
                     get_appoints($('#datetimepicker12').datetimepicker().data('DateTimePicker').date().format('Y-M-D'));
                },
                error: function() {
                     $('#error_msg2').show(); 
                }
           });
           return false;
    });

	$('#appointcanlmodal').on('shown.bs.modal', function() {
             $("#appointfreeformdiv").show();
          });
     $('#appointcanlmodal').on('hidden.bs.modal', function () {
     	$("#appointfreemodalmsg").hide();
     	 $('#error_msg3').hide();
     });
     
	$( "#appointcanlbutton" ).click(function() {
			$.ajax({
    	        type: 'GET',
        	    url: 'doc_queue.php?action=cancelappoint',
            	data:  'id=' + window.queue_id,
            	beforeSend: function() { $('#loader4').show(); $('#appointcanlformdiv').hide()},
                complete: function() { $('#loader4').hide(); },
                success: function(data) {
                                   //$("#modaltitle").html("Прием забронирован");
                                    //$("#cancelformdiv").hide();
                     $("#appointcanlmodalmsg").html("");
                	 $("#appointcanlmodalmsg").html(data);
                     $("#appointcanlmodalmsg").show();
                     get_appoints($('#datetimepicker12').datetimepicker().data('DateTimePicker').date().format('Y-M-D'));
                },
                error: function() {
                     $('#error_msg3').show(); 
                }
           });
           return false;
    });


	$('#appointmodal').on('shown.bs.modal', function() {
             $("#form_container").show();
          });
     $('#appointmodal').on('hidden.bs.modal', function () {
     	$('#formmodalmsg').hide();
     	$('#error_msg4').hide();
     });

$('#booking1').on('submit', function (e) {
                                e.preventDefault();
                                var that = this;
                                $.ajax({
                                type: 'GET',
                                url: 'booking_complete.php',
                                beforeSend: function() { $('#form_container').hide(); $('#loader5').show();},
                                complete: function() { $('#loader5').hide(); },
                                data: $(that).serialize() + '&id=' + window.queue_id,
                               success: function(data) {
                                    $("#formmodalmsg").html("");
                                    $("#formmodalmsg").html(data);
                                    $("#formmodalmsg").show();
                                },
                                error: function() {
                                    $('#error_msg4').show();
                                }
                                });
                                return false;
                                });


    function get_appoints(date_appoint) {
        $.ajax({
        type: 'GET',
        url: 'doc_queue.php?action=getappoints',
        beforeSend: function() { $('#loader1').show(); $('#error_msg').hide(); $('#appoints').hide()},
        complete: function() { $('#loader1').hide()},
        data: 'date=' + date_appoint,
        success: function(data) {
//        alert('Success');
        $("#appoints").html("");
        $("#appoints").html(data);
        $('#appoints').show();
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

$( document ).ready(function() {
    get_appoints($('#datetimepicker12').datetimepicker().data('DateTimePicker').date().format('Y-M-D'));
});
</script>