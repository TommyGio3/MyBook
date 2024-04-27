package controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.UnavailableException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.ClienteDAO;
import dao.TesseraDAO;
import dao.AnagraficaClienteDAO;

@WebServlet("/creaUtente")
public class CreaUtente extends HttpServlet{
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
		
		// Ottieni i parametri dal form di registrazione nella pagina registrazione.jsp 
		String email = request.getParameter("email");
		String username = request.getParameter("username");
		String password = request.getParameter("psw");
		String nome = request.getParameter("nome");
		String cognome = request.getParameter("cognome");
		String codiceFiscale = request.getParameter("codiceFiscale");
		String indirizzo = request.getParameter("indirizzo");
		String dataDiNascitaStr = request.getParameter("dataDiNascita");
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
		
		//Crea i DAO
		TesseraDAO tDAO = new TesseraDAO(connection);
		ClienteDAO clDAO = new ClienteDAO(connection);
		AnagraficaClienteDAO anClDAO = new AnagraficaClienteDAO(connection);
		
		String error = null;
		try {
			// fa il parsing del parametro da String a Date
			java.util.Date dataDiNascitaParsed = sdf.parse(dataDiNascitaStr);  
			java.sql.Date dataDiNascita = new java.sql.Date(dataDiNascitaParsed.getTime());
			
			//query db per creare una nuova tessera da associare al cliente
			tDAO.creaTessera();
			// query db per creare un nuovo cliente
			clDAO.creaCliente(username, password, email);
			//quey db per creare una nuova anagrafica cliente
			anClDAO.creaAnagraficaCliente(nome, cognome, codiceFiscale, indirizzo, dataDiNascita, username);
			
		} catch (SQLException e3) {
			error = "Bad database insertion input " + e3.getMessage(); 
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			error ="Error in parsing dataDiNascita";
		} 
		if (error != null) {
			response.sendError(505, error);
		} else {
			String path = getServletContext().getContextPath() + "/index.jsp";
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
