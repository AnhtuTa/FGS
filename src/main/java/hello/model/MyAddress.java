package hello.model;

public class MyAddress {
	private String latitude;
	private String longitute;
	private String street;	//số nhà + tên đường
	private String district;	//tên quận/huyện
	private String city;	//tên thành phố/tỉnh
	
	public MyAddress(String latitude, String longitute) {
		super();
		this.latitude = latitude;
		this.longitute = longitute;
	}
	
	public MyAddress(String latitude, String longitute, String street, String district, String city) {
		super();
		this.latitude = latitude;
		this.longitute = longitute;
		this.street = street;
		this.district = district;
		this.city = city;
	}

	public String getLongitute() {
		return longitute;
	}
	public String getLatitude() {
		return latitude;
	}

	public String getStreet() {
		return street;
	}

	public void setStreet(String street) {
		this.street = street;
	}

	public String getDistrict() {
		return district;
	}

	public void setDistrict(String district) {
		this.district = district;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}

	public void setLongitute(String longitute) {
		this.longitute = longitute;
	}
	
	@Override
	public String toString() {
		return this.street + ", " + this.district + ", " + this.city + " [" + this.latitude + ", " + this.longitute + "]";
	}
}
