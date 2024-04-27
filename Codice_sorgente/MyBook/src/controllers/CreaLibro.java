package controllers;

import java.io.IOException;
import java.io.InputStream;
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
import javax.servlet.http.Part;

import dao.CopiaLibroDAO;
import dao.LibroDAO;
import utils.MyBookUtils;

@WebServlet("/creaLibro")
@MultipartConfig
public class CreaLibro extends HttpServlet{
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
		
		// Ottieni i parametri dalla pagina di inserimento libro
		String titolo = request.getParameter("titolo");
		String autore = request.getParameter("autore");
		String genere = request.getParameter("genereSelect");
		String descrizione = request.getParameter("descrizione");
		String disponibilitàStr = request.getParameter("disponibilita");
		int disponibilità = Integer.parseInt(disponibilitàStr);
		String prezzoStr = request.getParameter("prezzo");
		float prezzo = -1;
		if(prezzoStr != null) {
			prezzo = Float.parseFloat(prezzoStr);
		}
		String idMagazzinoStr = request.getParameter("magazzinoSelect");
		int idMagazzino = Integer.parseInt(idMagazzinoStr);
		Part imagePart = request.getPart("immagine");
		//Ottieni l'immagine e gestiscila come un InputStream (imageStream)
		InputStream imageStream = null;
		String mimeType = null;
		if (imagePart != null) {
			imageStream = imagePart.getInputStream();
			String filename = imagePart.getSubmittedFileName();
			mimeType = getServletContext().getMimeType(filename);			
		}
		if (imageStream == null || (imageStream.available()==0) || !mimeType.startsWith("image/")) {
			response.sendError(505, "File image not valid");
			return;
		}
		
		//Crea i DAO
		LibroDAO lDAO = new LibroDAO(connection);
		CopiaLibroDAO coLiDAO = new CopiaLibroDAO(connection);
		int libroISBN = -1;
		
		String error = null;

		try {
			//query db per controllare la validità di titolo e autore 
			//e ottenere l'ISBN attraverso titolo e autore
			libroISBN = lDAO.validaTitoloAutore(titolo, autore);
			//se l'ISBN è < 0 quindi se il libro non è già presente nel catalogo e ho preso 
			//correttamente il parametro prezzo (prezzo > 0), allora crea un nuovo libro e 
			//va a sovrascrivere il parametro libroISBN
			if(libroISBN < 0 && prezzo > 0) {
				//query db per creare un nuovo libro
				lDAO.creaLibro(titolo, autore, genere, disponibilità, prezzo, descrizione, imageStream);
				//l'ISBN sarà l'ISBN del libro appena inserito col metodo soprastante
				libroISBN = MyBookUtils.getLastInsertID(connection);
			}
			//inserisce copie del libro in numero corrispondente al parametro immesso nel campo
			//disponibilità del form
			for (int i=0; i < disponibilità; i++) {
			// query db per inserire una copia del libro all'interno del magazzino passato
			// come parametro
			coLiDAO.creaCopiaLibro(idMagazzino, libroISBN);
			}
			
		} catch (SQLException e3) {
			error = "Bad database insertion input " + e3.getMessage(); 
		} 
		if (error != null) {
			response.sendError(505, error);
		} else {
			String path = getServletContext().getContextPath() + "/succInsertLibro.html";
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

