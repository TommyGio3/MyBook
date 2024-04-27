<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="CSS/StyleRules.css">
<meta charset="UTF-8">
<title>Registrazione</title>
</head>
<body>
<%-- <c:url value="/creaUtente" var="createUrl" /> --%>
<form method="post" name="invio" style="border:1px solid #ccc">
  <div class="container">
    <h1>Sign Up</h1>
    <p>Compila il form per creare un nuovo account.</p>
    <hr>

    <label for="email"><b>Email</b></label>
    <input type="text" id="email" placeholder="Inserisci Email" name="email" onchange="controllaEmail()" required>
    
    <label for="username"><b>Username</b></label>
    <input type="text" id="username" placeholder="Inserisci Username" name="username" onchange="controllaUsername()" required>

    <label for="psw"><b>Password</b></label>
    <input type="password" placeholder="Inserisci Password con minimo 6 caratteri" name="psw" required>

    <label for="pswRepeat"><b>Ripeti Password</b></label>
    <input type="password" placeholder="Ripeti Password" name="pswRepeat" required >

    <label for="nome"><b>Nome</b></label>
    <input type="text" placeholder="Inserisci Name" name="nome" required>

    <label for="cognome"><b>Cognome</b></label>
    <input type="text" placeholder="Inserisci Cognome" name="cognome" required>
    
    <label for="codiceFiscale"><b>Codice Fiscale</b></label>
    <input type="text" id="codFisc" placeholder="Inserisci Codice fiscale" name="codiceFiscale" onchange="controllaCodFisc()"required>
    
    <label for="indirizzo"><b>Indirizzo</b></label>
    <input type="text" placeholder="Inserisci Indirizzo" name="indirizzo" required>
    
    <label for="dataDiNascita"><b>Data di nascita</b></label>
    <input type="text" placeholder="Inserisci data di nascita nella forma gg/mm/aaaa" name="dataDiNascita" required> 

    <p>Creando un account accetti i nostri Termini e Condizioni.</p>

    <div class="clearfix">
      <button type="button" class="cancelbtn" onclick="reset()">Cancel</button>
      <button type="button" class="signupbtn" onclick="valida()">Sign Up</button>
    </div>
  </div>
</form>
<script type="text/javascript">
//Controlla se il codice fiscale inserito è già in uso
function controllaCodFisc() {
	var codFisc = document.getElementById("codFisc").value;
	//console.log("codFisc = " + codFisc);
	var req = new XMLHttpRequest(); 
	req.onreadystatechange = function() {
		if (req.readyState == XMLHttpRequest.DONE && req.status == 200){
			//console.log("Sono nello stato 200");
			var res = JSON.parse(req.responseText);
			//console.log("risposta= " + res);
			if(res){
				alert("ATTENZIONE: codice fiscale già in uso");
			}
		} else if (req.readyState == XMLHttpRequest.DONE){
			alert("ERROR " + req.status + " - " + req.responseText);
		}
	};
	req.open("GET", "validaCodFisc?codiceFiscale=" + codFisc, true);
	//console.log(req);
	req.send();
};

//Controlla se l'email inserita è già in uso
function controllaEmail() {
	var email = document.getElementById("email").value;
	//console.log("email = " + email);
	var req = new XMLHttpRequest(); 
	req.onreadystatechange = function() {
		if (req.readyState == XMLHttpRequest.DONE && req.status == 200){
			//console.log("Sono nello stato 200");
			var res = JSON.parse(req.responseText);
			//console.log("risposta= " + res);
			if(res){
				alert("ATTENZIONE: email già in uso");
			}
		} else if (req.readyState == XMLHttpRequest.DONE){
			alert("ERROR " + req.status + " - " + req.responseText);
		}
	};
	req.open("GET", "validaEmail?email=" + email, true);
	//console.log(req);
	req.send();
};

