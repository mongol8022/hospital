<script>
function feedback_submit(){
    jQuery('#feedback-form').submit()
}


</script>
<script src='https://www.google.com/recaptcha/api.js'></script>
<div class="container">
    <div class="row">
        <div class="col-xs-12 col-sm-6 ">
            <div class="panel panel-default">
                <div class="panel-heading">Оставить отзыв</div>
                <div class="panel-body">
                    <form id = "feedback-form" method = "post" >
                        <?php if(isset($iserror) && $iserror){
                        echo '<div class="alert alert-danger">
  <strong>Внимание!</strong> '. $message .'
</div>';
                            
                      } elseif($_REQUEST['new-feedback']){
                                        echo '<div class="alert alert-success">
  <strong>Спасибо!</strong> Ваш отзыв успешно добавлен.
</div>';
                        } ?>
                        <input type = "hidden" value = '1' name = 'new-feedback' >
                        
                        <div>
                            <div class = "row" >
                                <label class = "col-xs-4">Ваше имя<span class="mandatory">*</span>:</label>
                                <input class = "col-xs-8" type = "text" value = "<?=$_REQUEST['pacient_name']; ?>" name = "pacient_name" />
                                
                                
                            </div>
                            <div class = "row"  >
                                <label class = "col-xs-4">Ваш имэйл<span class="mandatory">*</span>:</label>
                                <input class = "col-xs-8" type = "text"  value = "<?=$_REQUEST['pacient_email']; ?>" name = "pacient_email" />
                                
                                
                            </div>
                            <div class = "row"  >
                                <label class = "col-xs-4">Отзыв<span class="mandatory">*</span>:</label>
                                <textarea  class = "col-xs-8" name = "pacient_feedback"><?=$_REQUEST['pacient_feedback']; ?></textarea>
                                
                                
                                
                            </div>
                            
                            <div  class = "row align-center" >
                                
                                <div class="g-recaptcha" data-sitekey="6LdqRisUAAAAAEhNIcdTxkp90khXePKc1t6dTBeM"></div>
                                
                            </div>
                            <div>
                                <button type = "submit" 

class = 'btn btn-primary '>Оставить отзыв</button>
                                
                            </div>
                            
                            
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-xs-12 col-sm-6 feedbacks">
            <div class="panel panel-default">
                <div class="panel-heading">Отзывы пациентов</div>
                <div class="panel-body">
                    <?php
                    
                    foreach($feedbacks as $feedback){
                        
                        
                        
                        echo "<div class = 'row'>
                        <div class = 'pacient-name'><strong>". ucfirst($feedback['pacient_name'])  ."</strong></div>
                        <div class = 'feedback-date'><small class = 'info'>". $feedback['datetime']  ."</small></div>
                        <div  class = 'pacient-feedback'>". $feedback['pacient_feedback']  ."</div>
                        </div>";
                    }
                    
                    
                    ?>
                    
                </div>
            </div>
    </div>
        </div>
    </div>
</div>