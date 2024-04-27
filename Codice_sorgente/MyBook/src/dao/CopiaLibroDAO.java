package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CopiaLibroDAO {
	private Connection con;

	public CopiaLibroDAO(Connection connection) {
		this.con = connection;
	}
	//Crea una copia del libro
	public void creaCopiaLibro(int idMagazzino, int libro_ISBN) throws SQLException {
		String query = "INSERT into `Copia_Libro` (idMagazzino, Libro_ISBN, Stato) VALUES (?, ?, 'DISPONIBILE')";
		PreparedStatement pstatement = null;		
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setInt(1, idMagazzino);
			pstatement.setInt(2, libro_ISBN);
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
	//Ottieni l'id di una copia del libro dall'ISBN del libro e dal magazzino che contiene la copia
	public int ottieniIDCopia_da_ISBN_e_idMagazzino(int ISBN, int idMagazzino) throws SQLException {
		String query = "SELECT * from Copia_Libro where idMagazzino = ? and Libro_ISBN = ? and Stato = 'DISPONIBILE' limit 1";
		int idCopia = -1;
		PreparedStatement pstatement = null;	
		ResultSet result = null;
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setInt(1, idMagazzino);
			pstatement.setInt(2, ISBN);
			result = pstatement.executeQuery();
			if(result.next()) {
				idCopia= result.getInt("idCopia_libro");
			};
			
		} catch (SQLException e) {
		    e.printStackTrace();
			throw new SQLException(e);
		} finally {
			try {
				pstatement.close();
			} catch (Exception e1) {}
		}
		return idCopia;
	}
	//Acquista una copia del libro, quindi settala come venduta
	public void acquistaCopiaLibro(int idCopia) throws SQLException {
		String query = "UPDATE `MyBook`.`Copia_Libro` SET `Stato` = 'VENDUTO' WHERE (`idCopia_libro` = ?)";
		PreparedStatement pstatement = null;		
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setInt(1, idCopia);
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
	
}