//Controlla se lo username inserito è già in uso
function controllaUsername() {
	var username = document.getElementById("username").value;
	//console.log("username = " + username);
	var req = new XMLHttpRequest(); 
	req.onreadystatechange = function() {
		if (req.readyState == XMLHttpRequest.DONE && req.status == 200){
			//console.log("Sono nello stato 200");
			var res = JSON.parse(req.responseText);
			//console.log("risposta= " + res);
			if(res){
				alert("ATTENZIONE: nome utente già in uso");
			}
		} else if (req.readyState == XMLHttpRequest.DONE){
			alert("ERROR " + req.status + " - " + req.responseText);
		}
	};
	req.open("GET", "validaUsername?username=" + username, true);
	//console.log(req);
	req.send();
};


//Controlla il corretto inserimento dei parametri e in caso affermativo crea un nuovo account
function valida() {
   //Variabili associate ai campi del modulo
   var email = document.invio.email.value;
   var username = document.invio.username.value;
   var password = document.invio.psw.value;
   var pswRepeat = document.invio.pswRepeat.value;
   var nome= document.invio.nome.value;
   var codFiscale = document.invio.codiceFiscale.value;
   var indirizzo = document.invio.indirizzo.value;
   var dataDiNascita = document.invio.dataDiNascita.value;
   //Variabile associata alla data di oggi
   var today = new Date();
   
 
   //Effettua il controllo sul campo username
   if ((username == "") || (username == "undefined")) {
	      alert("Devi inserire uno username");
	      document.invio.username.focus();
	      return false;
	   }
   //Espressione regolare dell'email che deve essere nella forma nome@dominio.it, .com ecc.
   var email_valid = /^([a-zA-Z0-9_.-])+@(([a-zA-Z0-9-]{2,})+.)+([a-zA-Z0-9]{2,})+$/;
   //Effettua il controllo sul campo email
   if (!email_valid.test(email) || (email == "") || (email == "undefined")) 
   {
      alert("Devi inserire un indirizzo mail corretto");
      document.invio.email.focus();
      return false;
   }
   //Effettua il controllo sul campo password
	if (password.length < 6 || (password == "") || (password == "undefined") )  
	  {
	    alert("Scegli una password, minimo 6 caratteri");
	    document.invio.password.focus();
	    return false;
	  }
   //Effettua il controllo sul campo RIPETI PASSWORD
   if ((pswRepeat == "") || (pswRepeat == "undefined")) {
      alert("Devi ripetere la password");
      document.invio.pswRepeat.focus();
      return false;
    }
   //Controlla che le due password coincidano
    if (password != pswRepeat) {
       alert("Le password non coincidono");
       document.invio.pswRepeat.value = "";
       document.invio.pswRepeat.focus();
       return false;
    }
    //Effettua il controllo sul campo nome
    if ((nome == "") || (nome == "undefined")) {
 	      alert("Devi inserire un nome");
 	      document.invio.nome.focus();
 	      return false;
 	   }
    //Espressione regolare del codice fiscale
    var codiceFiscale_valid = /[a-z]{6}\d{2}[abcdehlmprst]\d{2}[a-z]\d{3}[a-z]/i;
    //Effettua il controllo sul campo codice fiscale in modo che sia scritto nella forma giusta
    if (!codiceFiscale_valid.test(codFiscale) || (codFiscale == "") || (codFiscale == "undefined")) {
 	      alert("Devi inserire un codice fiscale valido");
 	      document.invio.codFiscale.focus();
 	      return false;
 	   }
    //Effettua il controllo sul campo indirizzo
    if ((indirizzo == "") || (indirizzo == "undefined")) {
 	      alert("Devi inserire un indirizzo");
 	      document.invio.indirizzo.focus();
 	      return false;
 	   }
    //Effettua il controllo sul campo data di nascita
    if ((dataDiNascita == "") || (dataDiNascita == "undefined")) {
 	      alert("Devi inserire una data di nascita");
 	      document.invio.dataDiNascita.focus();
 	      return false;
 	   }
    //Controlla che venga inserito nella giusta posizione il carattere di divisione (/) 
    //e che vengano inseriti due caratteri numerici prima del primo simbolo di divisione, 
    //due caratteri numerici tra il primo ed il secondo carattere di divisione e quattro 
    //caratteri numerici in coda e controlla che il giorno non sia superiore a 31, che il
    //mese non sia superiore a 12 e l’anno non sia inferiore a 1900. In tutti i casi di 
    //errore restituisci un messaggio di avviso che indichi di inserire una data valida 
    //o in formato corretto, seleziona quanto scritto e non restituire nulla
    if (dataDiNascita.substring(2,3) != "/" || dataDiNascita.substring(5,6) != "/" ||
    	isNaN(dataDiNascita.substring(0,2)) || isNaN(dataDiNascita.substring(3,5)) ||
    	isNaN(dataDiNascita.substring(6,10))) {
    		alert("Inserire nascita in formato gg/mm/aaaa");
    		document.invio.dataDiNascita.value = "";
    		document.invio.dataDiNascita.focus();
    		return false;
    		} else if (dataDiNascita.substring(0,2) > 31 || dataDiNascita.substring(0,2) < 0) {
    		alert("Impossibile utilizzare un valore superiore a 31 o minore di 0 per i giorni");
    		document.invio.dataDiNascita.select();
    		return false;
    		} else if (dataDiNascita.substring(3,5) > 12 || dataDiNascita.substring(3,5) < 0) {
    		alert("Impossibile utilizzare un valore superiore a 12 o minore di 0 per i mesi");
    		document.invio.dataDiNascita.value = "";
    		document.invio.dataDiNascita.focus();
    		return false;
    		} else if (dataDiNascita.substring(6,10) < 1900) {
    		alert("Impossibile utilizzare un valore inferiore a 1900 per l'anno");
    		document.invio.dataDiNascita.value = "";
    		document.invio.dataDiNascita.focus();
    		return false;
    		} else if ((dataDiNascita.substring(3,5) == 04 || 
    					dataDiNascita.substring(3,5) == 06 || 
    				    dataDiNascita.substring(3,5) == 09 || 
    				    dataDiNascita.substring(3,5) == 11) && 
    				    dataDiNascita.substring(0,2) > 30) {
       		alert("Il numero di giorni è troppo grande per il mese inserito");
       		document.invio.dataDiNascita.value = "";
       		document.invio.dataDiNascita.focus();
       		return false;
       		} else if (dataDiNascita.substring(3,5) == 02 && 
    				   dataDiNascita.substring(0,2) > 28) {
       		alert("Il numero di giorni è troppo grande per il mese inserito");
       		document.invio.dataDiNascita.value = "";
       		document.invio.dataDiNascita.focus();
       		return false;
       		}
    //Controlla che la data di nascita non sia posteriore alla data odierna
    //Aggiungi 1 al mese corrente perchè il conteggio parte da 0 e non da 1
    else if (dataDiNascita.substring(6,10) > today.getFullYear() ){
       		alert("Impossibile utilizzare una data successiva alla data odierna");
       		document.invio.dataDiNascita.value = "";
       		document.invio.dataDiNascita.focus();
       		return false;
       	} else if (dataDiNascita.substring(6,10) == today.getFullYear() &&
       			   dataDiNascita.substring(3,5) > (today.getMonth()+1) ) {
       		alert("Impossibile utilizzare una data successiva alla data odierna");
       		document.invio.dataDiNascita.value = "";
       		document.invio.dataDiNascita.focus();
       		return false;
       	} else if (dataDiNascita.substring(6,10) == today.getFullYear() &&
    			   dataDiNascita.substring(3,5) == (today.getMonth()+1) &&
       			   dataDiNascita.substring(0,2) > today.getDate() ) {
       		alert("Impossibile utilizzare una data successiva alla data odierna");
       		document.invio.dataDiNascita.value = "";
       		document.invio.dataDiNascita.focus();
       		return false;
       	}
    else {
      document.invio.action = "creaUtente";
      var r = confirm ("Dati inseriti correttamente, si vuole procedere con la creazione dell'account?");
      if (r){
    	 document.invio.submit();
      }
   }
};

</script>
</body>
</html>