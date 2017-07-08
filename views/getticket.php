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


<form role="form" action="index.php" method="post">
<?php if(!empty($firms)): ?>
 <div class="form-group">
 <?php 
 if (isset($positions["firms"]))
 {
    gen_dropdown("firm", "Медицинское учреждение:", $firms, $positions["firms"]);    
 }
 else
 {
     gen_dropdown("firm", "Медицинское учреждение:", $firms);
 }
 ?>
  </div>
<?php else: ?>
<div class="alert alert-info">
  К сожалению в данный момент нет доступных медицинских учреждений.
</div>
<?php endif; ?>


<?php if(!empty($departments)): ?>
<div class="form-group">
 <?php
    if (isset($positions["departments"]))
    {
        gen_dropdown("department", "Отделение:", $departments, $positions["departments"]);    
    }
    else
    {
         gen_dropdown("department", "Отделение:", $departments);
    }
 ?>
 </div>
<?php endif; ?>
</form>

<?php if(isset($departments) && empty($departments)): ?>
    <div class="alert alert-info">
      К сожалению для выбранного учреждения отсутствуют подразделения.
    </div>
<?php endif; ?>

<?php if(!empty($workplaces)): ?>
    <div class="form-group">
    <?php
        if (isset($positions["workplaces"]))
        {
            gen_dropdown("workplace", "Врач:", $workplaces, $positions["workplaces"]);    
        }
        else
        {
            gen_dropdown("workplace", "Врач:", $workplaces);
        }
     ?>
     </div>
<?php endif; ?>
</form>

<?php if(isset($departments) && empty($departments)): ?>
<div class="alert alert-info">
  К сожалению для выбранного подразделения отсутствуют врачи.
</div>
<?php endif; ?>