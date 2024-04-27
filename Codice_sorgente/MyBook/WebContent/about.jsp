<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="CSS/StyleRules.css">
<meta charset="UTF-8">
<title>About</title>
<style type="text/css">

	#loggedAs{
		color: white;
	}
	
	* {
  box-sizing: border-box;
}

/* Set a background color */
body {
  background-color: #474e5d;
  font-family: Helvetica, sans-serif;
}

/* The actual timeline (the vertical ruler) */
.timeline {
  position: relative;
  max-width: 1200px;
  margin: 0 auto;
}

/* The actual timeline (the vertical ruler) */
.timeline::after {
  content: '';
  position: absolute;
  width: 6px;
  background-color: white;
  top: 0;
  bottom: 0;
  left: 50%;
  margin-left: -3px;
}

/* Container around content */
.container {
  padding: 10px 40px;
  position: relative;
  background-color: inherit;
  width: 50%;
}

/* The circles on the timeline */
.container::after {
  content: '';
  position: absolute;
  width: 25px;
  height: 25px;
  right: -17px;
  background-color: white;
  border: 4px solid #FF9F55;
  top: 15px;
  border-radius: 50%;
  z-index: 1;
}

/* Place the container to the left */
.left {
  left: 0;
}

/* Place the container to the right */
.right {
  left: 50%;
}

/* Add arrows to the left container (pointing right) */
.left::before {
  content: " ";
  height: 0;
  position: absolute;
  top: 22px;
  width: 0;
  z-index: 1;
  right: 30px;
  border: medium solid white;
  border-width: 10px 0 10px 10px;
  border-color: transparent transparent transparent white;
}

/* Add arrows to the right container (pointing left) */
.right::before {
  content: " ";
  height: 0;
  position: absolute;
  top: 22px;
  width: 0;
  z-index: 1;
  left: 30px;
  border: medium solid white;
  border-width: 10px 10px 10px 0;
  border-color: transparent white transparent transparent;
}

/* Fix the circle for containers on the right side */
.right::after {
  left: -16px;
}

/* The actual content */
.content {
  padding: 20px 30px;
  background-color: white;
  position: relative;
  border-radius: 6px;
}

/* Media queries - Responsive timeline on screens less than 600px wide */
@media screen and (max-width: 600px) {
/* Place the timelime to the left */
  .timeline::after {
    left: 31px;
  }

/* Full-width containers */
  .container {
    width: 100%;
    padding-left: 70px;
    padding-right: 25px;
  }

/* Make sure that all arrows are pointing leftwards */
  .container::before {
    left: 60px;
    border: medium solid white;
    border-width: 10px 10px 10px 0;
    border-color: transparent white transparent transparent;
  }

/* Make sure all circles are at the same spot */
  .left::after, .right::after {
    left: 15px;
  }

/* Make all right containers behave like the left ones */
  .right {
    left: 0%;
  }
 }

body {
	margin-top: 0px;
	margin-left: 0px;
	margin-right: 0px;
}
</style>
</head>
<body>
<div id="topnav" class="topnav">
	  <a href="paginaPrincipale.jsp">Home</a>
	  <a href="profilo.jsp">Profilo</a>
	  <a href="contatti.jsp">Contatti</a>
	  <a class="active" href="about.jsp">About</a>
	  <jsp:include page="header.jsp" />
</div>
<div>
<h1 style="color: blue">CHI SIAMO</h1>
<p style="color: white">

Inizialmente la libreria MyBook si chiama Libreria Internazionale Rossi ed è stata fondata nel 1870 da Angelo Rossi nella città di Cortona, in via Roma.
A partire dal 1871 all'attività di vendita al dettaglio è stata affiancata quella editoriale, con la pubblicazione di una grammatica francese. 
Dopo la morte del fondatore, avvenuta nel gennaio 1917, il figlio Giovanni guida il trasferimento della libreria nella più moderna sede di via Nazionale.
La Seconda Guerra Mondiale porta con sè distruzione nel centro di Cortona e la libreria Rossi subisce danni gravissimi: nel 1940 un bombardamento distrugge il magazzino della casa editrice, 
nel 1942 è la volta della libreria. Dopo la fine della guerra la libreria si sposta nell'attuale sede di via Nazionale: l'inaugurazione avviene nel 1946.
La Libreria Rossi si è da sempre distinta per la varietà dei libri in vendita.
Nel 2010 nasce l'idea di trasformare la libreria Rossi in una catena di negozi di libri online.
L'idea si realizza poi nel 2016 e porta con sé la realizzazione di un sito web per l'acquisto dei libri e il cambiamento
del nome in "MyBook".
</p>
<p style="color: white">
Qui di seguito vi riassumiamo la storia della nostra azienda:
</p>
</div>
<div class="timeline">
  <div class="container left">
    <div class="content">
      <h2>1870</h2>
      <p>Angelo Rossi fonda la Libreria Internazionale Rossi nella città di Cortona</p>
    </div>
  </div>
  <div class="container right">
    <div class="content">
      <h2>1871</h2>
      <p>All'attività di vendita al dettaglio viene affiancata quella editoriale</p>
    </div>
  </div>
  <div class="container left">
    <div class="content">
      <h2>1917</h2>
      <p>Giovanni Rossi succede al padre nella gestione della libreria</p>
    </div>
  </div>
  <div class="container right">
    <div class="content">
      <h2>1940</h2>
      <p>Il magazzino della casa editrice viene distrutto</p>
    </div>
  </div>
  <div class="container left">
    <div class="content">
      <h2>1942</h2>
      <p>La libreria viene distrutta a seguito di un bombardamento</p>
    </div>
  </div>
  <div class="container right">
    <div class="content">
      <h2>1946</h2>
      <p>Viene inaugurata la nuova sede di via Nazionale</p>
    </div>
  </div>
  <div class="container left">
    <div class="content">
      <h2>2016</h2>
      <p>Nasce ufficialmente MyBook</p>
    </div>
  </div>
</div>
</body>
</html>