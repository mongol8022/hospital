<div class="modal fade" id="LoginModal" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <center><h4 id="modaltitle" class="modal-title">Вход</h4></center>
            </div>
                          <div class="modal-body">
                              <div id="modalcontent2">
                                    <form id="login">
                                      <fieldset>
                                         <div class="form-group">
                                            <input autofocus required class="form-control" id="username" name="username" placeholder="Имя пользователя" type="text"/>
                                        </div>
                                        <div class="form-group">
                                            <input required class="form-control" id="password" name="password" placeholder="Пароль" type="password"/>
                                            <a tabindex="-1" href="resetpass.php">Забыли пароль?</a>
                                        </div>
             <!--                           <div class="form-group">
                                            
                                        </div> -->
                                        
                                        <div class="form-group">
                                            <center>
                                            <button type="submit" class="btn btn-primary"><span aria-hidden="true" class="glyphicon glyphicon-log-in"></span> Войти</button>
                                             <button type="button" class="btn btn-default" data-dismiss="modal">Закрыть</button>
                                            </center>
                                        </div>
                                    </fieldset>
                                 </form>
                            </div>
                        </div>
                </div> <!-- /.modal-content -->
            </div> <!-- /.modal-dialog -->
        </div> <!-- /.modal -->
<script  type="text/javascript">
    $('#LoginModal').on('shown.bs.modal', function() {
    });
    $('#username').focus();
                            $('#LoginModal').on('shown.bs.modal', function (e) {
                                if ($('#loginalert')!= null) {
                                         $('#loginalert').remove();
                                }
                            });
                          
                                $('#login').on('submit', function (e) {
                                e.preventDefault();
                                var that = this;
                                $.ajax({
                                type: 'POST',
                                url: 'login.php',
                                data: $(that).serialize(),
                               success: function(data) {
                                    //$("#modaltitle").html("Прием забронирован");
                                    if (data == '')
                                    {
                                        window.location='<?php print (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] != 'off' ? 'https' : 'http'."://".$_SERVER['SERVER_NAME']); ?>';
                                    }
                                    else
                                    {
                                        $('#modalcontent2').prepend('<div id="loginalert" class="alert alert-danger"><span class="glyphicon glyphicon glyphicon-remove-circle" aria-hidden="true"></span> ' + data + '</div>');
                                         //$("#loginalert").hide;
                                    }
                                },
                                error: function() {
                                    alert('Error');
                                }
                                });
                                return false;
                                });

</script>
