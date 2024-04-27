<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="cookieUtils.js" ></script>
<link rel="stylesheet" type="text/css" href="CSS/AggPrezzoStyle.css">
<meta charset="UTF-8">
<title>Profilo</title>
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
/* Include the padding and border in an element's total width and height */
* {
  box-sizing: border-box;
}

/* Remove margins and padding from the list */
ul {
  margin: 0;
  padding: 0;
}

/* Style the list items */
ul li {
  cursor: pointer;
  position: relative;
  padding: 12px 8px 12px 40px;
  background: #eee;
  font-size: 18px;
  transition: 0.2s;

  /* make the list items unselectable */
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
}

/* Set all odd list items to a different color (zebra-stripes) */
ul li:nth-child(odd) {
  background: #f9f9f9;
}

/* Darker background-color on hover */
ul li:hover {
  background: #ddd;
}

/* When clicked on, add a background color and strike out text */
ul li.checked {
  background: #888;
  color: #fff;
  text-decoration: line-through;
}

/* Add a "checked" mark when clicked on */
ul li.checked::before {
  content: '';
  position: absolute;
  border-color: #fff;
  border-style: solid;
  border-width: 0 2px 2px 0;
  top: 10px;
  left: 16px;
  transform: rotate(45deg);
  height: 15px;
  width: 7px;
}

/* Style the header */
.header {
  background-color: #9e9e9e;
  padding: 30px 40px;
  color: white;
  text-align: center;
}

/* Clear floats after the header */
.header:after {
  content: "";
  display: table;
  clear: both;
}

#loggedAs{
		color: white;
	}

/* Control the right side */
.right {
  right: 0;
  overflow: auto;
}

.centered {
  position: absolute;
  top: 42%;
  left: 50%;
  transform: translate(-50%, -50%);
  text-align: center;
}

#generiSel, #negoziSel, #magazziniSel {
  width: 100%;
  padding: 15px;
  margin: 5px 0 22px 0;
  display: inline-block;
  border: none;
  background: #e4d2d2;
}

#generiSel:focus, #negoziSel:focus, #magazziniSel.focus {
  background-color: yellow;
  outline: none;
}

body {
	margin-top: 0px;
	margin-left: 0px;
	margin-right: 0px;
	background-color: #474e5d;
}
.topnav {
	font-family: Helvetica, sans-serif;
	}

</style>
</head>
<body>
<div id="topnav" class="topnav">
	  <a href="paginaPrincipale.jsp">Home</a>
	  <a class="active" href="profilo.jsp">Profilo</a>
	  <a href="contatti.jsp">Contatti</a>
	  <a href="about.jsp">About</a>
	  <jsp:include page="header.jsp" />
</div>
<div class="splitte">
		<div id = "split_right" class="split right" style="overflow: auto">
		 <h2 style="margin-bottom: 0px; text-align: center; color: white">Dati dell'utente '${currentUser.username}'</h2>
		 <br>
		 <br>
		 <br>
			<ul id="myUL" >
			  <li>Email: <b id="emailBold">${currentUser.email}</b></li>
			  <li>Nome:<b id="nomeBold"></b></li>
			  <li>Cognome: <b id="cognomeBold"></b></li>
			  <li>Codice fiscale: <b id="CFBold"></b></li>
			  <li>Indirizzo: <b id="indirizzoBold"></b></li>
			  <li>Data di nascita: <b id="dataDiNascBold"></b></li>
			  <li>ID tessera: <b id="idTessBold">${currentUser.idTessera}</b></li>
			  <li>Saldo tessera: <b id="saldoBold"></b> €</li>
		  	</ul>
		  </div>
