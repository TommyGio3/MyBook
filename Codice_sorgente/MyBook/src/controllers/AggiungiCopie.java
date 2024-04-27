package controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.UnavailableException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.CopiaLibroDAO;
import dao.LibroDAO;

@WebServlet("/aggiungiCopie")
@MultipartConfig
public class AggiungiCopie extends HttpServlet{
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
		if (session == null || session.getAttribute("currentUser") == null) {
			String path = getServletContext().getContextPath();
			response.sendRedirect(path);
		}
		
		// Ottieni i parametri dalla pagina di aggiornamento copie o di dettaglio copie
		String titolo = request.getParameter("titoloSelect");
		String autore = request.getParameter("autoreSelect");
		String disponibilitàStr = request.getParameter("disponibilita");
		int disponibilità = Integer.parseInt(disponibilitàStr);
		String idMagazzinoStr = request.getParameter("magazzinoSelect");
		int idMagazzino = Integer.parseInt(idMagazzinoStr);
		
		//Crea i DAO
		LibroDAO lDAO = new LibroDAO(connection);
		CopiaLibroDAO coLiDAO = new CopiaLibroDAO(connection);
		int libroISBN = -1;
		
		String error = null;

		try {
			// query db per validare titolo e autore ed ottenere l'ISBN del libri trovato
			libroISBN = lDAO.validaTitoloAutore(titolo, autore);
			//esegui la query tante volte quante il numero di copie da aggiungere
			for (int i=0; i < disponibilità; i++) {
			// query db per creare una nuova copia del libro
			coLiDAO.creaCopiaLibro(idMagazzino, libroISBN);
			}
			
		} catch (SQLException e3) {
			error = "Bad database insertion input " + e3.getMessage(); 
		} 
		if (error != null) {
			response.sendError(505, error);
		} else {
			String path = getServletContext().getContextPath() + "/succAggCopie.html";
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


