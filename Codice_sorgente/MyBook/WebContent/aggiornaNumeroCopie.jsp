<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="CSS/AggPrezzoStyle.css">
<meta charset="UTF-8">
<title>Aggiunta numero copie</title>
<style type="text/css">

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

#generiSel, #negoziSel, #magazziniSel {
  width: 100%;
  padding: 15px;
  margin: 5px 0 22px 0;
  display: inline-block;
  border: none;
  background: DodgerBlue;
}

#generiSel:focus, #negoziSel:focus, #magazziniSel.focus {
  background-color: yellow;
  outline: none;
}

#myInput { 
  background-position: 10px 12px; /* Position the search icon */
  background-repeat: no-repeat; /* Do not repeat the icon image */
  width: 100%; /* Full-width */
  font-size: 16px; /* Increase font-size */
  padding: 12px 20px 12px 40px; /* Add some padding */
  border: 1px solid #ddd; /* Add a grey border */
  margin-bottom: 12px; /* Add some space below the input */
}

#myTable {
  border-collapse: collapse; /* Collapse borders */
  width: 100%; /* Full-width */
  border: 1px solid #ddd; /* Add a grey border */
  font-size: 18px; /* Increase font-size */
}

#myTable th, #myTable td {
  text-align: left; /* Left-align text */
  padding: 12px; /* Add padding */
}

#myTable tr {
  /* Add a bottom border to all table rows */
  border-bottom: 1px solid #ddd;
}

#myTable tr.header, #myTable tr:hover {
  /* Add a grey background color to the table header and on hover */
  background-color: #f1f1f1;
}
</style>
</head>
<body>
<div>
	<c:url value="menuAdmin.jsp" var="createMenuUrl"/>
	<form action="${createMenuUrl}"><button id="menuButton" class="button" style="float: right">Menu</button></form>
	<jsp:include page="headerAdmin.jsp" />
</div>
<form method="post" name="invio" style="border:1px solid #ccc" >
  <div class="container">
    <h1>Aggiunta numero copie</h1>
    <p>Seleziona genere, titolo e autore del libro per aggiungere il numero di copie di un libro.</p>
    <hr>
    
 	 <div class="custom-select" style="width:200px;">
	  <select id="generiSel" name="genereSelect" onchange="ottieniTitoli()">
	    <option value="0">Seleziona genere:</option>
	  </select>
	</div>
 
    <div class="custom-select" style="width:200px;">
	  <select id="titoloSel" name="titoloSelect" onchange="ottieniAutori()">
	    <option value="0">Seleziona titolo:</option>
	  </select>
	</div>
	
    <div class="custom-select" style="width:200px;">
	  <select id="autoreSel" name="autoreSelect" onchange="mostraDisponibilita()">
	    <option value="0">Seleziona autore:</option>
	  </select>
	</div>
	
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
	
	<div id="disponibilitaDiv">
	</div>
	
	<label for="disponibilita"><b>Numero di copie da aggiungere</b></label>
    <input type="number" placeholder="Inserisci numero di copie da aggiungere" name="disponibilita" required >
    
    <div class="clearfix">
      <button type="button" class="cancelbtn" onclick="reset()">Cancel</button>
      <button type="button" class="signupbtn" onclick="valida()">Aggiungi</button>
    </div>
  </div>
</form>
<div id ="searchingDiv" class="container">
		<h4>Ricerca un libro per titolo</h4>
		<form class="searching-module" id="formRicerca" name="ricerca" method="post" action="${createUrl}">
			<input id="myInput" type="text" name="inputSearch" placeholder="Cerca per titolo..." onkeyup="cercaLibri()" required>
		</form>
		<div id="risultatiDiv">
		</div>
