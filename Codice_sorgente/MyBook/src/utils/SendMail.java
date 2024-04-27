package utils;

import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;

public class SendMail {
	//Definisci tutti i parametri per inviare una mail e poi manda la mail
	public static void sendEmail(String messaggio, String oggetto, String emailDest) {
		//Mittente
		final String sender = "MyBook.helpdesk@gmail.com";
		
		//Username del mittente
		final String username = "MyBook.helpdesk@gmail.com";
		
		//Password mittente
		final String password = "MyBook123!";

		//Ottieni le proprietà di sistema
		Properties props = new Properties();			
		
		//Abilita authentication
		props.put("mail.smtp.auth", "true");			
		
		//Abilita STARTTLS
		props.put("mail.smtp.starttls.enable", "true");
		
		//Setup mail server
		props.put("mail.smtp.host", "smtp.gmail.com");	
		
		//TLS Port
		props.put("mail.smtp.port", "587");			
		//Crea una Session instance riferita all'
		//oggetto Authenticator da passare come
		//argomento di Session.getInstance
		Session session = Session.getInstance(props,
		new javax.mail.Authenticator() {
			
			//override the getPasswordAuthentication method
			protected PasswordAuthentication
						getPasswordAuthentication() {
										
				return new PasswordAuthentication(username,
												password);
			}
		});

		try {
			
			// Componi il messaggio.
			Message message = new MimeMessage(session);
			
			// Campo di intestazione dell'header
			message.setFrom(new InternetAddress(sender));
			
			message.setRecipients(Message.RecipientType.TO,
				InternetAddress.parse(emailDest));
			message.setSubject(oggetto);
			message.setText(messaggio);

			Transport.send(message);		 //Manda il messaggio

			//System.out.println("Email inviata");

		} catch (MessagingException e) {
			throw new RuntimeException(e);
		}
	}
}

