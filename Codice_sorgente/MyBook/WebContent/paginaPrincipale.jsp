<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="cookieUtils.js" ></script>
<link rel="stylesheet" type="text/css" href="CSS/StyleRules.css">
<meta charset="UTF-8">
<title>Homepage</title>
<style type="text/css">
	#loggedAs{
		color: white;
	}
	.topnav {
	font-family: Helvetica, sans-serif;
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

#myTable, #myTable2 {
  border-collapse: collapse; /* Collapse borders */
  width: 100%; /* Full-width */
  border: 1px solid #ddd; /* Add a grey border */
  font-size: 18px; /* Increase font-size */
}

#myTable th, #myTable td, #myTable2 th, #myTable2 td {
  text-align: left; /* Left-align text */
  padding: 8px; /* Add padding */
}

#myTable tr, #myTable2 tr {
  /* Add a bottom border to all table rows */
  border-bottom: 1px solid #ddd;
}

#myTable tr.header, #myTable td:hover, #myTable2 tr.header, #myTable2 td:hover {
  /* Add a grey background color to the table header and on hover */
  background-color: #f1f1f1;
}

body {
	margin-top: 0px;
	margin-left: 0px;
	margin-right: 0px;
}
</style>
</head>
<body>
	<div class="topnav">
	  <a class="active" href="paginaPrincipale.jsp">Home</a>
	  <a href="profilo.jsp">Profilo</a>
	  <a href="contatti.jsp">Contatti</a>
	  <a href="about.jsp">About</a>
	  <jsp:include page="header.jsp" />
	  <form class="searching-module" id="formRicerca" name="ricerca" method="post" action="${createUrl}">
	  	<input type="text" id="search" name = "inputSearch" placeholder="Cerca per titolo..." onkeyup="cercaLibri()">
	  </form>
	</div>
	<div id="risultatiDiv">
	</div>
	<div id="listaLibri">
	</div>
