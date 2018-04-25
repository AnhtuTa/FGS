package hello.model;

public class Hotel {
	long id;
	String name;
	int star;
	String url;			//địa chỉ trang web
	
	String district;	//quận
	String city;
	float latitude;		//vĩ độ
	float longitude;	//kinh độ
	
	float reviewPoint;	//điểm đánh giá
	int numReviews;		//số lượng người đã đánh giá
	float area;			//diện tích
	float price;		//giá
	
	
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
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
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
	public float getLatitude() {
		return latitude;
	}
	public void setLatitude(float latitude) {
		this.latitude = latitude;
	}
	public float getLongitude() {
		return longitude;
	}
	public void setLongitude(float longitude) {
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
	public float getPrice() {
		return price;
	}
	public void setPrice(float price) {
		this.price = price;
	}
	
	
	@Override
	public String toString() {
		return name;
	}
}
