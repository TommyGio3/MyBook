package beans;

import java.util.Date;

public class AnagraficaCliente {
	private String nome;
	private String cognome;
	private String codiceFiscale;
	private String indirizzo;
	private Date dataDiNascita;
	private String clienteUsername;
	
	public String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
	public String getCognome() {
		return cognome;
	}
	public void setCognome(String cognome) {
		this.cognome = cognome;
	}
	public String getCodiceFiscale() {
		return codiceFiscale;
	}
	public void setCodiceFiscale(String codiceFiscale) {
		this.codiceFiscale = codiceFiscale;
	}
	public String getIndirizzo() {
		return indirizzo;
	}
	public void setIndirizzo(String indirizzo) {
		this.indirizzo = indirizzo;
	}
	public Date getDataDiNascita() {
		return dataDiNascita;
	}
	public void setDataDiNascita(Date dataDiNascita) {
		this.dataDiNascita = dataDiNascita;
	}

	public String getClienteUsername() {
		return clienteUsername;
	}
	public void setClienteUsername(String clienteUsername) {
		this.clienteUsername = clienteUsername;
	}
	
	
	
}
