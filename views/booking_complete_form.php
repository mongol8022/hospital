<!--Форма с талоном-->
	<script type="text/javascript">
	   // src="js/jspdf.js";
	    src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/0.4.1/html2canvas.js";
	    src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.3.4/jspdf.debug.js";
        $(window).on('load',function(){
            $('#talonmodal').modal('show');
        });
    	//<!--Функция сохранения талона на комп.-->
	    	function savepdf() {
		    	var namepdf='talon.pdf';
			    var pdf = new jsPDF('p','pt','a4');
				    pdf.addHTML(document.getElementById("talon").innerHTML, function() {
			    	pdf.save(namepdf);
				    });
		    }
	</script>
	
	
<div class="modal fade" data-keyboard="false" data-backdrop="static" id="talonmodal" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
              <!--                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button> -->
                <center><h4 id="modaltitle" class="modal-title">Запись на прием успешно завершена</h4></center>
            </div>
                          <div class="modal-body">
			<div id="talon" class=rows style="width: 400px; height: 300px; border: solid 1px blue; margin-left: 20px; margin-top: 20px;">
				<div style="margin-left: 5px; margin-right: 5px; text-align: center; border-bottom: solid 1px;">
					
					<h1>Талон №  <?php echo $talondata[0]["id"]; ?></h1>
				</div>
				<div style="margin-left: 10px;">
				    <h3><?php echo $talondata[0]["firm"]; ?></h3>
					<h3>ФИО Врача:<?php echo $talondata[0]["doctor"]; ?></h3>
					<h3>ФИО Пациента: <?php echo $talondata[0]["client_fio"]; ?></h3>
					<h3>отделение:<?php echo $talondata[0]["appointtype"]; ?></h3>
					<h3>Дата Время: <?php echo $talondata[0]["date_time"]; ?></h3>
					<h3>Код отмены: <?php echo $talondata[0]["cancel_code"]; ?></h3>
				</div>
			</div>
            <div class="form-group">
                <button type="button" class="btn btn-default" data-dismiss="modal" onclick="window.location='<?php echo (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] != 'off' ? 'https' : 'http')."://".$_SERVER['SERVER_NAME'];  ?>';">Закрыть</button>
                <button class="btn btn-primary"style="margin-left: 35px; type="save" onclick="savepdf()>
                    <span aria-hidden="true" class="glyphicon glyphicon-Save"></span> Сохранить в PDF</button>
			</div>
		</div>
	</div>
</div>
</div>