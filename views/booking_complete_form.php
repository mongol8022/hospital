<!--Форма с талоном-->
<!DOCTYPE html>
<html>
<head>
	
	<script src="js/jspdf.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/0.4.1/html2canvas.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.3.4/jspdf.debug.js"></script>

	<script type="text/javascript">
        $(window).on('load',function(){
            $('#talonmodal').modal('show');
        });
        
    	//<!--Функция сохранения талона на диск(изодражение видимой части узла 1:1)-->
		function savepdf() {
			html2canvas(document.getElementById("talon"), {
				onrendered:function(canvas) {
					var img=canvas.toDataURL("image/png");
						var doc = new jsPDF();
						doc.addImage(img,'JPEG',20,10);
						doc.save('talon.pdf');
					}
				});
		} 
	</script>

<style type="text/css">

	table {
		border: 2px solid black;
		width: 40%;
		max-width: 400px;
		min-width: 300px;
	}
	
	td, tn {
		padding: 3px; 
		border: 0; 
	}
  </style>
</head>



<body>	


    <!--script src="js/main.js"></script-->

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
		<!--center><h4 id="modaltitle" class="modal-title">Запись на прием успешно завершена</h4></center-->
					
		<center>
			<div id="talon" class="brd">
				<table border="border" cellpadding="0" cellspacing="0">
					</tr>
						<td colspan="2" align="top"><center><?php echo $talondata[0]["firm"]; ?></center></td>
					</tr>
					<tr>
						<td width="20%" max-width=80px><center><img src="../img/snake.jpg" width="30px" height="30px" align="middle" alt="x"></img></center></td>
						<td border="2px" solid black><center> <h3>Талон № _12_</h3></center></td>
					</tr>
					<tr>
						<td><?php echo $talondata[0]["date_time"]; ?></td>
						<td align="right"><?php echo $talondata[0]["appointtype"]; ?></td>
					</tr>
					<tr>
						<td> Отделение:</td>
						<td><?php echo $talondata[0]["department"]; ?></td>
					</tr>
					<tr>
						<td>Врач</td> 
						<td><?php echo $talondata[0]["doctor"]; ?></td>
					</tr>
					<tr>
						<td>Пациент:</td> 
						<td><?php echo $talondata[0]["client_fio"];?></td>
					</tr>
					<tr>
						<td>ID= <?php echo $talondata[0]["id"]; ?></td> 
						<td>код отмены: <?php echo $talondata[0]["cancel_code"]; ?></td>
					</tr>				
					
				</table>
			</div>
			
	        <div id="talon-butt" class="form-group">
	        	<br>
	            <button type="button" class="btn btn-default" data-dismiss="modal" onclick="window.location='<?php echo (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] != 'off' ? 'https' : 'http')."://".$_SERVER['SERVER_NAME'];  ?>';">Закрыть</button>
	            <button class="btn btn-primary"style="margin-left: 35px; type="save" onclick="javascript:savepdf()">
	            <span aria-hidden="true" class="glyphicon glyphicon-Save"></span> Сохранить в PDF</button>
			</div>
		</center>


				
			</div>
		</div>
	</div>
</div>
</body>
