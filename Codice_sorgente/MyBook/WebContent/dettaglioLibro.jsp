<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="cookieUtils.js" ></script>
<link rel="stylesheet" type="text/css" href="CSS/AggPrezzoStyle.css">
<meta charset="UTF-8">
<title>Dettaglio libro</title>
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
/* Split the screen in half */
.split {
  height: 100%;
  width: 50%;
  position: absolute;
  z-index: 1;
  top: 10%;
  overflow-x: hidden;
  overflow-y: scroll;
  padding-top: 20px;
}

/* Control the left side */
.left {
  left: 0;
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
}

.topnav {
	font-family: Helvetica, sans-serif;
	}
</style>
</head>
<body>
<div id="topnav" class="topnav">
	  <a class="active" href="paginaPrincipale.jsp">Home</a>
	  <a href="profilo.jsp">Profilo</a>
	  <a href="contatti.jsp">Contatti</a>
	  <a href="about.jsp">About</a>
	  <jsp:include page="header.jsp" />
</div>
<div class="splitte">
<c:choose>
	<c:when test="${libri.size()>0}">
		<c:forEach var="libro" items="${libri}">
		<div class="split left">
			<div class="centered">
	  			<img width="400" src="data:image/jpeg;base64,${libro.immagine}" />
  			</div>
		</div>
		<div class="split right" >
	 	 <form method="post" name="invio" style="border:1px solid #ccc" > 
		 <h2 style="margin-bottom: 0px">${libro.titolo}</h2>
		 <p style="margin-top: 0px">di <b>${libro.autore}</b></p>
			<ul id="myUL" >
			  <li>ISBN: <b id="boldISBN">${libro.ISBN}</b></li>
			  <li>Genere: ${libro.genere}</li>
			  <li>${libro.descrizione}</li>
			  <li>Prezzo : <b id="boldPrezzo">${libro.prezzo}</b> €</li>
			  <c:choose>
			  	<c:when test="${libro.disponibilità <= 0}">
			  		<li><p style="color: red">ESAURITO</p></li>
		  		</c:when>
		  		<c:otherwise>
		  			<li>Disponibilità: ${libro.disponibilità}</li>
		  		</c:otherwise>
			  </c:choose>
		  	</ul>
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
      			<button type="button" class="signupbtn" onclick="valida('<c:out value="${libro.titolo}" />', '<c:out value="${libro.autore}" />')">Acquista</button>
   		    </div>
 		  </form> 
		  </div>
		</c:forEach>
	</c:when>
</c:choose>
</div>
<script type="text/javascript">
	//In caricamento della pagina carica il saldo della tessera e tutti i negozi
	var saldo;
	window.onload = function (){
		var username = "<c:out value="${currentUser.username}" />";
		var req = new XMLHttpRequest(); 
		req.onreadystatechange = function() {
			if (req.readyState == XMLHttpRequest.DONE && req.status == 200){
				//console.log("Sono nello stato 200");
				saldo = JSON.parse(req.responseText);
				//console.log("saldo = " + saldo);
				if(saldo != null){
					var loggedAs = document.getElementById("loggedAs");
					var pSaldo = document.createElement("p");
					loggedAs.appendChild(pSaldo);
					pSaldo.textContent = "Saldo tessera: " + saldo + "€";
					pSaldo.style.color = "white";
					pSaldo.style = "margin-top: 3px";
				}
			} else if (req.readyState == XMLHttpRequest.DONE){
				alert("ERROR " + req.status + " - " + req.responseText);
			}
		};
		req.open("GET", "ottieniSaldo?username=" + username, true);
		//console.log(req);
		req.send();
		ottieniNegozi();
	};
	
	//Ottieni tutti i negozi che contengono il libro dall'ISBN
	var negoziList;
	function ottieniNegozi(){
		var ISBN = document.getElementById("boldISBN").textContent;
		//console.log(ISBN);
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
		req.open("GET", "ottieniNegoziDaISBN?ISBN=" + ISBN, true);
		//console.log(req);
		req.send();
 };
 //Ottieni i magazzini attraverso il negozio selezionato a cui appartengono e l'ISBN del libro
 var magazziniList;
	function ottieniMagazzini(){
		var idMagSel = document.getElementById("magazziniSel");
		while (idMagSel.children[1]) {
		    idMagSel.removeChild(idMagSel.lastElementChild);
		  }
		var idNegozio = document.getElementById("negoziSel").value;
		var ISBN = document.getElementById("boldISBN").textContent;
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
		req.open("GET", "ottieniMagazziniDaISBN?ISBN=" + ISBN + "&idNegozio=" + idNegozio, true);
		//console.log(req);
		req.send();
	};
	
	//Controlla la validità dei parametri e acquista il libro
	function valida() {
		   //Variabili associate ai campi del modulo
		   var negozio = document.getElementById("negoziSel").value;
		   var idMagazzino = document.getElementById("magazziniSel").value;
		   var prezzo = document.getElementById("boldPrezzo").textContent;
		   var disponibilità = "<c:out value="${libri[0].disponibilità}" />";
		   var genere = "<c:out value="${libri[0].genere}" />";
		   var ISBN = document.getElementById("boldISBN").textContent;
		   var username = "<c:out value="${currentUser.username}" />";
		   
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
		    //Se il libro è esaurito allora manda un alert
		    if (disponibilità <= 0){
		    	  alert("Siamo spiacenti, l'articolo è esaurito");
		    }
		    //Se non ci sono abbastanza soldi nella tessera per l'acquisto allora
		    //manda un alert
		    if (saldo < prezzo) {
		 	      alert("Fondi insufficienti per l'acquisto");
		 	      return false;
		 	   }
		    
		    else {
		      document.invio.action = "acquistaLibro?ISBN=" + ISBN + "&genere=" + genere + "&saldo=" + saldo + "&prezzo=" + prezzo;
		      var r = confirm ("Si vuole procedere con l'acquisto del libro?");
		      if (r){
		    	 document.invio.submit();
		    	 //Controlla se esiste un cookie con i generi preferiti,
		    	 //se esiste allora chiama la funzione di aggiunta del genere
		    	 //al cookie, altrimenti crea il cookie
		    	 var genCookie = checkCookie (username + "_genList");
			 		if(genCookie != null){
			 			addGenToCookie(genere, username);
			 		}
			 		else {
			 			var gen_arr = new Array (genere);
			 			setCookie(username + "_genList", JSON.stringify(gen_arr), 30);
			 		}
		 	    }
		      }
		   };
		//Prende il cookie e ci inserisce il genere
		function addGenToCookie(genere, username){
			var json_str = getCookie(username + "_genList");
			var arr = JSON.parse(json_str);
			//se il cookie non contiene il genere, allora inserisci il genere nel cookie
			if (!arr.includes(genere)){
				arr.push(genere);
				json_str = JSON.stringify(arr); 
				setCookie(username + "_genList", json_str ,30);
			}
		};


</script>
</body>
</html>