<!--Форма с талоном-->
	<script src="js/jspdf.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/0.4.1/html2canvas.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.3.4/jspdf.debug.js"></script>

	<script type="text/javascript">
        $(window).on('load',function(){
            $('#talonmodal').modal('show');
        });
    	//<!--Функция сохранения талона на комп. с костылями по очиске талона от кнопок-->
		function savepdf() {
	    	//костыль убирает надпись и кнопки
			//document.getElementById("titler").style.display="none";
			//document.getElementById("talon-butt").style.display="none";
			var i=0;
			var getTags=document.getElementsByTagName("div");
			for(i=0; i < getTags.length; i++){
				if (getTags[i].id === "talon"){getTags[i].style.visibility="visible";}
					else {getTags[i].style.visibility="hidden";}
			}
			document.getElementById("talon").style.display="block";
			var namepdf="talon.pdf";
			var value=document.getElementById("talon").TextContent;
			var pdf = new jsPDF("p","pt","a4");
				pdf.addHTML(value, function() {
					pdf.save(namepdf);
					alert("Талон сохраняется на диск");
				});
			//костыль возвращает надпись и кнопки
			//document.getElementById("titler").style.display="block";
			//document.getElementById("talon-butt").style.display="block";
			//document.body.style.display="block";
			for(i=0; i < getTags.length; i++){
				getTags[i].style.visibility="visible";}
			
			
		}
	</script>
	
	
<div class="modal fade" data-keyboard="false" data-backdrop="static" id="talonmodal" tabindex="-1" role="dialog">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<!--                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button> -->
				<div id="titler">
					<center><h4 id="modaltitle" class="modal-title">Запись на прием успешно завершена</h4></center>
            	</div>
            </div>
  
	    	<div class="modal-body">
	  			<!--18/07/17-->
				<div id="talon" class=rows style="width: 400px; height: 300px; border: solid 1px blue; margin-left: 20px; margin-top: 20px;">
					<div style="margin-left: 5px; margin-right: 5px; text-align: center; border-bottom: solid 1px;">
						<h1>Талон №  <?php echo $talondata[0]["id"]; ?></h1>
					</div>
					<div style="margin-left: 10px;">
						
					    <h4><?php echo $talondata[0]["firm"]; ?></h4>
						<h4><?php echo $talondata[0]["doctor"]; ?></h4>
						<div class="container" style="margin-left: 5px; margin-right: 5px;>	
							<div class="row">
								<div class="col-md-4">
									<div style="margin-left: 10px;">
										<h5>ФИО Пациента:</h5>
									</div>
								</div>
								<div class="col-md-8">
									<div style="margin-left: 10px;">
										<h5> Пипец,<?php echo $talondata[0]["client_fio"];?></h5>
									</div>
								</div>
							</div>
							<h5><?php echo $talondata[0]["appointtype"]; ?></h5>
							<div class="row">
								<div class="col-md-4">
									<div style="margin-left: 10px;">
										<h5>Дата Время:</h5>
									</div>
								</div>
								<div class="col-md-8">
									<div style="margin-left: 10px;">
										<h5> <?php echo $talondata[0]["date_time"]; ?></h5>
									</div>
								</div>
							</div>
							<br>
							<div class="row">
								<div class="col-md-4">
									<div style="margin-left: 10px;">
										<h5>Код отмены:</h5>
									</div>
								</div>
								<div class="col-md-8">
									<div style="margin-left: 10px;">
										<h5> <?php echo $talondata[0]["cancel_code"]; ?></h5>
									</div>
								</div>
							</div>
					</div>
				</div>
				
	            <div id="talon-butt" class="form-group">
	                <button type="button" class="btn btn-default" data-dismiss="modal" onclick="window.location='<?php echo (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] != 'off' ? 'https' : 'http')."://".$_SERVER['SERVER_NAME'];  ?>';">Закрыть</button>
	                <button class="btn btn-primary"style="margin-left: 35px; type="save" onclick=savepdf()>
	                    <span aria-hidden="true" class="glyphicon glyphicon-Save"></span> Сохранить в PDF</button>
				</div>
			</div>
		</div>
</div>
</div>