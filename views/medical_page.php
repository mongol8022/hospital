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
<div class="panel panel-default firms-list">
      <div class="panel-heading">Список медицинских учреждений городa</div>
          <div class="panel-body">
    <?php
    
    if(isset($datasets["firms"])): ?>
        <div class="form-group">
            <?php 
                foreach($datasets['firms'] as $firm){
                    echo '<a  href = "/medical.php?firm='. $firm['id'] .'" class = "firm-box col-xs-4 bg-info">'. $firm['name'] .'</a>';
                }
                
             ?>
        </div>
    <?php endif; ?>


</form>
</div>
</div>
<script>
            $(".alert").delay(4000).slideUp(200, function() {
            $(this).alert('close');
            });
</script>