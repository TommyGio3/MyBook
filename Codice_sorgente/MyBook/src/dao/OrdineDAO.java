package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import beans.Ordine;

public class OrdineDAO {
	private Connection con;

	public OrdineDAO(Connection connection) {
		this.con = connection;
	}
	//Popola il bean
	public void populateBean (ResultSet rs, Ordine ordine) throws SQLException { 
		ordine.setIdOrdine(rs.getInt("idOrdine"));
		ordine.setCliente_username(rs.getString("Cliente_Username"));
		ordine.setCopiaLibro(rs.getInt("idCopiaLibro"));
		ordine.setIdTessera(rs.getInt("idTessera"));
		ordine.setDataOrdine(rs.getDate("Data_ordine"));
	}
	//Crea un nuovo ordine
	public void creaOrdine(String username, int idTessera, int copiaLibro) throws SQLException {
		String query = "INSERT into Ordine (Cliente_Username, idTessera, Data_Ordine, idCopiaLibro) VALUES (?, ?, ?, ?)";
		PreparedStatement pstatement = null;		
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setString(1, username);
			pstatement.setInt(2, idTessera);
			pstatement.setDate(3, new Date(System.currentTimeMillis()));
			pstatement.setInt(4, copiaLibro);
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
	//Ottieni tutti gli ordini effettuati da quell'utente
	public List<Ordine> ottieniOrdiniDaUsername(String username) throws SQLException {
		List<Ordine> ordini = new ArrayList<Ordine>();
		String query = "SELECT * from Ordine where Cliente_Username = ?";
		ResultSet result = null;
		PreparedStatement pstatement = null;
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setString(1, username);
			result = pstatement.executeQuery();
			while (result.next()) {
				Ordine ordine = new Ordine();
				this.populateBean(result, ordine);
				ordini.add(ordine);
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
		return ordini;
	}
}
