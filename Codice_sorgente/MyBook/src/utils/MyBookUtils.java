package utils;

import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class MyBookUtils {
	//Ottieni l'ultimo id inserito
	public static int getLastInsertID (Connection con) throws SQLException {
		int lastID = -1;
		String query ="SELECT LAST_INSERT_ID() as lastID";
		ResultSet result = null;
		PreparedStatement pstatement = null;
		try {
			pstatement = con.prepareStatement(query);
			result = pstatement.executeQuery();
			if (result.next()) {
				lastID = result.getInt("lastID");
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
		return lastID;
	}
	//Filtra la stringa per speciali caratteri HTML per
	//prevenire attacchi di tipo 'command injection'
	public static String htmlFilter(String message) {
      if (message == null) return null;
      int len = message.length();
      StringBuffer result = new StringBuffer(len + 20);
      char aChar;
      for (int i = 0; i < len; ++i) {
          aChar = message.charAt(i);
          switch (aChar) {
              case '<': result.append("&lt;"); break;
          case '>': result.append("&gt;"); break;
          case '&': result.append("&amp;"); break;
          case '"': result.append("&quot;"); break;
              default: result.append(aChar);
          }
       }
       return (result.toString());
    }
    //Genera una password casuale
    public static String generateNewPwd() {
       String lower = "abcdefghijklmnopqrstuvwxyz";
       String upper = lower.toUpperCase();
       String numeri = "0123456789";
       String perRandom = upper + lower + numeri;
       int lunghezzaRandom = 20;
       SecureRandom sr = new SecureRandom();
       StringBuilder sb = new StringBuilder(lunghezzaRandom);
       for (int i = 0; i < lunghezzaRandom; i++) {
           int randomInt = sr.nextInt(perRandom.length());
           char randomChar = perRandom.charAt(randomInt);
           sb.append(randomChar);
           }
       return sb.toString();
    }	 
}
