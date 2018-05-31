package hello.model;

public class NhaTro extends House {
	/**
	 * 
	 */
	private static final long serialVersionUID = -7470725006843652174L;
	
	private int userId;
	private int area;	//Diện tích, đơn vị: m2
	private String contactPhone;
	private String contactEmail;
	private String contactAddress;
	
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public int getArea() {
		return area;
	}
	public void setArea(int area) {
		this.area = area;
	}
	public String getContactPhone() {
		return contactPhone;
	}
	public void setContactPhone(String contactPhone) {
		this.contactPhone = contactPhone;
	}
	public String getContactEmail() {
		return contactEmail;
	}
	public void setContactEmail(String contactEmail) {
		this.contactEmail = contactEmail;
	}
	public String getContactAddress() {
		return contactAddress;
	}
	public void setContactAddress(String contactAddress) {
		this.contactAddress = contactAddress;
	}
	
	
}
