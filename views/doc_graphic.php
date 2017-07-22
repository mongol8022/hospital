<!-- <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>My First Grid</title> -->
 
<link rel="stylesheet" type="text/css" media="screen" href="jqgrid/css/ui-redmond/jquery-ui.theme.min.css" />
<link rel="stylesheet" type="text/css" media="screen" href="jqgrid/css/ui.jqgrid.css" />

<!-- 
<style type="text/css">
html, body {
    margin: 0;
    padding: 0;
    font-size: 75%;
}
</style> -->
 
<script src="jqgrid/js/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src="jqgrid/js/i18n/grid.locale-ru.js" type="text/javascript"></script>
<script src="jqgrid/js/jquery.jqGrid.min.js" type="text/javascript"></script>
 
<div class="container"> 
<script type="text/javascript">
$(function () {
    $("#list").jqGrid({
        url: "graph_grid.php",
        datatype: "xml",
        mtype: "GET",
        colNames: ["Тип приёма", "День недели", "Время начала", "Количество", "Действительно с", "Действительно по","id", "Тип приёма", "workplace_id", "День недели"],
        colModel: [
            { name: "service" },
            { name: "weekday_name" },
            { name: "time_begin", align: 'center', editable:true, editrules:{required:true } },
            { name: "count", align: 'center', editable:true, editrules:{required:true } },
            { name: "valid_from", align: 'center', editable:true, sorttype:'date', formatter: 'date', formatoptions: {newformat: 'd.m.Y'}, editrules:{required: true} },
            { name: "valid_to", align: 'center', editable:true, sorttype:'date', formatter: 'date', formatoptions: {newformat: 'd.m.Y'} },
            { name: "id", hidden: true },
            { name: "service_id", hidden: true, editable: true, editrules:{edithidden: true, required: true } },
            { name: "worplace_id", hidden: true, editable: true, editrules:{edithidden: true, required: true } },
            { name: "week_day", hidden: true, editable: true, editrules:{edithidden: true, required:true } }
        ],
        pager: "#pager",
        rowNum: 10,
        rowList: [10, 20, 30],
        sortname: "id",
        sortorder: "asc",
        viewrecords: true,
        gridview: true,
        autowidth: true,
        height: "auto",
        autoencode: true,
        caption: "Расписание приема: ",
        loadonce: true,
        sortable: true,
        loadComplete: function () {
        var $self = $(this);
        if ($self.jqGrid("getGridParam", "datatype") === "xml") {
            setTimeout(function () {
                $self.trigger("reloadGrid"); // Call to fix client-side sorting
            }, 50);
        }
    }
    }); 
}); 

$(window).on("resize", function () {
    var $grid = $("#list"),
        newWidth = $grid.closest(".ui-jqgrid").parent().width();
    $grid.jqGrid("setGridWidth", newWidth, true);
});
</script>
 
</head>
<body>
    <table id="list"><tr><td></td></tr></table> 
    <div id="pager"></div> 
</div>
<br>