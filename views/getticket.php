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
                    <form action="index.php" method="post">
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
                        <div id="infoalert" class="alert alert-info">К сожалению для выбранного учреждения отсутствуют подразделения.</div>
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
                        <div class="alert alert-info" id="infoalert">К сожалению для выбранного подразделения отсутствуют врачи.</div>
                        <?php endif; ?>
                        <?php if(isset($positions["cur_date"])): ?> 
                        <div class="form-group">
                            <div class="panel panel-default">
                                <div class="panel-heading"><b>Дата приема</b></div>
                                <div class="panel-body">
                                    <div id="datetimepicker12"></div>
                                </div>
                            </div>
                        </div>
                        <script type="text/javascript">
                            $(function () {
                                $('#datetimepicker12').datetimepicker({
                                    inline: true,
                                    sideBySide: true,
                                    format: 'DD.MM.YYYY',
                                    minDate: moment(),
                                    maxDate: moment().add(30, 'days'),
                                    locale: 'ru'
                                });
                            });
                        </script>
                        <?php endif; ?>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-md-6">
                    
        </div>
    </div>
</div>

<script>
    $(".alert").delay(4000).slideUp(200, function() {
    $(this).alert('close');
    });
</script>