</div>
<script type="text/javascript">
	//In caricamento della pagina carica i dati del cliente e ottieni il saldo della tessera
	//e ottieni gli ordini effettuati dal cliente
	var datiClienteList;
	window.onload = function (){
		var nome = document.getElementById("nomeBold");
		var cognome = document.getElementById("cognomeBold");
		var codFisc = document.getElementById("CFBold");
		var indirizzo = document.getElementById("indirizzoBold");
		var dataDiNasc = document.getElementById("dataDiNascBold");
		var username = "<c:out value="${currentUser.username}" />";
		var req = new XMLHttpRequest(); 
		req.onreadystatechange = function() {
			if (req.readyState == XMLHttpRequest.DONE && req.status == 200){
				//console.log("Sono nello stato 200");
				datiClienteList = JSON.parse(req.responseText);
				//console.log("lista = " + datiClienteList);
				if(datiClienteList != null){
					for (cli in datiClienteList){
						nome.textContent = datiClienteList[cli].nome;
						cognome.textContent = datiClienteList[cli].cognome;
						codFisc.textContent = datiClienteList[cli].codiceFiscale;
						indirizzo.textContent = datiClienteList[cli].indirizzo;
						dataDiNasc.textContent = datiClienteList[cli].dataDiNascita;
					}
				}
			} else if (req.readyState == XMLHttpRequest.DONE){
				alert("ERROR " + req.status + " - " + req.responseText);
			}
		};
		req.open("GET", "ottieniDatiCliente?username=" + username, true);
		//console.log(req);
		req.send();
		ottieniSaldo();
		ottieniOrdini();
	};
	
	//Ottieni il saldo della tessera
	var saldo;
	function ottieniSaldo () {
		var username = "<c:out value="${currentUser.username}" />";
		var saldoB = document.getElementById("saldoBold");
		var req = new XMLHttpRequest(); 
		req.onreadystatechange = function() {
			if (req.readyState == XMLHttpRequest.DONE && req.status == 200){
				//console.log("Sono nello stato 200");
				saldo = JSON.parse(req.responseText);
				//console.log("saldo = " + saldo);
				if(saldo != null){
					saldoB.textContent = saldo;
				}
			} else if (req.readyState == XMLHttpRequest.DONE){
				alert("ERROR " + req.status + " - " + req.responseText);
			}
		};
		req.open("GET", "ottieniSaldo?username=" + username, true);
		//console.log(req);
		req.send();
	};
	
	//Ottieni gli ordini effettuati dal cliente
	var ordini;
	function ottieniOrdini(){
		var username = "<c:out value="${currentUser.username}" />";
		var divRight = document.getElementById("split_right");
		var req = new XMLHttpRequest(); 
		req.onreadystatechange = function() {
			if (req.readyState == XMLHttpRequest.DONE && req.status == 200){
				//console.log("Sono nello stato 200");
				ordini = JSON.parse(req.responseText);
				//console.log("lista = " + ordini);
				if(ordini != null){
					div = document.createElement("div");
					divRight.appendChild(div);
					title = document.createElement("h2");
					title.textContent="Ordini effettuati";
					title.style="text-align: center; color: white";
					div.appendChild(title);
					for (ord in ordini){
						//console.log(ordini[ord]);
						ul = document.createElement("ul");
						div.appendChild(ul);
						idOrdLi = document.createElement("li");
						idOrdLi.textContent = "ID ordine: ";
						ul.appendChild(idOrdLi);
						idOrdLink = document.createElement("a");
						idOrdLink.textContent = ordini[ord].idOrdine;
						idOrdLink.href="ottieniLibroDaCopiaLibro?idCopiaLibro=" + ordini[ord].copiaLibro;
						idOrdLi.appendChild(idOrdLink);
						dataOrdLi = document.createElement("li");
						dataOrdLi.textContent = "Data ordine: ";
						ul.appendChild(dataOrdLi);
						dataOrdBold = document.createElement("b");
						dataOrdBold.textContent = ordini[ord].dataOrdine;
						dataOrdLi.appendChild(dataOrdBold);
						br = document.createElement("br");
						div.appendChild(br);	
					}
				}
			} else if (req.readyState == XMLHttpRequest.DONE){
				alert("ERROR " + req.status + " - " + req.responseText);
			}
		};
		req.open("GET", "ottieniOrdini?username=" + username, true);
		//console.log(req);
		req.send();
	};
</script>
</body>
</html>