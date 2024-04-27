<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="CSS/StyleRules.css">
<meta charset="UTF-8">
<title>Login</title>
</head>
<body>
<c:url value="/login" var="loginUrl"/>	
<form method="post" action="${loginUrl}" style="border:1px solid #ccc">
  <div class="container">
    <h1>Login</h1>
    <p>Inserisci username e password.</p>
    <hr>

    <label for="username"><b>Username</b></label>
    <input type="text" placeholder="Inserisci Username" name="username" required>

    <label for="psw"><b>Password</b></label>
    <input type="password" placeholder="Inserisci Password" name="psw" required>
    
    <div class="clearfix">
      <button type="button" class="cancelbtn" onclick="reset();">Cancel</button>
      <button type="submit" class="signupbtn">Login</button>
    </div>
    <p><a href="registrazione.jsp">Non hai un account? Registrati</a></p>
     <p>Clicca quì per ricevere una password temporanea <a href="resetPwd.jsp" >Resetta la password</a></p>
     <p>Clicca quì se hai già ricevuto una password temporanea <a href="cambioPwd.jsp">Cambia la password</a></p>
  </div>
</form>
</body>
</html>