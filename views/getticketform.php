<?php 
 global $info;
 $info = '<p>Здравствуйте! Вы находитесь на странице сайта, созданного в рамках <a href="https://brainbasket.org/" target="_blank">BrainBasket</a>.</p>'
                    .'Проект разработан в качестве финального задания слушателями курса <a href="https://brainbasket.org/technology-nation/" target="_blank">Technology Nation</a>.</p>'
                    .'<p>С помощью данного сайта появилась возможность заказать талон на прием к врачу через интернет в любое удобно для Вас время!</p>'
                    .'<p>Также на сайте Вы найдете информацию о графике работы врачей и медицинских учреждений г. Краматорск Донецкой обл. с контактной информацией по каждому из них.</p>'
                    .'<p>Спасибо за то, что Вы с нами!</p>' 
                    .'<p>Здоровья Вам и Вашим близким! </p>';
?>
<div class="container">
    <div class="row">
        <div class="col-md-6">
            <div class="panel panel-default z-depth-2">
                <div class="panel-heading">Запись на прием</div>
                <div class="panel-body" id="panel1">
                   <?php if(isset($datasets["firms"])): ?>
                        <div class="form-group" id="firmdiv">
                            <label for="firm">Медицинское учреждение:</label>
                            <select class="form-control" name="firm" id="firm" onchange="if (this.value>0) { change_complete('firmdiv'); }">
                            <option disabled selected>Ничего не выбрано</option>
                            <?php
                                foreach ($datasets["firms"] as $element)
                                {
//                                    if (!empty($positions["firms"]) and $positions["firms"] = $element["id"])
//                                        $selected = "selected ";
                                    echo '<option value="'.$element["id"].'">'.$element["name"].'</option>\n';
                                }
                            ?>
                            </select>
                    <?php else: ?>
                        <div class="alert alert-info">К сожалению в данный момент нет доступных медицинских учреждений.</div>
                    <?php endif; ?>
 
                            <script type="text/javascript">
                                $('#booking1').on('submit', function (e) {
                                e.preventDefault();
                                var that = this;
                                $.ajax({
                                type: 'GET',
                                url: 'booking.php',
                                beforeSend: function() { $('#form_container').hide(); $('#loader1').show();},
                                complete: function() { $('#loader1').hide(); },
                                data: $(that).serialize() + '&id=' + window.queue_id,
                               success: function(data) {
                                    //$("#modaltitle").html("Прием забронирован");
                                    $("#bookingmodalcontent").html("");
                                    $("#bookingmodalcontent").html(data);    
                                },
                                error: function() {
                                    alert('Error');
                                }
                                });
                                return false;
                                });
                            </script>
                           </div>
