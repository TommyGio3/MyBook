<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="cookieUtils.js" ></script>
<link rel="stylesheet" type="text/css" href="CSS/AggPrezzoStyle.css">
<meta charset="UTF-8">
<title>Dettaglio ordine</title>
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
<c:choose>
	<c:when test="${libri.size()>0}">
		<c:forEach var="libro" items="${libri}">
		<div id = "split_right" class="split right" style="overflow: auto">
		 <h2 style="margin-bottom: 0px; text-align: center; color: white">Ordine per '${libro.titolo}'</h2>
		 <br>
		 <br>
		 <br>
			<ul id="myUL" >
			  <li>Titolo: <b>${libro.titolo}</b></li>
			  <li>Autore:<b>${libro.autore}</b></li>
			  <li>Genere: <b>${libro.genere}</b></li>
			  <li>Prezzo attuale: <b>${libro.prezzo}</b> €</li>
			  <li>ISBN: <b>${libro.ISBN}</b></li>
			  <li><img width="300" src="data:image/jpeg;base64,${libro.immagine}" /></li>
		  	</ul>
		  </div>
	     </c:forEach>
	</c:when>
 </c:choose>
</div>
</body>
</html>