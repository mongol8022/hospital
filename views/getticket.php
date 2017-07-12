<?php
    function gen_dropdown($name, $label, $values/*и необязательный четвертый параметр позиция*/)
    {
        print("<label for=\"".$name."\">".$label."</label>\n");
        print("<select class=\"form-control\" name=\"".$name."\" id=\"".$name."\" onchange=\"if (this.value>0) { this.form.submit() }\">\n");
        print("<option disabled selected>Ничего не выбрано</option>\n");
        foreach ($values as $element)
        {
            $selected = '';
            if (func_num_args() == 4 && !empty(func_get_arg(3)) && $element["id"] == func_get_arg(3)) 
                { 
                    $selected = "selected ";
                }
            print("<option ".$selected."value=\"".$element["id"]."\">".$element["name"]."</option>\n");
        }
    print("</select>\n");
    }
?>
<div class="container">
    <div class="row">
        <div class="col-md-6">
            <div class="panel panel-default row">
                <div class="panel-heading">Запись на прием</div>
                <div class="panel-body">
                    <form id="appoint" action="index.php" method="post">
                        <input type=hidden id="appointmentdate"
                        <?php 
                            if (isset($positions["cur_date"]))
                            { 
                                print(" value=".$positions["cur_date"]." ");
                            } 
                        ?>
                        name="appointmentdate">
                        <?php if(isset($datasets["firms"])): ?>
                        <div class="form-group">
                            <?php 
                                if (isset($positions["firms"]))
                                {
                                    gen_dropdown("firm", "Медицинское учреждение:", $datasets["firms"], $positions["firms"]);
                                }
                                else
                                {
                                    gen_dropdown("firm", "Медицинское учреждение:", $datasets["firms"]);
                                }
                            ?>
                        </div>
                        <?php else: ?>
                        <div class="alert alert-info">К сожалению в данный момент нет доступных медицинских учреждений.</div>
                        <?php endif; ?>
                        <?php if(isset($datasets["departments"]) && !empty($datasets["departments"])): ?>
                        <div class="form-group">
                            <?php
                                if (isset($positions["departments"]))
                                {
                                    gen_dropdown("department", "Отделение:", $datasets["departments"], $positions["departments"]);
                                }
                                else
                                {
                                    gen_dropdown("department", "Отделение:", $datasets["departments"]);
                                }
                            ?>
                        </div>
                        <?php endif; ?>
    <?php if(isset($datasets["departments"]) && empty($datasets["departments"])): ?>
        <div id="infoalert" class="alert alert-info">
            <span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
              К сожалению для выбранного учреждения отсутствуют подразделения.
        </div>
    <?php endif; ?>

    <?php if(isset($datasets["workplaces"]) && !empty($datasets["workplaces"])): ?>
        <div class="form-group">
            <?php
                if (isset($positions["workplaces"]))
                {
                    gen_dropdown("workplace", "Врач:", $datasets["workplaces"], $positions["workplaces"]);
                }
                else
                {
                    gen_dropdown("workplace", "Врач:", $datasets["workplaces"]);
                }
             ?>
        </div>
    <?php endif; ?>
    <?php if(isset($datasets["workplaces"]) && empty($datasets["workplaces"])): ?>
        <div class="alert alert-info" id="infoalert">
            К сожалению для выбранного подразделения отсутствуют врачи
        </div>
    <?php endif; ?>
    <?php if(isset($positions["cur_date"])): ?> 
        <div class="form-group">
           <div class="panel panel-default">
              <div class="panel-heading"><b>Дата приема</b></div>
                  <div class="panel-body">
                      <div id="datetimepicker12" name="datetimepicker12"></div>
                 </div>
              </div>
              <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                  <div class="modal-dialog">
                      <div class="modal-content">
                          <div class="modal-header">
                              <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                              <h4 class="modal-title">Запись на прием</h4>
                          </div>
                          <div class="modal-body">
                              <div>
                                    <form id="booking" action="booking.php">
                                        <fieldset>
                                            <div class="form-group">
                                                <input autofocus required class="form-control" name="surname" placeholder="Фамилия" type="text"/>
                                            </div>
                                            <div class="form-group">
                                                <input autofocus required class="form-control" name="name" placeholder="Имя" type="text"/>
                                            </div>
                                            <div class="form-group">
                                                <input autofocus required class="form-control" name="lastname" placeholder="Отчество" type="text"/>
                                            </div>
                                            <div class="form-group">
                                                <label for="dateborn">Дата рождения</label>
                                                <input autofocus required class="form-control" name="dateborn" type="date"/>
                                           </div>
                                           <div class="form-group">
                                                <input autofocus required class="form-control" name="email" placeholder="Электронная почта" type="email"/>
                                           </div>
                            <!--         <a name=bookingmodal href="#" class="btn btn-primary" role="button">Записаться</a> -->
                                            <div class="form-group">
                                                <button type="submit" class="btn btn-primary" data-toggle="modal" data-target="#confirm-submit">Записаться</button>
                                                <button type="button" class="btn btn-default" data-dismiss="modal">Отмена</button>  
                                            </div>
                                        </fieldset>
                                    </form>
                                <script type="text/javascript">
                                $(document).on('click', '[type="submit"]', function() {
                                    alert('444');
                                    return false; 
                                    });
                                </script>
                                </div>
                          </div>
                            <!--  <div class="modal-footer">
                                <button type="button" class="btn btn-primary">Записаться</button>
                               
                              </div> -->
                      				</div> <!-- /.modal-content -->';
                 				</div> <!-- /.modal-dialog -->';
           					</div> <!-- /.modal -->';        
                        	<?php 
                            if(isset($datasets["appointments"]) && !empty($datasets["appointments"]))
                            {
                                echo '<div class="panel panel-default" row>';
                                echo '<div class="panel-heading"><b>Доступные приемы</b></div>';
                                echo '<div class="panel-body">';
                                foreach ($datasets["appointments"] as $appointment)
                                    {
                                print("<button type=\"button\" id=\"freeappts\" name=\"".$appointment["id"]."\" data-toggle=\"modal\" data-target=\"#myModal\"  class=\"btn btn-success btn-lg\" role=\"button\" onclick=\"window.queue_id = this.getAttribute('name');\">".$appointment["name"]."</button>\n");
                                    }
                                echo '</div>';
                                echo '</div>';
//                                echo '</div>';
                            }
                            if (isset($datasets["appointments"]) && empty($datasets["appointments"]))
                            {
                                echo '<div id="infoalert" class="alert alert-info">';
                                echo '<span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>';
                                echo 'Отсутствуют доступные приемы';
                                echo '</div>';
                            }
                        ?>
<script type="text/javascript">
       /*        $(function () { */
            $('#datetimepicker12').datetimepicker(
                {
                 inline: true,
                format: 'YYYY-MM-DD',
                minDate: '01.01.2001',
                maxDate: '"<?php print(date('Y-m-d', strtotime("+30 days"))); ?>"',
                defaultDate: '"<?php print($positions["cur_date"]); ?>"',
                locale: 'ru'
                }
/*              $(this).parent('form').submit(); */
            ).on('dp.change',function(e){
            document.getElementById("appointmentdate").value = $('#datetimepicker12').datetimepicker().data('DateTimePicker').date().format('Y-M-D');
            document.getElementById("appoint").submit();
            });
            window.scrollTo(0, document.body.scrollHeight);
/*        }); */
    </script>
        </div>
        <?php endif; ?>
                  </form>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="panel panel-default row">
                <div class="panel-heading">Информация</div>
                    <div class="panel-body">test</div>
            </div>
        </div>
    </div>
</div>
<script>
            $(".alert").delay(4000).slideUp(200, function() {
                $(this).alert('close');
            });
</script>