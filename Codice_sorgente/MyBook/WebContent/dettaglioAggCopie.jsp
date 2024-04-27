<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="CSS/AggCopieStyle.css">
<meta charset="UTF-8">
<title>Dettaglio aggiunta copie</title>
<style type="text/css">
#negoziSel, #magazziniSel {
  width: 100%;
  padding: 15px;
  margin: 5px 0 22px 0;
  display: inline-block;
  border: none;
  background: green;
}

#negoziSel:focus, #magazziniSel.focus {
  background-color: yellow;
  outline: none;
}
</style>
</head>
<body>
<div>
	<c:url value="menuAdmin.jsp" var="createMenuUrl"/>
	<form action="${createMenuUrl}"><button id="menuButton" class="button" style="float: right">Menu</button></form>
	<jsp:include page="headerAdmin.jsp" />
</div>
<br>
<br>
<br>
<br>
<c:choose>
	<c:when test="${libri.size()>0}">
		<c:forEach var="libro" items="${libri}">
		<div id="myDIV" class="header">
  			<h2>Dettagli del libro '<c:out value="${libro.titolo}"/>'</h2>
		</div>
		 <form method="post" name="invio" style="border:1px solid #ccc" enctype="multipart/form-data">
			<ul id="myUL">
			  <li>ISBN: ${libro.ISBN}</li>
			  <li>Titolo: ${libro.titolo}</li>
			  <li>Autore: ${libro.autore}</li>
			  <li>Disponibilità totale corrente: ${libro.disponibilità}</li>
			  <li>
			  	<label for="copieAgg"><b>Numero di copie da aggiungere</b></label>
    			<input type="number" id="copieAgg" placeholder="Inserisci numero di copie da aggiungere" name="copieAgg" required>
    		  </li>
    		  <li>
    		  	<select id="negoziSel" name="negozioSelect" onchange="ottieniMagazzini()">
			    	<option value="0">Seleziona negozio:</option>
			  </select>
    		  </li>
    		  <li>
	    		  <select id="magazziniSel" name="magazzinoSelect">
				    <option value="0">Seleziona magazzino:</option>
				  </select>
    		  </li>
		  	</ul>
		  	
		  	<div class="clearfix">
      			<button type="button" class="cancelbtn" onclick="reset()">Cancel</button>
      			<button type="button" class="signupbtn" onclick="valida('<c:out value="${libro.titolo}" />', '<c:out value="${libro.autore}" />')">Aggiungi</button>
   		    </div>
		  </form>
		</c:forEach>
	</c:when>
</c:choose>
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
	
	//Ottieni i magazzini del negozio selezionato
	var magazziniList;
	function ottieniMagazzini(){
		var idMagSel = document.getElementById("magazziniSel");
		while (idMagSel.children[1]) {
		    idMagSel.removeChild(idMagSel.lastElementChild);
		  }
		var idNegozio = document.getElementById("negoziSel").value;
		//console.log(idNegozio);
		var req = new XMLHttpRequest(); 
		req.onreadystatechange = function() {
			if (req.readyState == XMLHttpRequest.DONE && req.status == 200){
				//console.log("Sono nello stato 200");
				magazziniList = JSON.parse(req.responseText);
				//console.log("lista = " + magazziniList);
				if(magazziniList != null){
					idMagSel = document.getElementById("magazziniSel");
					for (mag in magazziniList){
						//console.log(magazziniList[mag]);
						idMagSel.add(new Option ( magazziniList[mag].città + " " + magazziniList[mag].indirizzo, magazziniList[mag].idMagazzino ) );
					}
				}
			} else if (req.readyState == XMLHttpRequest.DONE){
				alert("ERROR " + req.status + " - " + req.responseText);
			}
		};
		req.open("GET", "ottieniMagazzino?idNegozio=" + idNegozio, true);
		//console.log(req);
		req.send();
	};
	
	//Controlla la validità dei parametri e aggiungi le copie
	function valida(titolo, autore) {
		   //Variabile associata al campo prezzo del form
		   var copieAgg = document.invio.copieAgg.value;
		   var negozio = document.getElementById("negoziSel").value;
		   var idMagazzino = document.getElementById("magazziniSel").value;
		   
		    //Effettua il controllo sul campo prezzo
		    if ((copieAgg == "") || (copieAgg == "undefined") || (copieAgg < 0)) {
		 	      alert("Devi inserire un numero di copie da aggiungere valido");
		 	      document.invio.copieAgg.focus();
		 	      return false;
		 	   }
		    //Effettua il controllo sul campo negozio
		    if ((negozio == "") || (negozio == "undefined") || (document.invio.negoziSel.value == 0)) {
			      alert("Devi selezionare un negozio");
			      document.invio.negoziSel.focus();
			      return false;
			   }
		    //Effettua il controllo sul campo magazzino
		    if ((idMagazzino == "") || (idMagazzino == "undefined") || (document.invio.magazziniSel.value == 0)) {
		 	      alert("Devi selezionare un magazzino");
		 	      document.invio.magazziniSel.focus();
		 	      return false;
		 	   }
		    
		    else {
		      document.invio.action = "aggiungiCopie?titoloSelect=" + titolo + "&autoreSelect=" + autore + "&disponibilita=" + copieAgg + "&magazzinoSelect=" + idMagazzino;
		      var r = confirm ("Si vuole procedere con l'aggiunta delle copie?");
		      if (r){
		    	 document.invio.submit();
		      }
		   }
		};
	

</script>
</body>
</html>