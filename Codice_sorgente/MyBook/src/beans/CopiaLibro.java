package beans;

public class CopiaLibro {
	private int idCopiaLibro;
	private int idMagazzino;
	private int libroISBN;
	private String stato;
	
	public int getIdCopiaLibro() {
		return idCopiaLibro;
	}
	public void setIdCopiaLibro(int idCopiaLibro) {
		this.idCopiaLibro = idCopiaLibro;
	}
	public int getIdMagazzino() {
		return idMagazzino;
	}
	public void setIdMagazzino(int idMagazzino) {
		this.idMagazzino = idMagazzino;
	}
	public int getLibroISBN() {
		return libroISBN;
	}
	public void setLibroISBN(int libroISBN) {
		this.libroISBN = libroISBN;
	}
	public String getStato() {
		return stato;
	}
	public void setStato(String stato) {
		this.stato = stato;
	}
	
}
