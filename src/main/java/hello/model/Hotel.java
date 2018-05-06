package hello.model;

import java.io.Serializable;

public class Hotel implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -2657453330660920424L;
	
	long id;
	String name;
	int star;
	String hotelUrl; // địa chỉ trang web
	String imageUrl; // địa chỉ ảnh của hotel

	String street;	//số nhà + tên phố/đường
	String district; // quận
	String city;
	String latitude; // vĩ độ
	String longitude; // kinh độ

	float reviewPoint; // điểm đánh giá
	int numReviews; // số lượng người đã đánh giá
	float area; // diện tích (Chắc ko cần)
	String priceString; // giá đã đc format, đơn vị: VNĐ (VD: 1.982.000)

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getStar() {
		return star;
	}

	public void setStar(int star) {
		this.star = star;
	}

	public String getHotelUrl() {
		return hotelUrl;
	}

	public void setHotelUrl(String hotelUrl) {
		this.hotelUrl = hotelUrl;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
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

	public String getLatitude() {
		return latitude;
	}

	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}

	public String getLongitude() {
		return longitude;
	}

	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}

	public float getReviewPoint() {
		return reviewPoint;
	}

	public void setReviewPoint(float reviewPoint) {
		this.reviewPoint = reviewPoint;
	}

	public int getNumReviews() {
		return numReviews;
	}

	public void setNumReviews(int numReviews) {
		this.numReviews = numReviews;
	}

	public float getArea() {
		return area;
	}

	public void setArea(float area) {
		this.area = area;
	}

	public String getPriceString() {
		return priceString;
	}

	public void setPriceString(String priceString) {
		this.priceString = priceString;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	@Override
	public String toString() {
		return name;
	}
}
