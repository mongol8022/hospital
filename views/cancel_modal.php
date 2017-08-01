<div class="modal fade" id="cancelmodal" tabindex="-1" role="dialog">
                  <div class="modal-dialog">
                      <div class="modal-content" align="center">
                          <div class="modal-header">
                             <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                              <h4 id="modaltitle" class="modal-title">Отмена записи на прием</h4>
                          </div>
                          <div class="modal-body">
                              <div id="cancelmodalcontent">
                                  <div id=cancelformdiv>
                                        <form id="cancelform1">
                                            <fieldset>
                                                <div class="form-group">
                                                    <input autofocus required class="form-control" id="cancelcode" name="cancelcode" min="1" max="9999999999" placeholder="Введите код отмены записи на приём" type="number"/>
                                                </div>
                                                <div class="form-group">
                                                    <button type="submit" class="btn btn-primary">Отменить прием</button>
                                                    <button type="button" class="btn btn-default" data-dismiss="modal">Закрыть</button>
                                                </div>
                                            </fieldset>
                                        </form>
                                    </div>
                                    <div id = cancelmsg></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
<script>
$('#cancelmodal').on('shown.bs.modal', function() {
             $("#cancelmsg").hide();
             $("#cancelcode").val("");
             $("#cancelformdiv").show();
             $('#cancelcode').focus();
          });
          $('#cancelform1').on('submit', function (e) {
                                e.preventDefault();
                                var that = this;
                                $.ajax({
                                type: 'GET',
                                url: 'cancellation.php',
                                data: $(that).serialize(),
                               success: function(data) {
                                    //$("#modaltitle").html("Прием забронирован");
                                    $("#cancelformdiv").hide();
                                    $("#cancelmsg").html("");
                                    $("#cancelmsg").html(data);
                                    $("#cancelmsg").show();
                                },
                                error: function() {
                                    alert('Error');
                                }
                                });
                                return false;
                                });
</script>
