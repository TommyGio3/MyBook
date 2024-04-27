package controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.UnavailableException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import beans.Libro;
import dao.LibroDAO;
import utils.MyBookUtils;

@WebServlet("/ottieniLibroDaTitoloPagPrinc")
public class OttieniLibroDaTitoloPagPrinc extends HttpServlet{
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
		//Ottieni i parametri dalla pagina principale e filtrali per evitare
		//sql injection
		String titolo = MyBookUtils.htmlFilter(request.getParameter("titolo"));
		String autore = MyBookUtils.htmlFilter(request.getParameter("autore"));
		int idLibro = -1;
		
		//Crea il DAO
		LibroDAO lDAO = new LibroDAO(connection);
		
		List <Libro> libri = new ArrayList <Libro>();
		String error = null;
		try {
			// query db per validare titolo e autore e ottenere l'ISBN del libro
			idLibro = lDAO.validaTitoloAutore(titolo, autore);
			// query db per trovare il libro dall'ISBN
			libri = lDAO.trovaLibriDaISBN(idLibro);
			request.setAttribute("libri", libri);
		} catch (SQLException e3) {
			error = "Bad database insertion input " + e3.getMessage(); 
		} 
		if (error != null) {
			response.sendError(505, error);
		} else {
			String path = "/dettaglioLibro.jsp";
			RequestDispatcher dispatcher = request.getRequestDispatcher(path);
			dispatcher.forward(request, response);
		}
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request,response);
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



