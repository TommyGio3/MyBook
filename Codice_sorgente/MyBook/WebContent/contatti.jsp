<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="CSS/ContattiStyle.css">
<link rel="stylesheet" type="text/css" href="CSS/StyleRules.css"> 
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<meta charset="UTF-8">
<title>Contatti</title>
<style type="text/css">
	#loggedAs {
		color: white;
	}
	body {
	margin-top: 0px;
	margin-left: 0px;
	margin-right: 0px;
}
	.topnav {
	font-family: Helvetica, sans-serif;
	}
	body{
	background-color: #474e5d;background-color: #474e5d;
	}

</style>
</head>
<body style="overflow: auto">
	<div class="topnav">
	  <a href="paginaPrincipale.jsp">Home</a>
	  <a href="profilo.jsp">Profilo</a>
	  <a class="active" href="contatti.jsp">Contatti</a>
	  <a href="about.jsp">About</a>
	  <jsp:include page="header.jsp" />
	</div>
	<div>
		<h1 style="margin-bottom: 0px; color: white">MyBook Srl</h1>
	</div>
	<div >
	 	<br>
	 	<img alt="Immagine_Libri" src="image/libri_secondaria.jpeg" width="700 px">
	</div>
	<div>
		<a href="https://www.facebook.com/MyBook" class="fa fa-facebook"></a>
		<a href="https://twitter.com/MyBook" class="fa fa-twitter"></a>
		<a href="https://www.instagram.com/MyBook" class="fa fa-instagram"></a>
	</div>
	<div class="dropdown">
	  <button class="dropbtn">Contatti</button>
	  <div class="dropdown-content">
	    <a href="tel: 0575604918">Telefono</a>
	    <a href="mailto: MyBook_help@gmail.com">Mail</a>
	  </div>
	</div>
</body>
</html>