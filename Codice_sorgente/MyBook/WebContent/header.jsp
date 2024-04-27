<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%-- <p>Logged as: <c:out value="${currentUser.username}"></c:out></p> --%>
<c:choose>
	<c:when test="${currentUser.username != null}"> 
		<p><a style="float: right" href="<c:url value="logout"/>">Logout</a></p>
		<p id="loggedAs" style="float: right">Logged as: <c:out value="${currentUser.username}"></c:out></p>
	</c:when>	
	<c:otherwise>
		<script type="text/javascript">
			window.location.replace("http://localhost:8080/MyBook");
		</script>
	</c:otherwise>
</c:choose>
