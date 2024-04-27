<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="cookieUtils.js" ></script>
<link rel="stylesheet" type="text/css" href="CSS/StyleRules.css">
<meta charset="UTF-8">
<title>Cambio password</title>
</head>
<body>	
	<form method="post" name="invio" style="border:1px solid #ccc">
		<h1>Cambio password</h1>
	    <p>Inserisci lo username con cui sei registrato, la password temporanea ricevuta e la nuova password.</p>
	    <hr>
	    
	    <label for="username"><b>Username</b></label>
	    <input type="text" id="username" placeholder="Inserisci Username" name="username" required >
	    
	    <label for="tempPwd"><b>Password temporanea</b></label>
	    <input type="text" id="tempPwd" placeholder="Inserisci password temporanea" name="tempPwd" required >
	    
	    <label for="newPwd"><b>Nuova Password</b></label>
	    <input type="text" id="newPwd" placeholder="Inserisci nuova password con minimo 6 caratteri" name="newPwd" required >
	    
	    <button type="submit" onclick="valida()">Cambia Password</button>
    </form>
    
<script type="text/javascript">

function valida() {
	   //Variabili associate ai campi del modulo
	   var username = document.getElementById("username").value;
	   var tempPwd = document.getElementById("tempPwd").value;
	   var newPwd = document.getElementById("newPwd").value;
	   
	   //Effettua il controllo sul campo username
	   if ((username == "") || (username == "undefined")) {
		      alert("Devi inserire lo username");
		      document.getElementById("username").focus();
		      return false;
		   }
	   //Effettua il controllo sul campo tempPwd
	   if ((tempPwd == "") || (tempPwd == "undefined")) {
		      alert("Devi inserire la password temporanea");
		      document.getElementById("tempPwd").focus();
		      return false;
		   }
	   //Controlla se la password temporanea inserita è uguale a quella del cookie
	   var cookiePwd = getCookie("resetPwd_" + username);
	   if (tempPwd !== cookiePwd) {
		      alert("La password temporanea inserita o lo username non sono corretti");
		      document.getElementById("tempPwd").focus();
		      return false;
		   }
	   //Effettua il controllo sul campo newPwd
		if (newPwd.length < 6 || (newPwd == "") || (newPwd == "undefined") )  
		  {
		    alert("Scegli una nuova password, minimo 6 caratteri");
		    document.getElementById("newPwd").focus();
		    return false;
		  }
	  
	    else {
	      document.invio.action = "aggiornaPwd";
	      var r = confirm ("Dati inseriti correttamente, si vuole procedere con l'aggiornamento della password?");
	      if (r){
	    	 document.invio.submit();
	      }
	   }
	};

</script>
</body>
</html>