package hello.model;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/*
 * Do mỗi bài đăng tương ứng với 1 nhà trọ nên ta có thể coi
 * class Post chính là class Nhatro
 */
public class Post extends House {
	/**
	 * 
	 */
	private static final long serialVersionUID = -7470725006843652174L;
	
	private int userId;
	private int area;	//Diện tích, đơn vị: m2
	Date time;
	private String contactName;
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
	public String getContactName() {
		return contactName;
	}
	public void setContactName(String contactName) {
		this.contactName = contactName;
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

	public Date getTime() {
		return time;
	}

	public void setTime(Date time) {
		this.time = time;
	}

	public String getFormattedTimeUS() {
		return new SimpleDateFormat("yyyy-M-d 'at' hh:mm a", Locale.ENGLISH).format(time);
	}
	public String getFormattedTimeVN() {
		return new SimpleDateFormat("d/M/yyyy 'lúc' HH'h'mm").format(time);
	}

//	public static void main(String[] args) {
//		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd 'at' hh:mm a", Locale.ENGLISH);
//		String formatted = dateFormat.format(new Date());
//
//		System.out.println(formatted);
//	}
}
