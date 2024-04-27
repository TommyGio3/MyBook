package controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Date;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.UnavailableException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import beans.Cliente;
import dao.ClienteDAO;

@WebServlet("/login")
public class ControllaLogin extends HttpServlet{
	private static final long serialVersionUID = 1L;
	private Connection connection = null;

	public void init() throws ServletException {
		try {
			ServletContext context = getServletContext();
			String driver = context.getInitParameter("dbDriver");
			String url = context.getInitParameter("dbUrl");
			String user = context.getInitParameter("dbUser");
			String password = context.getInitParameter("dbPassword");
			Class.forName(driver);
			connection = DriverManager.getConnection(url, user, password);

		} catch (ClassNotFoundException e) {
		    e.printStackTrace();
			throw new UnavailableException("Can't load database driver");
		} catch (SQLException e) {
		    e.printStackTrace();
			throw new UnavailableException("Couldn't get db connection");
		}
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String username = request.getParameter("username");
	    String password = request.getParameter("psw");
	    
		if (username == null || password == null) {
			response.sendError(505, "Parameters incomplete");
			return;
		}
		ClienteDAO clienteDAO = new ClienteDAO(connection);
		try { 
			// query db per controllare la correttezza di username e password 
			Cliente cliente = clienteDAO.controllaUtente(username, password);
			//Se il cliente esiste, aggiunge info alla sessione e va alla pagina principale,
			//altrimenti mostra una pagina di errore
			if (cliente != null) {
				HttpSession session = request.getSession();
				session.setAttribute("currentUser", cliente);
				session.setAttribute("loginDate", new Date(System.currentTimeMillis()));
				String ruolo = cliente.getRuolo();
				//se il ruolo dell'utente è Customer allora reindirizza alla pagina principale
				if (ruolo.equalsIgnoreCase("Customer")){
					String path = getServletContext().getContextPath() + "/paginaPrincipale.jsp";
					response.sendRedirect(path);
				}
				//se il ruolo è Admin allora reindirizza al menu Admin
				if(ruolo.equalsIgnoreCase("Admin")) {
					String path = getServletContext().getContextPath() + "/menuAdmin.jsp";
					response.sendRedirect(path);
				}
			}
			else {
				String errorPath = getServletContext().getContextPath() + "/errorLoginPage.html";
				response.sendRedirect(errorPath);
			}
		} catch (SQLException e) {
			response.sendError(500, "Database access failed");
		}
	}
	
	public void destroy() {
		try {
			if (connection != null) {
				connection.close();
			}
		} catch (SQLException sqle) {}
	}	
}

