package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public class TesseraDAO {
	private Connection con;

	public TesseraDAO(Connection connection) {
		this.con = connection;
	}
	
	//Crea una nuova tessera
	public void creaTessera() throws SQLException {
		String query = "INSERT into Tessera (Saldo) VALUES (0)";
		PreparedStatement pstatement = null;		
		try {
			pstatement = con.prepareStatement(query);
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
	//Ottieni il saldo della tessera
	public float ottieniSaldoDaIdTessera(int idTessera) throws SQLException {
		String query = "SELECT Saldo from Tessera where idTessera = ?";
		//boolean res = true;
		float saldo = -1;
		PreparedStatement pstatement = null;	
		ResultSet result = null;
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setInt(1, idTessera);
			result = pstatement.executeQuery();
			if(result.next()) {
				saldo = result.getFloat("Saldo");
			};
			
		} catch (SQLException e) {
		    e.printStackTrace();
			throw new SQLException(e);
		} finally {
			try {
				pstatement.close();
			} catch (Exception e1) {}
		}
		return saldo;
	}
	//Aggiorna il saldo della tessera
	public void aggiornaSaldoDaIdTessera(int idTessera, float saldo) throws SQLException {
		String query = "UPDATE `MyBook`.`Tessera` SET `Saldo` = ? WHERE (`idTessera` = ?)";
		PreparedStatement pstatement = null;		
		try {
			pstatement = con.prepareStatement(query);
			pstatement.setFloat(1, saldo);
			pstatement.setInt(2, idTessera);
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

