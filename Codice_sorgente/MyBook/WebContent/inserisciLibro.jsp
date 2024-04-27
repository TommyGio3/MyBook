<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="CSS/InsLibroStyle.css">
<meta charset="UTF-8">
<title>Inserisci libro</title>
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
    <h1>Inserimento libro</h1>
    <p>Compila il form per inserire un nuovo libro.</p>
    <hr>

    <label for="titolo"><b>Titolo</b></label>
    <input type="text" id="titolo" placeholder="Inserisci titolo" name="titolo" required>
    
    <label for="autore"><b>Autore</b></label>
    <input type="text" id="autore" placeholder="Inserisci autore" name="autore" onchange="controllaTitoloAutore()" required>
    
    <div class="custom-select" style="width:200px;">
	  <select id="generiSel" name="genereSelect" >
	    <option value="0">Seleziona genere:</option>
	  </select>
	</div>
    
    <label for="descrizione"><b>Descrizione</b></label>
    <input type="text" placeholder="Inserisci descrizione" name="descrizione" required>
    
    <label for="immagine"><b>Immagine</b></label>		
	<input type ="file" placeholder="Inserisci immagine" name="immagine" required/><br>

    <label for="disponibilita"><b>Disponibilità</b></label>
    <input type="number" placeholder="Inserisci disponibilità" name="disponibilita" required >

    <label for="prezzo"><b>Prezzo €</b></label>
    <input type="number" placeholder="Inserisci prezzo" name="prezzo" required>
    
    <div class="custom-select" style="width:200px;">
	  <select id="negoziSel" name="negozioSelect" onchange="ottieniMagazzini()">
	    <option value="0">Seleziona negozio:</option>
	  </select>
	</div>
	<div id="magazziniDiv"class="custom-select" style="width:200px;">
	  <select id="magazziniSel" name="magazzinoSelect">
	    <option value="0">Seleziona magazzino:</option>
	  </select>
	</div>
	
    
    <div class="clearfix">
      <button type="button" class="cancelbtn" onclick="reset()">Cancel</button>
      <button type="button" class="signupbtn" onclick="valida()">Inserisci</button>
    </div>
  </div>
</form>
<script type="text/javascript">
//In caricamento della pagina carica tutti i negozi e i generi 
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
		inserisciGeneri();
};
//Ottieni i magazzini relativi al negozio selezionato
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

//Ottieni tutti i generi
var generiList;
	function inserisciGeneri(){
		var req = new XMLHttpRequest(); 
		req.onreadystatechange = function() {
			if (req.readyState == XMLHttpRequest.DONE && req.status == 200){
				//console.log("Sono nello stato 200");
				generiList = JSON.parse(req.responseText);
				//console.log("lista = " + generiList);
				if(generiList != null){
					var idSel = document.getElementById("generiSel");
					for (gen in generiList){
						//console.log(generiList[gen]);
						idSel.add(new Option ( generiList[gen].tipo, generiList[gen].tipo ) );
					}
				}
			} else if (req.readyState == XMLHttpRequest.DONE){
				alert("ERROR " + req.status + " - " + req.responseText);
			}
		};
		req.open("GET", "ottieniGenere", true);
		//console.log(req);
		req.send();
	};



//Controlla attraverso titolo e autore se il libro è già presente nel catalogo,
//in caso affermativo redireziona alla pagina di inserimento copie
function controllaTitoloAutore() {
	var titolo = document.invio.titolo.value;
	var autore = document.invio.autore.value;
	//console.log("titolo e autore = " + titolo + autore);
	var req = new XMLHttpRequest(); 
	req.onreadystatechange = function() {
		if (req.readyState == XMLHttpRequest.DONE && req.status == 200){
			//console.log("Sono nello stato 200");
			var res = JSON.parse(req.responseText);
			//console.log("risposta= " + res);
			if(res > 0){
				alert("ATTENZIONE: libro già presente nel catalogo, verrai redirezionato alla pagina di inserimento copie");
				window.location.replace("cercaLibro?ISBN=" + res);
			}
		} else if (req.readyState == XMLHttpRequest.DONE){
			alert("ERROR " + req.status + " - " + req.responseText);
		}
	};
	req.open("GET", "validaTitoloAutore?titolo=" + titolo + "&autore=" + autore, true);
	//console.log(req);
	req.send();
};

//Controlla i parametri inseriti e procedi con l'inserimento del libro
function valida() {
   //Variabili associate ai campi del modulo
   var titolo = document.invio.titolo.value;
   var autore = document.invio.autore.value;
   var genere = document.getElementById("generiSel").value;
   var descrizione = document.invio.descrizione.value;
   var disponibilità = document.invio.disponibilita.value;
   var prezzo= document.invio.prezzo.value;
   var idNegozio = document.getElementById("negoziSel").value;
   var idMagazzino = document.getElementById("magazziniSel").value;
   
   
   //Effettua il controllo sul campo titolo
   if ((titolo == "") || (titolo == "undefined")) {
	      alert("Devi inserire un titolo");
	      document.invio.titolo.focus();
	      return false;
	   }
   //Effettua il controllo sul campo autore
   if ((autore == "") || (autore == "undefined")) 
   {
      alert("Devi inserire un autore");
      document.invio.autore.focus();
      return false;
   }
	
   //Effettua il controllo sul campo genere
   if ((genere == "") || (genere == "undefined") || (document.invio.generiSel.value == 0)) 
   {
      alert("Devi inserire un genere");
      document.invio.generiSel.focus();
      return false;
   }
   //Effettua il controllo sul campo descrizione
   if ((descrizione == "") || (descrizione == "undefined")) 
   {
      alert("Devi inserire una descrizione");
      document.invio.descrizione.focus();
      return false;
   }
    //Effettua il controllo sul campo disponibilità
    if ((disponibilità == "") || (disponibilità == "undefined") || (disponibilità < 0)) {
 	      alert("Devi inserire una disponibilità valida");
 	      document.invio.disponibilità.focus();
 	      return false;
 	}
    //Effettua il controllo sul campo prezzo
    if ((prezzo == "") || (prezzo == "undefined") || (prezzo < 0)) {
 	      alert("Devi inserire un prezzo valido");
 	      document.invio.prezzo.focus();
 	      return false;
 	   }
    //Effettua il controllo sul campo negozio
    if ((idNegozio == "") || (idNegozio == "undefined") || (document.invio.negoziSel.value == 0)) 
    {
       alert("Devi inserire un negozio");
       document.invio.negoziSel.focus();
       return false;
    }
    //Effettua il controllo sul campo magazzino
    if ((idMagazzino == "") || (idMagazzino == "undefined") || (document.invio.magazziniSel.value == 0)) 
    {
       alert("Devi inserire un autore");
       document.invio.magazziniSel.focus();
       return false;
    }
    
    else {
      document.invio.action = "creaLibro";
      var r = confirm ("Dati inseriti correttamente, si vuole procedere con l'inserimento del libro?");
      if (r){
    	 document.invio.submit();
      }
   }
};

</script>
</body>
</html>