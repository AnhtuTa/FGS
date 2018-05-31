package hello.model;

import java.io.Serializable;

/**
 * Khách sạn thì gồm các loại hình cư trú sau:
 * Khách sạn: hotel
 * Biệt thự: villa
 * Nhà nghỉ B&B: B&B
 * Căn hộ: apartment
 * Resort: Resort
 * Du thuyền: Houseboat & Cruise
 * Homestay: Homestay
 * Nhà nghỉ: Hostel
 */
public class Hotel extends House implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -2657453330660920424L;
	
	long hotelId;
	int star;
	String hotelUrl; // địa chỉ trang web
	float reviewPoint; // điểm đánh giá
	int numReviews; // số lượng người đã đánh giá
	String rawAddress;	//address lấy từ trivago, nếu hotel này chưa có trong database thì dùng google API chuyển address này sang lat, lng, street, district, city.

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
	
	public long getHotelId() {
		return hotelId;
	}

	public void setHotelId(long hotelId) {
		this.hotelId = hotelId;
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

	public String getRawAddress() {
		return rawAddress;
	}

	public void setRawAddress(String rawAddress) {
		this.rawAddress = rawAddress;
	}

	public String getDetails() {
		StringBuilder builder = new StringBuilder("ID: " + getId());
		builder.append("\nHotelID: ").append(hotelId)
				.append("\nName: ").append(getName())
				.append("\naddress: ").append(getStreet()).append(", ").append(getDistrict()).append(", ").append(getCity())
				.append("[").append(getLatitude()).append(", ").append(getLongitude()).append("]")
				.append("\nreview point: ").append(reviewPoint)
				.append("\nnumber of reviews: ").append(numReviews)
				.append("\nprice: ").append(getPrice());
			
		return builder.toString();
	}
	
	@Override
	public String toString() {
		return getName();
	}
}
