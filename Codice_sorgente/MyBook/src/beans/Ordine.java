package beans;
import java.util.Date;

public class Ordine {
	private int idOrdine;
	private String cliente_username;
	private int idTessera;
	private Date dataOrdine;
	private int copiaLibro;
	
	public int getIdOrdine() {
		return idOrdine;
	}
	public void setIdOrdine(int idOrdine) {
		this.idOrdine = idOrdine;
	}
	public String getCliente_username() {
		return cliente_username;
	}
	public void setCliente_username(String cliente_username) {
		this.cliente_username = cliente_username;
	}
	public int getIdTessera() {
		return idTessera;
	}
	public void setIdTessera(int idTessera) {
		this.idTessera = idTessera;
	}
	public Date getDataOrdine() {
		return dataOrdine;
	}
	public void setDataOrdine(Date dataOrdine) {
		this.dataOrdine = dataOrdine;
	}
	public int getCopiaLibro() {
		return copiaLibro;
	}
	public void setCopiaLibro(int copiaLibro) {
		this.copiaLibro = copiaLibro;
	}
	
	
}
