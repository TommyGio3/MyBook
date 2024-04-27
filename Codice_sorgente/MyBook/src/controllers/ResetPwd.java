package controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.UnavailableException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.ClienteDAO;
import utils.MyBookUtils;
import utils.SendMail;


@WebServlet("/resetPwd")
public class ResetPwd extends HttpServlet{
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
		
		// Ottieni i parametri dalla pagina di reset password
		String email = request.getParameter("email");
		String newPwd = MyBookUtils.generateNewPwd();
		String message = "Password temporanea :" + newPwd + "\n\t" + "Per cambiare la tua password clicca quì: http://localhost:8080/MyBook/cambioPwd.jsp";
		String oggetto = "Cambio password";
		
		//Crea il DAO
		ClienteDAO cDAO = new ClienteDAO(connection);
		String error = null;

		try {
			//Ottieni username
			String username = cDAO.ottieniUserDaEmail(email);
			//Invia una mail all'utente
			SendMail.sendEmail("Ciao " + username + ", \n" + message, oggetto, email);
			//Crea un cookie con il nome 'resetPwd_username' e come valore la password temporanea
			Cookie cookie = new Cookie("resetPwd_" + username, newPwd);
			//Setta il tempo di scadenza
			//1 ora = 60 secondi x 60 minuti
			 cookie.setMaxAge(60 * 60);
			 //Aggiungi il cookie alla risposta
			 response.addCookie(cookie);
			
		} catch (RuntimeException e3) {
			error = "Error in sending mail " + e3.getMessage(); 
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		if (error != null) {
			response.sendError(505, error);
		} else {
			String path = getServletContext().getContextPath() + "/cambioPwd.jsp";
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


