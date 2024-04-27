<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="CSS/InsLibroStyle.css">
<meta charset="UTF-8">
<title>Inserisci magazzino</title>
<style type="text/css">
#negoziSel, #magazziniSel, #generiSel{
  width: 100%;
  padding: 15px;
  margin: 5px 0 22px 0;
  display: inline-block;
  border: none;
  background: DodgerBlue;
}

#negoziSel:focus, #magazziniSel:focus, #generiSel:focus {
  background-color: yellow;
  outline: none;
}

input[type=file]{
  width: 100%;
  padding: 15px;
  margin: 5px 0 22px 0;
  border: none;
  display: inline-block;
  background: #f1f1f1;
}

#menuButton {
  padding: 15px 25px;
  font-size: 24px;
  text-align: center;
  cursor: pointer;
  outline: none;
  color: #fff;
  background-color: #04AA6D;
  border: none;
  border-radius: 15px;
  box-shadow: 0 9px #999;
}

#menuButton:hover {background-color: #3e8e41}

#menuButton:active {
  background-color: #3e8e41;
  box-shadow: 0 5px #666;
  transform: translateY(4px);
}
</style>
</head>
<body style="background-color: #c5bcbc;">
<div>
	<c:url value="menuAdmin.jsp" var="createMenuUrl"/>
	<form action="${createMenuUrl}"><button id="menuButton" class="button" style="float: right">Menu</button></form>
	<jsp:include page="headerAdmin.jsp" />
</div>
<form method="post" name="invio" style="border:1px solid #ccc" enctype="multipart/form-data">
  <div class="container">
    <h1>Aggiunta nuovo magazzino</h1>
    <p>Seleziona un negozio e compila il form per inserire un nuovo magazzino ad un negozio della catena.</p>
    <hr>
    
    <div class="custom-select" style="width:200px;">
	  <select id="negoziSel" name="negozioSelect">
	    <option value="0">Seleziona negozio:</option>
	  </select>
	</div>
    
    <label for="citta"><b>Città</b></label>
    <input type="text" id="citta" placeholder="Inserisci città" name="citta" required>
    
    <label for="indirizzo"><b>Indirizzo</b></label>
    <input type="text" placeholder="Inserisci indirizzo" name="indirizzo" onchange="controllaMagazzino()" required>
    
    <div class="clearfix">
      <button type="button" class="cancelbtn" onclick="reset()">Cancel</button>
      <button type="button" class="signupbtn" onclick="valida()">Inserisci</button>
    </div>
  </div>
</form>
<script type="text/javascript">
//In caricamento della pagina ottieni tutti i negozi
var negoziList;
window.onload = function (){
	var req = new XMLHttpRequest(); 
	req.onreadystatechange = function() {
		if (req.readyState == XMLHttpRequest.DONE && req.status == 200){
			//console.log("Sono nello stato 200");
			negoziList = JSON.parse(req.responseText);
			//console.log("lista = " + negoziList);
			if(negoziList != null){
				var idSel = document.getElementById("negoziSel");
				for (neg in negoziList){
					//console.log(negoziList[neg]);
					idSel.add(new Option ( negoziList[neg].nome, negoziList[neg].idNegozio ) );
				}
			}
		} else if (req.readyState == XMLHttpRequest.DONE){
			alert("ERROR " + req.status + " - " + req.responseText);
		}
	};
	req.open("GET", "ottieniNegozio", true);
	//console.log(req);
	req.send();
};

//Controlla se il magazzino è già presente nel db
function controllaMagazzino() {
	var città = document.invio.citta.value;
	var indirizzo = document.invio.indirizzo.value;
	var req = new XMLHttpRequest(); 
	req.onreadystatechange = function() {
		if (req.readyState == XMLHttpRequest.DONE && req.status == 200){
			//console.log("Sono nello stato 200");
			var res = JSON.parse(req.responseText);
			//console.log("risposta= " + res);
			if(res){
				alert("ATTENZIONE: il magazzino inserito è già presente nel database");
			}
		} else if (req.readyState == XMLHttpRequest.DONE){
			alert("ERROR " + req.status + " - " + req.responseText);
		}
	};
	req.open("GET", "validaMagazzino?citta=" + città + "&indirizzo=" + indirizzo, true);
	//console.log(req);
	req.send();
};

function valida() {
   //Variabili associate ai campi del modulo
   var negozio = document.getElementById("negoziSel").value;
   var città = document.invio.citta.value;
   var indirizzo = document.invio.indirizzo.value;
   
   //Effettua il controllo sul campo negozio
   if ((negozio == "") || (negozio == "undefined") || (document.invio.negoziSel.value == 0)) {
	      alert("Devi selezionare un negozio");
	      document.invio.negoziSel.focus();
	      return false;
	   }
   //Effettua il controllo sul campo città
   if ((città == "") || (città == "undefined")) 
   {
      alert("Devi inserire una città");
      document.invio.città.focus();
      return false;
   }
	
   //Effettua il controllo sul campo indirizzo
   if ((indirizzo == "") || (indirizzo == "undefined")) 
   {
      alert("Devi inserire un indirizzo");
      document.invio.indirizzo.focus();
      return false;
   }
    else {
      document.invio.action = "creaMagazzino";
      var r = confirm ("Dati inseriti correttamente, si vuole procedere con l'aggiunta del magazzino?");
      if (r){
    	 document.invio.submit();
      }
   }
};

</script>
</body>
</html>