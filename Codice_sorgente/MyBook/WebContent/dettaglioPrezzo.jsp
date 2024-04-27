<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="CSS/AggPrezzoStyle.css">
<meta charset="UTF-8">
<title>Dettaglio aggiorna prezzo</title>
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
  background-color: #f44336;
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
  			<h2>Dettaglio prezzo del libro '<c:out value="${libro.titolo}"/>'</h2>
		</div>
		 <form method="post" name="invio" style="border:1px solid #ccc" enctype="multipart/form-data">
			<ul id="myUL">
			  <li>ISBN: ${libro.ISBN}</li>
			  <li>Titolo: ${libro.titolo}</li>
			  <li>Autore: ${libro.autore}</li>
			  <li>Prezzo corrente: ${libro.prezzo}</li>
			  <li>
			  	<label for="prezzo"><b>Prezzo aggiornato</b></label>
    			<input type="number" id="prezzo" placeholder="Inserisci prezzo aggiornato" name="prezzo" required>
    		  </li>
		  	</ul>
		  	<div class="clearfix">
      			<button type="button" class="cancelbtn" onclick="reset()">Cancel</button>
      			<button type="button" class="signupbtn" onclick="valida('<c:out value="${libro.titolo}" />', '<c:out value="${libro.autore}" />')">Aggiorna</button>
   		    </div>
		  </form>
		</c:forEach>
	</c:when>
</c:choose>
<script type="text/javascript">

//Controlla il parametro prezzo aggiornato e procedi con l'aggiornamento del prezzo
function valida(titolo, autore) {
	   //Variabile associata al campo prezzo del form
	   var prezzoAggiornato= document.invio.prezzo.value;
	  
	    //Effettua il controllo sul campo prezzo
	    if ((prezzoAggiornato == "") || (prezzoAggiornato == "undefined") || (prezzoAggiornato < 0)) {
	 	      alert("Devi inserire un prezzo valido");
	 	      document.invio.prezzo.focus();
	 	      return false;
	 	   }
	    
	    else {
	      document.invio.action = "aggiornaPrezzo?titoloSelect=" + titolo + "&autoreSelect=" + autore + "&prezzo=" + prezzoAggiornato;
	      var r = confirm ("Si vuole procedere con l'aggiornamento del prezzo?");
	      if (r){
	    	 document.invio.submit();
	      }
	   }
	};


</script>
</body>
</html>