package controllers;


import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.UnavailableException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.ClienteDAO;

@WebServlet("/aggiornaPwd")
public class AggiornaPwd extends HttpServlet{
	private static final long serialVersionUID = 1L;
	private Connection connection;

	
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

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session == null) {
			String path = getServletContext().getContextPath();
			response.sendRedirect(path);
		}
		
		// Ottieni i parametri dalla pagina di cambio password
		String username = request.getParameter("username");
		String newPwd = request.getParameter("newPwd");
		
		
		//Crea il DAO
		ClienteDAO cDAO = new ClienteDAO(connection);
		
		String error = null;

		try {
			//query db per aggiornare la password
			cDAO.aggiornaPwd(username, newPwd);
			
			
		} catch (SQLException e3) {
			error = "Bad database insertion input " + e3.getMessage(); 
		} 
		if (error != null) {
			response.sendError(505, error);
		} else {
			String path = getServletContext().getContextPath() + "/succAggPwd.html";
			response.sendRedirect(path);
		}
	}
	
	public void destroy() {
		try {
			if (connection != null) {
				connection.close();
			}
		} catch (SQLException sqle) {
		}
	}	
}


