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
import dao.CopiaLibroDAO;
import dao.OrdineDAO;
import dao.TesseraDAO;
import utils.SendMail;
import beans.Cliente;

@WebServlet("/acquistaLibro")
public class AcquistaLibro extends HttpServlet{
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
		
		// Ottieni i parametri dalla pagina di dettaglio libro
		
		String ISBNStr = request.getParameter("ISBN");
		int ISBN = Integer.parseInt(ISBNStr);
		String idMagazzinoStr = request.getParameter("magazzinoSelect");
		int idMagazzino = Integer.parseInt(idMagazzinoStr);
		String saldoStr = request.getParameter("saldo");
		float saldo = Float.parseFloat(saldoStr);
		String prezzoStr = request.getParameter("prezzo");
		float prezzo = Float.parseFloat(prezzoStr);
		int idTessera = -1;
		int idCopia = -1;
		//Il nuovo saldo sarà uguale alla differenza tra il vecchio saldo e 
		//il prezzo del libro
		float nuovo_saldo = saldo-prezzo;
		Cliente currentUser = (Cliente) session.getAttribute("currentUser");
		//Variabili per l'invio dell'email
		String username = currentUser.getUsername();
		String email = currentUser.getEmail();
		String messaggio = " \n "
				+ "grazie per il tuo ordine.\n"
				+ "Il libro sarà inviato all'indirizzo da te specificato in fase di registrazione.\n"
				+ "Per qualsiasi informazione non esitare a contattarci! \n"
				+ " \n "
				+ "A presto, \n"
				+ "MyBook";
		String oggetto = "Conferma acquisto";
		
		//Crea i DAO
		CopiaLibroDAO clDAO = new CopiaLibroDAO(connection);
		TesseraDAO tDAO = new TesseraDAO(connection);
		ClienteDAO cDAO = new ClienteDAO(connection);
		OrdineDAO oDAO = new OrdineDAO(connection);
		String error = null;
		
		try {
			// query db per ottienere l'id della copia
			idCopia = clDAO.ottieniIDCopia_da_ISBN_e_idMagazzino(ISBN, idMagazzino);
			// query db per settare una copia come 'VENDUTO'
			clDAO.acquistaCopiaLibro(idCopia);
			// query db per ottenere l'id della tessera dallo username
			idTessera = cDAO.ottieniIdTesseraDaUser(username);
			// query db per aggiornare il saldo della tessera
			tDAO.aggiornaSaldoDaIdTessera(idTessera, nuovo_saldo);
			// query db per creare un nuovo ordine di acquisto
			oDAO.creaOrdine(username, idTessera, idCopia);
			// invia una mail di conferma acquisto
			SendMail.sendEmail("Ciao " + username + ", \n" + messaggio, oggetto, email);
		} catch (RuntimeException e3) {
			error = "Error in sending mail " + e3.getMessage(); 
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		if (error != null) {
			response.sendError(505, error);
		} else {
			String path = getServletContext().getContextPath() + "/succAcquisto.html";
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


