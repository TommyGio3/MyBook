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

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import dao.ClienteDAO;
import dao.TesseraDAO;

@WebServlet("/ottieniSaldo")
public class OttieniSaldo extends HttpServlet{
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

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("currentUser") == null) {
			String path = getServletContext().getContextPath();
			response.sendRedirect(path);
		}
		//Ottieni i parametri dalla pagina di dettaglio libro o dalla 
		//pagina di profilo
		String username = request.getParameter("username");
		float saldo = -1;
		int idTessera = -1;
		
		//Crea i DAO
		ClienteDAO cDAO = new ClienteDAO(connection);
		TesseraDAO tDAO = new TesseraDAO(connection);
		
		String error = null;
		try {
			// query db per ottenere l'id della tessera dal username
			idTessera = cDAO.ottieniIdTesseraDaUser(username);
			// query db per ottenere il saldo della tessera dall'id della tessera
			saldo = tDAO.ottieniSaldoDaIdTessera(idTessera);
			
		} catch (SQLException e3) {
			error = "Bad database insertion input " + e3.getMessage(); 
		} 
		if (error != null) {
			response.sendError(505, error);
		} else {
			// crea una risposta json
			Gson gson = new GsonBuilder().create();
			String json = gson.toJson(saldo);
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().write(json);
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