<!--                   -->
                </div>
            </div>
        </div>
        <div class="col-md-6 visible-md visible-lg"> 
            <div class="panel panel-default">
                <div class="panel-heading">Информация</div>
                    <div id="infopanel">
                        <?php echo $info; ?>
                    </div>
                </div>
            </div>
        </div>  
      </div>
                                 <!-- всплывающее окно с формой заполнения данных для записи на прием -->
                            <div class="modal fade" id="mymodal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                  <div class="modal-dialog">
                      <div class="modal-content" align="center">
                          <div class="modal-header">
                              <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                              <h4 id="modaltitle" class="modal-title">Запись на прием</h4>
                          </div>
                          <div class="modal-body">
                              <div id="bookingmodalcontent">
                                    <div class="loader" id="loader1" style="display: none;"></div>
                                     <div id=msgcontainer></div>
                                    <div id=form_container>
                                    <form id="booking1">
                                        <fieldset>
                                            <div class="form-group">
                                                <input autofocus required class="form-control" id="surname" name="surname" maxlength="255" style="text-transform: capitalize;" placeholder="Фамилия" type="text"/>
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
                                           <div class="form-group">
                                                <input required class="form-control" name="email" maxlength="255" placeholder="Электронная почта" type="email"/>
                                           </div>
                            <!--         <a name=bookingmodal href="#" class="btn btn-primary" role="button">Записаться</a> -->
                                            <div class="form-group">
                                                <button type="submit" class="btn btn-primary">Записаться</button>
                                                <button type="button" class="btn btn-default" data-dismiss="modal">Отмена</button>  
                                            </div>
                                        </fieldset>
                                    </form>
                                    </div>
                                </div>
                            </div>
 <!--                         </div> -->
                            <!--  <div class="modal-footer">
                                <button type="button" class="btn btn-primary">Записаться</button>
                               
                              </div> -->
                      				</div> <!-- /.modal-content -->
                 				</div> <!-- /.modal-dialog -->
           					</div> <!-- /.modal -->
                            <script type="text/javascript">
                                $('#mymodal').on('shown.bs.modal', function() {
                                    $('#surname').focus();
                                    $("#form_container").show();
                                    
                                })
                                $('#mymodal').on('hidden.bs.modal', function() {
                                    $("#msgcontainer").hide();
                                })

                                $('#booking1').on('submit', function (e) {
                                e.preventDefault();
                                var that = this;
                                $.ajax({
                                type: 'GET',
                                url: 'booking.php',
                                beforeSend: function() { $('#form_container').hide(); $('#loader1').show();},
                                complete: function() { $('#loader1').hide(); },
                                data: $(that).serialize() + '&id=' + window.queue_id,
                               success: function(data) {
                                    //$("#modaltitle").html("Прием забронирован");
                                    $("#msgcontainer").html("");
                                    $("#msgcontainer").html(data);
                                    $("#msgcontainer").show();
                                    change_complete("datediv");
                                },
                                error: function() {
                                    alert('Error');
                                }
                                });
                                return false;
                                });
                            </script>
<script>
          
         //   $('#mymodal').on('shown.bs.modal', function () {
         //       $('#mymodal').modal({ backdrop: 'static', keyboard: false });
         //   });
           $(".alert").delay(4000).slideUp(200, function() {
                $(this).alert('close');
            });
//            window.scrollTo(0, document.body.scrollHeight);
    function change_complete(el_name) {
        $("#loader").remove();
        $('#'+ el_name).nextAll('div').remove();
        $( '#' + el_name).append("<div class='loader' id='loader' style='display: none;'></div>");
        var responce_data;
        switch(el_name) {
            case 'firmdiv':
                responce_data = 'firm_id=' + $('#firm').val();
            break;
             case 'departmentdiv':
                responce_data = 'department=' + $('#department').val();
            break;
             case 'workplacediv':
                responce_data = 'workplace=' + $('#workplace').val();
            break;
             case 'datediv':
                responce_data = 'workplace=' + $('#workplace').val() +'&appointmentdate='+ $('#datetimepicker12').datetimepicker().data('DateTimePicker').date().format('Y-M-D');
            break;
        };
        $.ajax({
    	        type: 'GET',
        	    url: 'getticket.php',
            	data: responce_data,
            	beforeSend: function() { $('#loader').show() },
                complete: function() { $('#loader').hide(); },
                success: function(data) {
                if (el_name == 'firmdiv') {
                    //var datahtml = data;
                    $('#infopanel').html("");
                    if ($(data).filter('.text-hosp-information')) {
                        $('#infopanel').html($(data).filter('.text-hosp-information'));
                        $('#infopanel').append($(data).filter('.frame'));
                    }
                    else
                        $('#infopanel').html('<?php echo $info; ?>');
                    $('#panel1').append($(data).filter('#departmentdiv'));
                    
                }
               else
                    $("#panel1").append(data);
                //$("#modaltitle").html("Прием забронирован");
                                    //$("#cancelformdiv").hide();
//                     $("#appointfreemodalmsg").html("");
//                	 $("#appointfreemodalmsg").html(data);
//                     $("#appointfreemodalmsg").show();
//                     get_appoints($('#datetimepicker12').datetimepicker().data('DateTimePicker').date().format('Y-M-D'));
                },
                error: function() {
                     $('#error_msg2').show(); 
                }
           });
//        $('#loader').show();
    };
    
</script>