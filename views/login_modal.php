                             <!-- всплывающее окно с формой заполнения данных для записи на прием -->
                            <div class="modal fade" data-keyboard="false" data-backdrop="static" id="mymodal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                  <div class="modal-dialog">
                      <div class="modal-content">
                          <div class="modal-header">
              <!--                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button> -->
                              <h4 id="modaltitle" class="modal-title">Запись на прием</h4>
                          </div>
                          <div class="modal-body">
                              <div id="bookingmodalcontent">
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
 <!--                         </div> -->
                            <!--  <div class="modal-footer">
                                <button type="button" class="btn btn-primary">Записаться</button>
                               
                              </div> -->
                      				</div> <!-- /.modal-content -->
                 				</div> <!-- /.modal-dialog -->
           					</div> <!-- /.modal -->
                            <script type="text/javascript">
                                $('#booking1').on('submit', function (e) {
                                e.preventDefault();
                                var that = this;
                                $.ajax({
                                type: 'GET',
                                url: 'booking.php',
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