</div>
<script type="text/javascript">
	//In caricamento della pagina ottieni tutti i generi e i negozi
	var generiList;
	window.onload = function (){
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
		ottieniNegozi();
	};
	
	//Ottieni tutti i negozi
	var negoziList;
	function ottieniNegozi(){
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
	
	//Ottieni i titoli in base al genere selezionato
	var libriByGenereList
	function ottieniTitoli(){
		var titoloSel = document.getElementById("titoloSel");
		while (titoloSel.children[1]) {
		    titoloSel.removeChild(titoloSel.lastElementChild);
		  }
		var genere = document.getElementById("generiSel").value;
		var req = new XMLHttpRequest(); 
		req.onreadystatechange = function() {
			if (req.readyState == XMLHttpRequest.DONE && req.status == 200){
				//console.log("Sono nello stato 200");
				libriByGenereList = JSON.parse(req.responseText);
				//console.log("lista = " + libriByGenereList);
				if(libriByGenereList != null){
					for (lib in libriByGenereList){
						//console.log(libriByGenereList[lib]);
						titoloSel.add(new Option ( libriByGenereList[lib].titolo, libriByGenereList[lib].titolo ) );
					}
				}
			} else if (req.readyState == XMLHttpRequest.DONE){
				alert("ERROR " + req.status + " - " + req.responseText);
			}
		};
		req.open("GET", "ottieniTitolo?genere=" + genere, true);
		//console.log(req);
		req.send();
	};
	
	//Ottieni gli autori in base al titolo
	var libriByTitoloList
	function ottieniAutori(){
		var idAutSel = document.getElementById("autoreSel");
		while (idAutSel.children[1]) {
		    idAutSel.removeChild(idAutSel.lastElementChild);
		  }
		var titolo = document.getElementById("titoloSel").value;
		//console.log(titolo);
		var req = new XMLHttpRequest(); 
		req.onreadystatechange = function() {
			if (req.readyState == XMLHttpRequest.DONE && req.status == 200){
				//console.log("Sono nello stato 200");
				libriByTitoloList = JSON.parse(req.responseText);
				//console.log("lista = " + libriByTitoloList);
				if(libriByTitoloList != null){
					idAutSel = document.getElementById("autoreSel");
					for (lib in libriByTitoloList){
						//console.log(libriByTitoloList[lib]);
						idAutSel.add(new Option ( libriByTitoloList[lib].autore, libriByTitoloList[lib].autore ) );
					}
				}
			} else if (req.readyState == XMLHttpRequest.DONE){
				alert("ERROR " + req.status + " - " + req.responseText);
			}
		};
		req.open("GET", "ottieniAutore?titolo=" + titolo, true);
		//console.log(req);
		req.send();
	};
	
	//Ottieni tutti i magazzini del negozio selezionato
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
	//Crea delle tabelle per ogni libro trovato in base al parametro inserito nella barra di ricerca per titolo
	var ricercaLibriList;
	function cercaLibri(){
		var inputSearch = document.ricerca.inputSearch.value;
		var risultatiDiv = document.getElementById("risultatiDiv");
		while (risultatiDiv.firstChild) {
		    risultatiDiv.removeChild(risultatiDiv.lastChild);
		  }
		//console.log(inputSearch);
		var req = new XMLHttpRequest(); 
		req.onreadystatechange = function() {
			if (req.readyState == XMLHttpRequest.DONE && req.status == 200){
				//console.log("Sono nello stato 200");
				ricercaLibriList = JSON.parse(req.responseText);
				//console.log("lista = " + ricercaLibriList);
				if(ricercaLibriList != null){
					for (lib in ricercaLibriList){
						//console.log(ricercaLibriList[lib]);
						
						var bold = document.createElement("b");
						bold.textContent = ricercaLibriList[lib].titolo;
						var title = document.createElement("p");
						title.appendChild(bold);
						risultatiDiv.appendChild(title);
						
						var table = document.createElement("table");	
						table.id="myTable";
						var thead = document.createElement("thead");
						var tbody = document.createElement('tbody');
						table.appendChild(thead);
						table.appendChild(tbody);
						
						var row_1 = document.createElement("tr");
						row_1.class="header";
						var heading_1 = document.createElement("th");
						heading_1.innerHTML = "Titolo";
						heading_1.style.width="60 %";
						var heading_2 = document.createElement('th');
						heading_2.innerHTML = "Autore";
						heading_2.style.width="40 %";
						var heading_3 = document.createElement('th');
						heading_3.innerHTML = "Disponibilità corrente";
						heading_3.style.width="40 %";
						

						row_1.appendChild(heading_1);
						row_1.appendChild(heading_2);
						row_1.appendChild(heading_3);
						thead.appendChild(row_1);
									
						var tr_table = document.createElement("tr");
						table.appendChild(tr_table);
						
						var td_table_titolo = document.createElement("td");
						td_table_titolo.id="titoloTd";
						td_table_titolo.name="titoloName";
						tr_table.appendChild(td_table_titolo);
						var linkTitolo = document.createElement("a");
						linkTitolo.href="ottieniLibroDaTitoloAggCopie?titolo=" + ricercaLibriList[lib].titolo + "&autore=" + ricercaLibriList[lib].autore;
						linkTitolo.textContent = ricercaLibriList[lib].titolo;
						td_table_titolo.appendChild(linkTitolo);
						
						var td_table_autore = document.createElement("td");
						td_table_autore.id="autoreTd";
						td_table_autore.name="autoreName";
						tr_table.appendChild(td_table_autore);
						td_table_autore.textContent = ricercaLibriList[lib].autore;
						
						var td_table_disponibilita = document.createElement("td");
						tr_table.appendChild(td_table_disponibilita);
						td_table_disponibilita.textContent = ricercaLibriList[lib].disponibilità;
							   
						risultatiDiv.appendChild(table);
								}
							}
							
						
					} else if (req.readyState == XMLHttpRequest.DONE){
						alert("ERROR " + req.status + " - " + req.responseText);
					}
		};
		req.open("GET", "cercaLibro?inputSearch=" + inputSearch, true);
		//console.log(req);
		req.send();
	};
	
	//Mostra la disponibilità corrente del libro selezionato
	function mostraDisponibilita() {
		var disponibilitaDiv = document.getElementById("disponibilitaDiv");
		while (disponibilitaDiv.firstChild) {
		    disponibilitaDiv.removeChild(disponibilitaDiv.lastChild);
		  }
		var h3 = document.createElement("h3");
		disponibilitaDiv.appendChild(h3);
		h3.textContent = "Disponibilità totale corrente: " + libriByTitoloList[lib].disponibilità;
	}
	
	function valida() {
		   //Variabili associate ai campi del modulo
		   var genere = document.getElementById("generiSel").value;
		   var titolo = document.getElementById("titoloSel").value;
		   var autore = document.getElementById("autoreSel").value;
		   var negozio = document.getElementById("negoziSel").value;
		   var idMagazzino = document.getElementById("magazziniSel").value;
		   var copieAgg = document.invio.disponibilita.value;
		   
		   //Effettua il controllo sul campo genere
		   if ((genere == "") || (genere == "undefined") || (document.invio.generiSel.value == 0)) {
			      alert("Devi selezionare un genere");
			      document.invio.generiSel.focus();
			      return false;
			   }
		   //Effettua il controllo sul campo titolo
		   if ((titolo == "") || (titolo == "undefined") || (document.invio.titoloSel.value == 0)) {
			      alert("Devi selezionare un titolo");
			      document.invio.titoloSel.focus();
			      return false;
			   }
		   //Effettua il controllo sul campo autore
		   if ((autore == "") || (autore == "undefined") || (document.invio.autoreSel.value == 0)) {
			      alert("Devi selezionare un autore");
			      document.invio.autoreSel.focus();
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
		    if ((copieAgg == "") || (copieAgg == "undefined") || (copieAgg < 0)) {
		 	      alert("Devi inserire un numero di copie da aggiungere valido");
		 	      document.invio.copieAgg.focus();
		 	      return false;
		 	   }
		    
		    else {
		      document.invio.action = "aggiungiCopie";
		      var r = confirm ("Dati inseriti correttamente, si vuole procedere con l'aggiornamento del prezzo?");
		      if (r){
		    	 document.invio.submit();
		      }
		   }
		};

</script>
</body>
</html>