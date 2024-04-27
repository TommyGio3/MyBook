package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import beans.Genere;

public class GenereDAO {
	private Connection con;

	public GenereDAO(Connection connection) {
		this.con = connection;
	}
	//Popola il bean
	public void populateBean (ResultSet rs, Genere genere) throws SQLException { 
		genere.setTipo(rs.getString("Nome"));
	}
	//Ottieni tutti i generi
	public List<Genere> ottieniGeneri() throws SQLException {
		List<Genere> generi = new ArrayList<Genere>();
		String query = "SELECT * from Genere";
		ResultSet result = null;
		PreparedStatement pstatement = null;
		try {
			pstatement = con.prepareStatement(query);
			result = pstatement.executeQuery();
			while (result.next()) {
				Genere genere = new Genere();
				this.populateBean(result, genere);
				generi.add(genere);
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
		return generi;
	}
}