<script type="text/javascript">
//Mostra i libri in base all'input di ricerca
var ricercaLibriList;
function cercaLibri(){
	var inputSearch = document.ricerca.inputSearch.value;
	var risultatiDiv = document.getElementById("risultatiDiv");
	risultatiDiv.style = "overflow-x:auto";
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
				var table = document.createElement("table");	
				table.id="myTable";
				
				var thead = document.createElement("thead");
				var tbody = document.createElement('tbody');
				table.appendChild(thead);
				table.appendChild(tbody);
				var bold = document.createElement("b");
				bold.textContent = "Risultati ricerca";
				var title = document.createElement("p");
				title.appendChild(bold);
				risultatiDiv.appendChild(title);
				var row_1 = document.createElement("tr");
				row_1.class="header";
				thead.appendChild(row_1);
				
				var tr_table = document.createElement("tr");
				table.appendChild(tr_table);
				
				for (lib in ricercaLibriList){
					//console.log(ricercaLibriList[lib]);
					
					var td_table_immagine = document.createElement("td");
					tr_table.appendChild(td_table_immagine);
					var img = document.createElement("img");
					img.style.width="220px";
					img.src="data:image/jpeg;base64," + ricercaLibriList[lib].immagine;
					td_table_immagine.appendChild(img);
					var pLink = document.createElement("p");
					var linkTitolo = document.createElement("a");
					linkTitolo.href="ottieniLibroDaTitoloPagPrinc?titolo=" + ricercaLibriList[lib].titolo + "&autore=" + ricercaLibriList[lib].autore;
					linkTitolo.textContent = ricercaLibriList[lib].titolo;
					pLink.appendChild(linkTitolo);
					td_table_immagine.appendChild(pLink);
					var pAutore = document.createElement("p");
					pAutore.textContent = ricercaLibriList[lib].autore;
					td_table_immagine.appendChild(pAutore);
					var pGenere = document.createElement("p");
					pGenere.textContent = ricercaLibriList[lib].genere;
					td_table_immagine.appendChild(pGenere);
					var pDisponibilità = document.createElement("p");
					if(ricercaLibriList[lib].disponibilità <= 0){
						pDisponibilità.textContent = "ESAURITO";
						pDisponibilità.style.color = "red";
					}
					else{
						pDisponibilità.textContent = "Disponibilità: " + ricercaLibriList[lib].disponibilità;
					}
					td_table_immagine.appendChild(pDisponibilità);
					var pPrezzo = document.createElement("p");
					bPrezzo = document.createElement("b");
					bPrezzo.textContent = ricercaLibriList[lib].prezzo + "€";
					pPrezzo.appendChild(bPrezzo);
					td_table_immagine.appendChild(pPrezzo);
					
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




var favGenList;

//In caricamento della pagina controlla se esiste il cookie contenente
//i generi preferiti; se non esiste e quindi è uguale a null allora chiama
//la funzione che mi mostra 20 libri a caso, altrimenti se esiste e quindi
//è diverso da null, chiama la funzione che mi mostra i libri dei generi preferiti
window.onload = function () {
	var username = "<c:out value="${currentUser.username}" />";
	var genCookie = checkCookie(username + "_genList");
	if(genCookie == null){
		showRandomBooks();
	}
	else {
		showFavouriteBooks(username);
	}
}

//Manda una richiesta a /ottieniLibro per ottenere tutti i libri e poi chiama
//la funzione showList a cui passa lo username
function showFavouriteBooks (username){
	var req = new XMLHttpRequest(); 
	req.onreadystatechange = function() {
		if (req.readyState == XMLHttpRequest.DONE && req.status == 200){
			//parse da json a array
			libriList = JSON.parse(req.responseText);
			showList(username);
		} else if (req.readyState == XMLHttpRequest.DONE){
			alert("ERROR " + req.status + " - " + req.responseText);
		}
	};
	req.open("GET", "ottieniLibro");
	req.send();
};

//Mostra la lista di libri che appartengono ai generi preferiti confrontando
//i generi della lista di tutti i libri con i generi preferiti contenuti nel cookie
function showList (username){
	var json_str = getCookie(username + "_genList");
	var genList = JSON.parse(json_str);
	
	var listaLibriDiv = document.getElementById("listaLibri");
	listaLibriDiv.style = "overflow-x:auto";
	
	var table = document.createElement("table");	
	table.id="myTable2";
	
	var thead = document.createElement("thead");
	var tbody = document.createElement('tbody');
	table.appendChild(thead);
	table.appendChild(tbody);
	var bold = document.createElement("b");
	bold.textContent = "I tuoi generi preferiti";
	var title = document.createElement("p");
	title.appendChild(bold);
	listaLibriDiv.appendChild(title);
	var row_1 = document.createElement("tr");
	row_1.class="header";
	thead.appendChild(row_1);
	
	var tr_table = document.createElement("tr");
	table.appendChild(tr_table);
		//Scorri la lista di tutti i libri
		for (var j=0; j < libriList.length; j++ ){
			var currGen = libriList[j].genere.toString();
			//Mostra solo i libri il cui genere è incluso nel cookie
			if(genList.includes(currGen)){
				
				var td_table_immagine = document.createElement("td");
				tr_table.appendChild(td_table_immagine);
				var img = document.createElement("img");
				img.style.width="220px";
				img.src="data:image/jpeg;base64," + libriList[j].immagine;
				td_table_immagine.appendChild(img);
				var pLink = document.createElement("p");
				var linkTitolo = document.createElement("a");
				linkTitolo.href="ottieniLibroDaTitoloPagPrinc?titolo=" + libriList[j].titolo + "&autore=" + libriList[j].autore;
				linkTitolo.textContent = libriList[j].titolo;
				pLink.appendChild(linkTitolo);
				td_table_immagine.appendChild(pLink);
				var pAutore = document.createElement("p");
				pAutore.textContent = libriList[j].autore;
				td_table_immagine.appendChild(pAutore);
				var pGenere = document.createElement("p");
				pGenere.textContent = libriList[j].genere;
				td_table_immagine.appendChild(pGenere);
				var pDisponibilità = document.createElement("p");
				if(libriList[j].disponibilità <= 0){
					pDisponibilità.textContent = "ESAURITO";
					pDisponibilità.style.color = "red";
				}
				else{
					pDisponibilità.textContent = "Disponibilità: " + libriList[j].disponibilità;
				}
				td_table_immagine.appendChild(pDisponibilità);
				var pPrezzo = document.createElement("p");
				bPrezzo = document.createElement("b");
				bPrezzo.textContent = libriList[j].prezzo + "€";
				pPrezzo.appendChild(bPrezzo);
				td_table_immagine.appendChild(pPrezzo);
				
				listaLibriDiv.appendChild(table);
				
			}
		}
		
};

//Mostra una lista di 20 libri random
var ranLibriList;
function showRandomBooks (){
	var listaLibriDiv = document.getElementById("listaLibri");
	listaLibriDiv.style = "overflow-x:auto";
	while (listaLibriDiv.firstChild) {
	    listaLibriDiv.removeChild(listaLibriDiv.lastChild);
	  }
	var req = new XMLHttpRequest(); 
	req.onreadystatechange = function() {
		if (req.readyState == XMLHttpRequest.DONE && req.status == 200){
			//console.log("Sono nello stato 200");
			ranLibriList = JSON.parse(req.responseText);
			//console.log("lista = " + ranLibriList);
			if(ranLibriList != null){
				var table = document.createElement("table");	
				table.id="myTable2";
				
				var thead = document.createElement("thead");
				var tbody = document.createElement('tbody');
				table.appendChild(thead);
				table.appendChild(tbody);
				var bold = document.createElement("b");
				bold.textContent = "Libri in vendita";
				var title = document.createElement("p");
				title.appendChild(bold);
				listaLibriDiv.appendChild(title);
				var row_1 = document.createElement("tr");
				row_1.class="header";
				thead.appendChild(row_1);
				
				var tr_table = document.createElement("tr");
				table.appendChild(tr_table);
				
				for (lib in ranLibriList){
					//console.log(ranLibriList[lib]);
					
					var td_table_immagine = document.createElement("td");
					tr_table.appendChild(td_table_immagine);
					var img = document.createElement("img");
					img.style.width="220px";
					img.src="data:image/jpeg;base64," + ranLibriList[lib].immagine;
					td_table_immagine.appendChild(img);
					var pLink = document.createElement("p");
					var linkTitolo = document.createElement("a");
					linkTitolo.href="ottieniLibroDaTitoloPagPrinc?titolo=" + ranLibriList[lib].titolo + "&autore=" + ranLibriList[lib].autore;
					linkTitolo.textContent = ranLibriList[lib].titolo;
					pLink.appendChild(linkTitolo);
					td_table_immagine.appendChild(pLink);
					var pAutore = document.createElement("p");
					pAutore.textContent = ranLibriList[lib].autore;
					td_table_immagine.appendChild(pAutore);
					var pGenere = document.createElement("p");
					pGenere.textContent = ranLibriList[lib].genere;
					td_table_immagine.appendChild(pGenere);
					var pDisponibilità = document.createElement("p");
					if(ranLibriList[lib].disponibilità <= 0){
						pDisponibilità.textContent = "ESAURITO";
						pDisponibilità.style.color = "red";
					}
					else{
						pDisponibilità.textContent = "Disponibilità: " + ranLibriList[lib].disponibilità;
					}
					td_table_immagine.appendChild(pDisponibilità);
					var pPrezzo = document.createElement("p");
					bPrezzo = document.createElement("b");
					bPrezzo.textContent = ranLibriList[lib].prezzo + "€";
					pPrezzo.appendChild(bPrezzo);
					td_table_immagine.appendChild(pPrezzo);
					
					listaLibriDiv.appendChild(table);
						}
					}
						
					
				} else if (req.readyState == XMLHttpRequest.DONE){
					alert("ERROR " + req.status + " - " + req.responseText);
				}
	};
	req.open("GET", "ottieniRandomLibri", true);
	//console.log(req);
	req.send();
};

</script>
</body>
</html>