package dao;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

import beans.Libro;

public class LibroDAO {
	private Connection con;

	public LibroDAO(Connection connection) {
		this.con = connection;
	}
	//Popola il bean
	public void populateBean (ResultSet rs, Libro libro) throws SQLException { 
		libro.setTitolo(rs.getString("Titolo"));
		libro.setAutore(rs.getString("Autore"));
		libro.setGenere(rs.getString("Genere"));
		libro.setDisponibilità(rs.getInt("Disponibilità"));
		libro.setPrezzo(rs.getFloat("Prezzo"));
		libro.setDescrizione(rs.getString("Descrizione"));
		byte[] imgData = rs.getBytes("Immagine");
		String encodedImg=Base64.getEncoder().encodeToString(imgData);
		libro.setImmagine(encodedImg);
		libro.setISBN(rs.getInt("ISBN"));
	}
	//Crea un nuovo libro
	public void creaLibro(String titolo, String autore, String genere, int disponibilità, float prezzo, String descrizione, InputStream imageStream) throws SQLException {
		String query = "INSERT into Libro (Titolo, Autore, Genere, Disponibilità, Prezzo, Descrizione, Immagine) VALUES (?, ?, ?, ?, ?, ?, ?)";
		PreparedStatement pstatement = null;		
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setString(1, titolo);
			pstatement.setString(2, autore);
			pstatement.setString(3, genere);
			pstatement.setInt(4, disponibilità);
			pstatement.setFloat(5, prezzo);
			pstatement.setString(6, descrizione);
			pstatement.setBlob(7, imageStream);
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
	
	//Controlla la validità di titolo e autore e ritorna l'id del libro se trovato
	public int validaTitoloAutore(String titolo, String autore) throws SQLException {
		String query = "SELECT * from Libro where Titolo = ? and Autore = ?";
		//boolean res = true;
		int idLibro = -1;
		PreparedStatement pstatement = null;	
		ResultSet result = null;
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setString(1, titolo);
			pstatement.setString(2, autore);
			result = pstatement.executeQuery();
			if(result.next()) {
				idLibro= result.getInt("ISBN");
			};
			
		} catch (SQLException e) {
		    e.printStackTrace();
			throw new SQLException(e);
		} finally {
			try {
				pstatement.close();
			} catch (Exception e1) {}
		}
		return idLibro;
	}
	//Ottieni la lista di tutti i libri
	public List<Libro> ottieniLibri() throws SQLException {
		List<Libro> libri = new ArrayList<Libro>();
		String query = "SELECT * from Libro";
		ResultSet result = null;
		PreparedStatement pstatement = null;
		try {
			pstatement = con.prepareStatement(query);
			result = pstatement.executeQuery();
			while (result.next()) {
				Libro libro = new Libro();
				this.populateBean(result, libro);
				libri.add(libro);
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
		return libri;
	}
	//Ottieni tutti i libri dal titolo
	public List<Libro> ottieniLibriDaTitolo(String titolo) throws SQLException {
		List<Libro> libri = new ArrayList<Libro>();
		String query = "SELECT * from Libro where Titolo = ?";
		ResultSet result = null;
		PreparedStatement pstatement = null;
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setString(1, titolo);
			result = pstatement.executeQuery();
			while (result.next()) {
				Libro libro = new Libro();
				this.populateBean(result, libro);
				libri.add(libro);
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
		return libri;
	}
	//Aggiorna il prezzo del libro
	public void aggiornaPrezzo(String titolo, String autore, float prezzo ) throws SQLException {
		String query = "UPDATE `MyBook`.`Libro` SET `Prezzo` = ? WHERE (`Titolo` = ?) and (`Autore` = ?)";
		PreparedStatement pstatement = null;		
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setFloat(1, prezzo);
			pstatement.setString(2, titolo);
			pstatement.setString(3, autore);
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
	//Ottieni i libri che corrispondono alla ricerca
	public List<Libro> trovaLibriDaRicerca(String inputSearch) throws SQLException {
		List<Libro> libri = new ArrayList<Libro>();
		String query = "SELECT * from Libro where Titolo LIKE ?";
		ResultSet result = null;
		PreparedStatement pstatement = null;
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setString(1, "%" + inputSearch + "%");
			result = pstatement.executeQuery();
			while (result.next()) {
				Libro libro = new Libro();
				this.populateBean(result, libro);
				libri.add(libro);
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
		return libri;
	}
	//Ottieni il libro dall'ISBN
	public List<Libro> trovaLibriDaISBN(int ISBN) throws SQLException {
		List<Libro> libri = new ArrayList<Libro>();
		String query = "SELECT * from Libro where ISBN = ?";
		ResultSet result = null;
		PreparedStatement pstatement = null;
		try {
			pstatement = con.prepareStatement(query);
			//pstatement.setString(1, username);
			pstatement.setInt(1,ISBN);
			result = pstatement.executeQuery();
			while (result.next()) {
				Libro libro = new Libro();
				this.populateBean(result, libro);
				libri.add(libro);
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
		return libri;
	}
	//Ottieni tutti i libri di quel genere
	public List<Libro> ottieniLibriDaGenere(String genere) throws SQLException {
		List<Libro> libri = new ArrayList<Libro>();
		String query = "SELECT * from Libro where Genere = ?";
		ResultSet result = null;
		PreparedStatement pstatement = null;
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setString(1, genere);
			result = pstatement.executeQuery();
			while (result.next()) {
				Libro libro = new Libro();
				this.populateBean(result, libro);
				libri.add(libro);
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
		return libri;
	}
	//Ottieni una lista di 20 libri
	public List<Libro> ottieniRandomLibri() throws SQLException {
		List<Libro> libri = new ArrayList<Libro>();
		String query = "SELECT * from Libro limit 20";
		ResultSet result = null;
		PreparedStatement pstatement = null;
		try {
			pstatement = con.prepareStatement(query);
			result = pstatement.executeQuery();
			while (result.next()) {
				Libro libro = new Libro();
				this.populateBean(result, libro);
				libri.add(libro);
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
		return libri;
	}
	
	//Ottieni il libro da copia libro
	public List<Libro> ottieniLibroDaCopiaLibro(int idCopiaLibro) throws SQLException {
		List<Libro> libri = new ArrayList<Libro>();
		String query = "SELECT DISTINCT Libro.Titolo, Libro.Autore, Libro.Genere, Libro.Disponibilità, Libro.Prezzo, Libro.Descrizione, Libro.Immagine, Libro.ISBN from Libro, Copia_Libro where idCopia_Libro = ? and Libro_ISBN = ISBN";
		ResultSet result = null;
		PreparedStatement pstatement = null;
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setInt(1, idCopiaLibro);
			result = pstatement.executeQuery();
			while (result.next()) {
				Libro libro = new Libro();
				this.populateBean(result, libro);
				libri.add(libro);
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
		return libri;
	}
}
