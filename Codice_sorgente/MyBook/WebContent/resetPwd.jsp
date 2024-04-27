<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="CSS/StyleRules.css">
<meta charset="UTF-8">
<title>Reset Password</title>
</head>
<body>
	<c:url value="/resetPwd" var="resetPwdUrl"/>	
	<form method="post" action="${resetPwdUrl}" style="border:1px solid #ccc">
		<h1>Reset password</h1>
	    <p>Inserisci l'email con cui sei registrato.</p>
	    <hr>
	    
	    <label for="email"><b>Email</b></label>
	    <input type="text" id="email" placeholder="Inserisci Email" name="email" required onchange="validaEmail()">
	    
	    <button type="submit" onclick="alert('Riceverai una mail con una nuova password provvisoria che durerà 24 ore')">Reset Password</button>
    </form>
    
<script type="text/javascript">
//Controlla che l'email inserita corrisponda ad un account esistente
function validaEmail() {
	var email = document.getElementById("email").value;
	//console.log("email = " + email);
	var req = new XMLHttpRequest(); 
	req.onreadystatechange = function() {
		if (req.readyState == XMLHttpRequest.DONE && req.status == 200){
			//console.log("Sono nello stato 200");
			var res = JSON.parse(req.responseText);
			//console.log("risposta= " + res);
			if(!res){
				alert("ATTENZIONE: l'email inserita non corrisponde a nessun account registrato. Provare un'altra email");
			}
		} else if (req.readyState == XMLHttpRequest.DONE){
			alert("ERROR " + req.status + " - " + req.responseText);
		}
	};
	req.open("GET", "validaEmail?email=" + email, true);
	//console.log(req);
	req.send();
};

</script>
</body>
</html>