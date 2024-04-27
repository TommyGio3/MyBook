package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import beans.Cliente;
import utils.MyBookUtils;

public class ClienteDAO {
	private Connection con;

	public ClienteDAO(Connection connection) {
		this.con = connection;
	}
	//Popola il bean
	public void populateBean (ResultSet rs, Cliente cliente) throws SQLException { 
		cliente.setUsername(rs.getString("Username"));
		//cliente.setPassword(rs.getString("Password"));
		cliente.setIdTessera(rs.getInt("idTessera"));
		cliente.setEmail(rs.getString("Email"));
		cliente.setRuolo(rs.getString("Ruolo"));
	}
	//Controlla username e password del cliente
	public Cliente controllaUtente(String username, String password) throws SQLException {
		Cliente cliente = null;
		String query = "SELECT * FROM Cliente WHERE Username = ? and Password = ?";
		ResultSet result = null;
		PreparedStatement pstatement = null;
		
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setString(1, username);
			pstatement.setString(2, password);
			result = pstatement.executeQuery();
			while (result.next()) {
				cliente = new Cliente();
				cliente.setUsername(result.getString("Username"));
				this.populateBean(result, cliente);
			}
		} catch (SQLException e) {
		    e.printStackTrace();
			throw new SQLException(e);

		} finally {
			try {
				result.close();
			} catch (Exception e1) {
				throw new SQLException(e1);
			}
			try {
				pstatement.close();
			} catch (Exception e2) {
				throw new SQLException(e2);
			}
		}		
		return cliente;
	}
	//Crea un nuovo cliente
	public void creaCliente(String username, String password, String email ) throws SQLException {
		String query = "INSERT into Cliente (Username, Password, idTessera, Email, Ruolo) VALUES (?, ?, ?, ?, 'Customer')";
		PreparedStatement pstatement = null;		
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setString(1, username);
			pstatement.setString(2, password);
			pstatement.setInt(3, MyBookUtils.getLastInsertID(con));
			pstatement.setString(4, email);
			pstatement.executeUpdate();
		} catch (SQLException e) {
		    e.printStackTrace();
			throw new SQLException(e);
		} finally {
			try {
				pstatement.close();
			} catch (Exception e1) {}
		}
	}
	//Controlla se lo username è già in uso
	public boolean validaUsername(String username) throws SQLException {
		String query = "SELECT * from Cliente where Username = ?";
		boolean res = true;
		PreparedStatement pstatement = null;	
		ResultSet result = null;
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setString(1, username);
			result = pstatement.executeQuery();
			res = result.next();
			
		} catch (SQLException e) {
		    e.printStackTrace();
			throw new SQLException(e);
		} finally {
			try {
				pstatement.close();
			} catch (Exception e1) {}
		}
		return res;
	}
	
	//Controlla se l'email è già in uso
	public boolean validaEmail(String email) throws SQLException {
		String query = "SELECT * from Cliente where Email = ?";
		boolean res = true;
		PreparedStatement pstatement = null;	
		ResultSet result = null;
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setString(1, email);
			result = pstatement.executeQuery();
			res = result.next();
			
		} catch (SQLException e) {
		    e.printStackTrace();
			throw new SQLException(e);
		} finally {
			try {
				pstatement.close();
			} catch (Exception e1) {}
		}
		return res;
	}
		
	//Ottieni lo username dall'email
	public String ottieniUserDaEmail(String email) throws SQLException {
		String query = "SELECT Username from Cliente where Email = ?";
		String username = null;
		PreparedStatement pstatement = null;	
		ResultSet result = null;
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setString(1, email);
			result = pstatement.executeQuery();
			if(result.next()) {
				username = result.getString("Username");
			};
			
		} catch (SQLException e) {
		    e.printStackTrace();
			throw new SQLException(e);
		} finally {
			try {
				pstatement.close();
			} catch (Exception e1) {}
		}
		return username;
	}
	
	//Aggiorna la password
	public void aggiornaPwd(String username, String newPwd) throws SQLException {
		String query = "UPDATE `MyBook`.`Cliente` SET `Password` = ? WHERE (`Username` = ?)";
		PreparedStatement pstatement = null;		
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setString(1, newPwd);
			pstatement.setString(2, username);
			pstatement.executeUpdate();
		} catch (SQLException e) {
		    e.printStackTrace();
			throw new SQLException(e);
		} finally {
			try {
				pstatement.close();
			} catch (Exception e1) {}
		}
	}
	
	//Ottieni l'id della tessera dallo username
	public int ottieniIdTesseraDaUser(String username) throws SQLException {
		String query = "SELECT idTessera from Cliente where Username = ?";
		//boolean res = true;
		int idTessera = -1;
		PreparedStatement pstatement = null;	
		ResultSet result = null;
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setString(1, username);
			result = pstatement.executeQuery();
			if(result.next()) {
				idTessera= result.getInt("idTessera");
			};
			
		} catch (SQLException e) {
		    e.printStackTrace();
			throw new SQLException(e);
		} finally {
			try {
				pstatement.close();
			} catch (Exception e1) {}
		}
		return idTessera;
	}
}
