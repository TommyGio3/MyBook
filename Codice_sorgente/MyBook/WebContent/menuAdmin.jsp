<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Menù Amministratore</title>
<style type="text/css">
body {
  font-family: Arial, Helvetica, sans-serif;
}

* {
  box-sizing: border-box;
}

/* Create a column layout with Flexbox */
.row {
  display: flex;
}

/* Left column (menu) */
.left {
  flex: 35%;
  padding: 15px 0;
}

.left h2 {
  padding-left: 8px;
}

/* Right column (page content) */
.right {
  flex: 65%;
  padding: 15px;
}

/* Style the search box */
#mySearch {
  width: 100%;
  font-size: 18px;
  padding: 11px;
  border: 1px solid #ddd;
}

/* Style the navigation menu inside the left column */
#myMenu {
  list-style-type: none;
  padding: 0;
  margin: 0;
}

#myMenu li a {
  padding: 12px;
  text-decoration: none;
  color: black;
  display: block
}

#myMenu li a:hover {
  background-color: #eee;
}

p {
	color: black;
}

.button {
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

.button:hover {background-color: #3e8e41}

.button:active {
  background-color: #3e8e41;
  box-shadow: 0 5px #666;
  transform: translateY(4px);
}

#loggedAs{
	padding-right: 30px;
}
</style>
</head>
<body>
<jsp:include page="headerAdmin.jsp" />
<h2>Amministrazione</h2>
<p>Benvenuto nella pagina amministratore di MyBook SRL. Utilizza la ricerca per filtrare le varie funzionalità.</p>

<div class="row">
  <div class="left" style="background-color:#bbb;">
    <h2>Menu</h2>
    <input type="text" id="mySearch" onkeyup="myFunction()" placeholder="Search.." title="Type in a category">
    <ul id="myMenu">
      <li><a href="inserisciLibro.jsp">Inserisci un libro</a></li>
      <li><a href="aggiornaPrezzo.jsp">Aggiorna prezzo</a></li>
      <li><a href="aggiornaNumeroCopie.jsp">Aggiungi numero copie</a></li>
      <li><a href="aggiungiNegozio.jsp">Aggiungi negozio</a></li>
       <li><a href="aggiungiMagazzino.jsp">Aggiungi magazzino</a></li>
    </ul>
  </div>
  
  <div class="right" style="background-color:#ddd;">
    <h2>MyBook</h2>
    <img alt="Immagine_Libri" src="image/libri_secondaria.jpeg" width="600 px">
    <p><b>Inserisci un libro:</b> permette di inserire un nuovo libro all'elenco dei libri nel catalogo.</p>
    <p><b>Aggiorna prezzo:</b> permette di aggiornare il prezzo di un libro.</p>
    <p><b>Aggiungi numero copie:</b> permette di aggiungere il numero di copie di un libro.</p>
    <p><b>Aggiungi negozio:</b> permette di aggiungere un nuovo negozio alla catena.</p>
    <p><b>Aggiungi magazzino:</b> permette di aggiungere un nuovo magazzino ad un negozio della catena.</p>
  </div>
</div>

<script>
//aggiorna le funzionalità in base alla ricerca
function myFunction() {
  var input, filter, ul, li, a, i;
  input = document.getElementById("mySearch");
  filter = input.value.toUpperCase();
  ul = document.getElementById("myMenu");
  li = ul.getElementsByTagName("li");
  for (i = 0; i < li.length; i++) {
    a = li[i].getElementsByTagName("a")[0];
    if (a.innerHTML.toUpperCase().indexOf(filter) > -1) {
      li[i].style.display = "";
    } else {
      li[i].style.display = "none";
    }
  }
}
</script>

</body>
</html>