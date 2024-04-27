package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Date;

import beans.AnagraficaCliente;

public class AnagraficaClienteDAO {
	private Connection con;

	public AnagraficaClienteDAO(Connection connection) {
		this.con = connection;
	}
	//Popola il bean
	public void populateBean (ResultSet rs, AnagraficaCliente anCl) throws SQLException { 
		anCl.setClienteUsername(rs.getString("Cliente_Username"));
		anCl.setCodiceFiscale(rs.getString("CF"));
		anCl.setNome(rs.getString("Nome"));
		anCl.setCognome(rs.getString("Cognome"));
		anCl.setIndirizzo(rs.getString("Indirizzo"));
		anCl.setDataDiNascita(rs.getDate("Data_di_nascita"));
	}
	
	//Crea una nuvoa anagrafica cliente
	public void creaAnagraficaCliente(String nome, String cognome, String codFiscale, String indirizzo, Date dataDiNascita, String clienteUsername) throws SQLException {
		String query = "INSERT into `Anagrafica_Cliente` (Nome, Cognome, CF, Indirizzo, Data_di_nascita, Cliente_Username) VALUES (?, ?, ?, ?, ?, ?)";
		PreparedStatement pstatement = null;		
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setString(1, nome);
			pstatement.setString(2, cognome);
			pstatement.setString(3, codFiscale);
			pstatement.setString(4, indirizzo);
			pstatement.setDate(5, dataDiNascita);
			pstatement.setString(6, clienteUsername);
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
	//Controlla se il codice fiscale è già in uso
	public boolean validaCodiceFiscale(String codFisc) throws SQLException {
		String query = "SELECT * from `Anagrafica_Cliente` where CF = ?";
		boolean res = true;
		PreparedStatement pstatement = null;	
		ResultSet result = null;
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setString(1, codFisc);
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
	
	//Ottieni la lista dell'anagrafica cliente dallo username
	public List<AnagraficaCliente> ottieniAnCliente(String username) throws SQLException {
		List<AnagraficaCliente> anCliente = new ArrayList<AnagraficaCliente>();
		String query = "SELECT * from `Anagrafica_Cliente` where Cliente_Username = ?";
		ResultSet result = null;
		PreparedStatement pstatement = null;
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setString(1, username);
			result = pstatement.executeQuery();
			while (result.next()) {
				AnagraficaCliente anCl = new AnagraficaCliente();
				this.populateBean(result, anCl);
				anCliente.add(anCl);
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
		return anCliente;
	}
}
