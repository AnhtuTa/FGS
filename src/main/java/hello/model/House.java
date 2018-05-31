package hello.model;

import java.io.Serializable;
import java.util.List;

public class House implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 5205119854975387821L;

	private long id;
	
	//với hotel: field này là tên của hotel
	//với nhà trọ: field này là tên của bài đăng
	private String name;

	//với hotel: field này mô tả tiện nghi của hotel
	//với nhà trọ: field này mô tả nội dung bài đăng cho thuê nhà trọ
	private String description;

	private String avatar;		//địa chỉ ảnh đại diện
	private List<String> imageUrls; // địa chỉ ảnh của

	private String street;	//số nhà + tên phố/đường
	private String district; // quận/huyện
	private String city;	//thành phố/tỉnh
	private String latitude; // vĩ độ
	private String longitude; // kinh độ
	private int price; // giá
	private String type;	//1 trong 2 giá trị: hotel, nhatro

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

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getAvatar() {
		return avatar;
	}

	public void setAvatar(String avatar) {
		this.avatar = avatar;
	}

	public List<String> getImageUrls() {
		return imageUrls;
	}

	public void setImageUrls(List<String> imageUrls) {
		this.imageUrls = imageUrls;
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

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}
	
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getImageUrlsString() {
		if(imageUrls == null) return null;
		StringBuilder builder = new StringBuilder();
		for(String url : imageUrls) {
			builder.append(url).append("|");
		}
		return builder.toString();
	}
}
