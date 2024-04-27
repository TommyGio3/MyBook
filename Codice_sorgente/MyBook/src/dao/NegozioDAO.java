package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import beans.Negozio;


public class NegozioDAO {
	private Connection con;

	public NegozioDAO(Connection connection) {
		this.con = connection;
	}
	//Popola il bean
	public void populateBean (ResultSet rs, Negozio negozio) throws SQLException { 
		negozio.setIdNegozio(rs.getInt("idNegozio"));
		negozio.setNome(rs.getString("Nome"));
		negozio.setCittà(rs.getString("Città"));
		negozio.setIndirizzo(rs.getString("Indirizzo"));
	}
	//Ottieni tutti i negozi
	public List<Negozio> ottieniNegozi() throws SQLException {
		List<Negozio> negozi = new ArrayList<Negozio>();
		String query = "SELECT * from Negozio";
		ResultSet result = null;
		PreparedStatement pstatement = null;
		try {
			pstatement = con.prepareStatement(query);
			result = pstatement.executeQuery();
			while (result.next()) {
				Negozio negozio = new Negozio();
				this.populateBean(result, negozio);
				negozi.add(negozio);
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
		return negozi;
	}
	//Controlla la validità del negozio
	public boolean validaNomeCittàIndirizzo(String nome, String città, String indirizzo) throws SQLException {
		String query = "SELECT * from `Negozio` where Nome = ? and Città = ? and Indirizzo = ?";
		boolean res = true;
		PreparedStatement pstatement = null;	
		ResultSet result = null;
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setString(1, nome);
			pstatement.setString(2, città);
			pstatement.setString(3, indirizzo);
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
	//Crea un nuovo negozio
	public void creaNegozio(String nome, String città, String indirizzo) throws SQLException {
		String query = "INSERT into Negozio (Nome, Città, Indirizzo) VALUES (?, ?, ?)";
		PreparedStatement pstatement = null;		
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setString(1, nome);
			pstatement.setString(2, città);
			pstatement.setString(3, indirizzo);
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
	//Ottieni i negozi i cui magazzini contengono le copie di quel libro
	public List<Negozio> ottieniNegoziDaISBN(int ISBN) throws SQLException {
		List<Negozio> negozi = new ArrayList<Negozio>();
		String query = "SELECT DISTINCT Negozio.idNegozio, Negozio.Nome, Negozio.Città, Negozio.Indirizzo \n"
					 + "FROM Negozio, Libro, Copia_Libro, Magazzino where Libro.ISBN = ? \n"
					 + " and Libro.ISBN = Copia_Libro.Libro_ISBN and Copia_Libro.idMagazzino \n"
					 + " = Magazzino.idMagazzino and Negozio.idNegozio = Magazzino.idNegozio and Copia_Libro.Stato='DISPONIBILE'";
		ResultSet result = null;
		PreparedStatement pstatement = null;
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setInt(1, ISBN);
			result = pstatement.executeQuery();
			while (result.next()) {
				Negozio negozio = new Negozio();
				this.populateBean(result, negozio);
				negozi.add(negozio);
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
		return negozi;
	}
}
