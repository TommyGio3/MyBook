<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="CSS/InsLibroStyle.css">
<meta charset="UTF-8">
<title>Inserisci negozio</title>
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
    <h1>Aggiunta nuovo negozio</h1>
    <p>Compila il form per inserire un nuovo negozio alla catena.</p>
    <hr>

    <label for="nome"><b>Nome</b></label>
    <input type="text" id="nome" placeholder="Inserisci nome" name="nome" required>
    
    <label for="citta"><b>Città</b></label>
    <input type="text" id="citta" placeholder="Inserisci città" name="citta" required>
    
    <label for="indirizzo"><b>Indirizzo</b></label>
    <input type="text" placeholder="Inserisci indirizzo" name="indirizzo" onchange="controllaNomeCitInd()" required>
    
    <div class="clearfix">
      <button type="button" class="cancelbtn" onclick="reset()">Cancel</button>
      <button type="button" class="signupbtn" onclick="valida()">Inserisci</button>
    </div>
  </div>
</form>
<script type="text/javascript">

//Controlla la validità di nome, città e indirizzo
function controllaNomeCitInd() {
	var nome = document.invio.nome.value;
	var città = document.invio.citta.value;
	var indirizzo = document.invio.indirizzo.value;
	var req = new XMLHttpRequest(); 
	req.onreadystatechange = function() {
		if (req.readyState == XMLHttpRequest.DONE && req.status == 200){
			//console.log("Sono nello stato 200");
			var res = JSON.parse(req.responseText);
			//console.log("risposta= " + res);
			if(res){
				alert("ATTENZIONE: il negozio inserito fa già parte della catena");
			}
		} else if (req.readyState == XMLHttpRequest.DONE){
			alert("ERROR " + req.status + " - " + req.responseText);
		}
	};
	req.open("GET", "validaNomeCittaIndirizzo?nome=" + nome + "&citta=" + città + "&indirizzo=" + indirizzo, true);
	//console.log(req);
	req.send();
};

//Controlla il corretto inserimento dei parametri e aggiungi il negozio
function valida() {
   //Variabili associate ai campi del modulo
   var nome = document.invio.nome.value;
   var città = document.invio.citta.value;
   var indirizzo = document.invio.indirizzo.value;
   
   //Effettua il controllo sul campo nome
   if ((nome == "") || (nome == "undefined")) {
	      alert("Devi inserire un nome");
	      document.invio.nome.focus();
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
      document.invio.action = "creaNegozio";
      var r = confirm ("Dati inseriti correttamente, si vuole procedere con l'aggiunta del negozio?");
      if (r){
    	 document.invio.submit();
      }
   }
};

</script>
</body>
</html>