/**
 * utils
 */
    //Crea un cookie
    function setCookie(cname, cvalue, exdays) {
	  const d = new Date();
	  d.setTime(d.getTime() + (exdays*24*60*60*1000));
	  let expires = "expires="+ d.toUTCString();
	  document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
	};
    //Ottieni il cookie
	function getCookie(cname) {
	  let name = cname + "=";
	  let decodedCookie = decodeURIComponent(document.cookie);
	  let ca = decodedCookie.split(';');
	  for(let i = 0; i <ca.length; i++) {
	    let c = ca[i];
	    while (c.charAt(0) == ' ') {
	      c = c.substring(1);
	    }
	    if (c.indexOf(name) == 0) {
	      return c.substring(name.length, c.length);
	    }
	  }
	  return "";
	};
	
	//ritorna il cookie se il cookie esiste, altrimenti null
	function checkCookie(cookieName) {
	  let cookie = getCookie(cookieName);
	  if (cookie != "") {
	  	return cookie;
	  } else {
	   return null;
	   }
	};
		
		
	