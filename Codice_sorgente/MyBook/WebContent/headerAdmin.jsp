<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%-- <p>Logged as: <c:out value="${currentUser.username}"></c:out></p> --%>
<c:url value="logout" var="createUrl"/>
<c:choose>
	<c:when test="${currentUser.username != null && currentUser.ruolo == 'Admin'}"> 
		<form action="${createUrl}"><button id="adminButton" class="button" style="float: right">Logout</button></form>
		<p id="loggedAs" style="float: right">Logged as: <c:out value="${currentUser.username}"></c:out></p>
	</c:when>	
	<c:otherwise>
		<script type="text/javascript">
			window.location.replace("http://localhost:8080/MyBook");
		</script>
	</c:otherwise>
</c:choose>
