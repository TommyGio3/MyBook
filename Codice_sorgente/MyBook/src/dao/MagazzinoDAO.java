package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import beans.Magazzino;

public class MagazzinoDAO {
	private Connection con;

	public MagazzinoDAO(Connection connection) {
		this.con = connection;
	}
	//Popola il bean
	public void populateBean (ResultSet rs, Magazzino magazzino) throws SQLException { 
		magazzino.setIdMagazzino(rs.getInt("idMagazzino"));
		magazzino.setCittà(rs.getString("Città"));
		magazzino.setIndirizzo(rs.getString("Indirizzo"));
		magazzino.setIdNegozio(rs.getInt("idNegozio"));
	}
	//Ottieni tutti i magazzini di quel negozio
	public List<Magazzino> ottieniMagazziniDaIDNegozio(int idNegozio) throws SQLException {
		List<Magazzino> magazzini = new ArrayList<Magazzino>();
		String query = "SELECT * from Magazzino where idNegozio = ?";
		ResultSet result = null;
		PreparedStatement pstatement = null;
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setInt(1, idNegozio);
			result = pstatement.executeQuery();
			while (result.next()) {
				Magazzino magazzino = new Magazzino();
				this.populateBean(result, magazzino);
				magazzini.add(magazzino);
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
		return magazzini;
	}
	//Crea un nuovo magazzino
	public void creaMagazzino(String città, String indirizzo, int idNegozio) throws SQLException {
		String query = "INSERT into Magazzino (Città, Indirizzo, idNegozio) VALUES (?, ?, ?)";
		PreparedStatement pstatement = null;		
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setString(1, città);
			pstatement.setString(2, indirizzo);
			pstatement.setInt(3, idNegozio);
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
	
	//Controlla se il magazzino è già presente nel db
	public boolean validaMagazzino(String città, String indirizzo) throws SQLException {
		String query = "SELECT * from `Magazzino` where Città  = ? and Indirizzo = ?";
		boolean res = true;
		PreparedStatement pstatement = null;	
		ResultSet result = null;
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setString(1, città);
			pstatement.setString(2, indirizzo);
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
	//Ottieni i magazzini che contengono quel libro e che appartengono a quel negozio
	public List<Magazzino> ottieniMagazziniDaISBNeIdNegozio(int ISBN, int idNegozio) throws SQLException {
		List<Magazzino> magazzini = new ArrayList<Magazzino>();
		String query = "SELECT DISTINCT Magazzino.idMagazzino, Magazzino.Città, Magazzino.Indirizzo, Magazzino.idNegozio \n"
					 + "FROM Negozio, Libro, Copia_Libro, Magazzino where Libro.ISBN = ? \n"
					 + " and Libro.ISBN = Copia_Libro.Libro_ISBN and Copia_Libro.idMagazzino \n"
					 + " = Magazzino.idMagazzino and Negozio.idNegozio = Magazzino.idNegozio \n"
					 + "and Negozio.idNegozio = ? and Copia_Libro.Stato='DISPONIBILE'";
		ResultSet result = null;
		PreparedStatement pstatement = null;
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setInt(1, ISBN);
			pstatement.setInt(2, idNegozio);
			result = pstatement.executeQuery();
			while (result.next()) {
				Magazzino magazzino = new Magazzino();
				this.populateBean(result, magazzino);
				magazzini.add(magazzino);
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
		return magazzini;
	}
}
