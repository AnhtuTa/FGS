package hello.crawler;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;

import com.google.gson.Gson;

import hello.dao.HotelDAO;
import hello.model.Hotel;

public class CrawlTrivago {
	private List<Hotel> hotelList;
	HotelDAO hotelDAO;
	
	public CrawlTrivago() {
		hotelList = new ArrayList<Hotel>();
		hotelDAO = new HotelDAO();
	}
	
	public void crawl(String city) {
		File file = new File(System.getProperty("user.dir") + "/chromedriver.exe");
		System.out.println(System.getProperty("user.dir"));
		System.setProperty("webdriver.chrome.driver", file.getAbsolutePath());
		WebDriver driver = new ChromeDriver();
		driver.get("https://www.trivago.vn");
		
		WebElement element = driver.findElement(By.name("sQuery"));
		element.sendKeys(city);
		element.submit();
		sleep(2000);
		driver.findElement(By.className("horus-btn-search__label")).click();
		sleep(500);

		// rows là tập các thẻ li chứa nội dung của hotel
		List<WebElement> rows = driver.findElements(By.xpath("//li[@class='hotel item-order__list-item js_co_item']"));

		if (rows.size() == 0) {
			System.out.println("Error! Can not find any row.");
			return;
		} else {
			for (int i = 0; i < rows.size(); i++) {
				List<WebElement> elementList = rows.get(i)
						.findElements(By.xpath(".//h3[@class='name__copytext m-0 item__slideout-toggle']"));

				// mỗi row chỉ có 1 thẻ chứa tên hotel
				if (elementList.size() == 1) {
					// click tới khi slideout hiện ra thì dừng
					while (true) {
						elementList.get(0).click(); // click vào tên của hotel
						sleep(300); // chờ load trang
						List<WebElement> item__slideout = rows.get(i) // item__slideout là con của thẻ
																		// div[item__slideout]
								.findElements(By.xpath(".//div[@class='slo-wrp slo-wrp--active clearfix']"));
						if (item__slideout.size() == 1)
							break;
					}
				}
				// hotel.add(getListImage(rows.get(i));
				Hotel t = new Hotel();
				t.setImageUrls(getListImage(rows.get(i)));
				hotelList.add(t);
			}

			///////////////// click để lấy thông tin trong tab thông tin
			///////////////// ////////////////////
			List<WebElement> e = driver.findElements(By.xpath(".//span[@class='item__distance']"));
			if (e.size() != 0) {
				for (int i = 0; i < e.size(); i++) {
					// click 3 lần để tránh trường hợp lỗi (ko load đc)
					e.get(i).click();
					sleep(300);
					e.get(i).click();
					sleep(300);
					e.get(i).click();
				}
			}
			/////////// Lấy các thông tin còn lại ở tab thông tin của từng row
			for (int i = 0; i < rows.size(); i++) {
				hotelList.get(i).setRawAddress(getAddress(rows.get(i)));
				hotelList.get(i).setAvatar(getAvatar(rows.get(i)));
				hotelList.get(i).setHotelId(getHotelId(rows.get(i)));
				hotelList.get(i).setPrice(getCost(rows.get(i)));
				hotelList.get(i).setName(getName(rows.get(i)));
				hotelList.get(i).setReviewPoint(getRating(rows.get(i)));
				hotelList.get(i).setNumReviews(getReviewCount(rows.get(i)));
				hotelList.get(i).setStar(getStar(rows.get(i)));
			}
		}
//		try {
//			//in kq crawl được vào file
//			printOut(toJSON(hotelList));
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
		
		//hoặc là lưu vào database
		hotelDAO.upsertHotel(hotelList);
		
		driver.close();
		driver.quit();
	}

	@SuppressWarnings("unused")
	private String toJSON(List<Hotel> ls) {
		return new Gson().toJson(ls);
	}
	
	/*
	 * element chính là thẻ li chứa nội dung của từng hotel tức là thẻ:
	 * li[@class='hotel item-order__list-item js_co_item']
	 */
	private Long getHotelId(WebElement element) {
		return Long.valueOf(element.getAttribute("data-item"));
	}

	private String getAvatar(WebElement element) {
		List<WebElement> elementList = element
				.findElements(By.xpath(".//img[@class='item__image item__image--has-gallery']"));
		if(elementList.size() != 1) return null;
		return elementList.get(0).getAttribute("src");
	}

	private String getName(WebElement element) {
		List<WebElement> lse = element
				.findElements(By.xpath(".//h3[@class='name__copytext m-0 item__slideout-toggle']"));
		if (lse.size() != 1) {
			System.out.println("Khong tim duoc the name");
			return "";
		}
		// System.out.println(numofstar + "");
		return lse.get(0).getText();
	}

	private Integer getCost(WebElement element) {
		List<WebElement> lse = element.findElements(By.className("item__best-price"));
		if (lse.size() != 1) {
			System.out.println("Khong tim duoc the gia");
			return 0;
		}
		String t = lse.get(0).getText();
		String res = "";
		for (int i = 0; i < t.length(); i++) {
			if (t.charAt(i) >= '0' && t.charAt(i) <= '9')
				res += t.charAt(i);
		}
		// System.out.println(toUTF8(lse.get(0).getText()));
		return Integer.parseInt(res);
	}

	private int getReviewCount(WebElement element) {
		List<WebElement> lse = element.findElements(By.className("review__count"));
		if (lse.size() != 1) {
			System.out.println("Khong tim duoc the rating");
			return 0;
		}
		String t = lse.get(0).getText();
		String res = "";
		for (int i = 1; i < t.length(); i++) {
			if (t.charAt(i) < '0' || t.charAt(i) > '9')
				break;
			res += t.charAt(i);
		}
		// System.out.println(toUTF8(lse.get(0).getText()));
		return Integer.parseInt(res);
	}

	private int getStar(WebElement element) {
		List<WebElement> lse = element.findElements(By.xpath(".//div[@class='item__stars-badges']"));
		if (lse.size() != 1) {
			System.out.println("Khong tim duoc the star");
			return 0;
		}
		int numofstar = lse.get(0).findElements(By.xpath(".//div[@class='item__stars-wrp']/span")).size();
		// System.out.println(numofstar + "");
		return numofstar;
	}

	private float getRating(WebElement element) {
		List<WebElement> lse = element.findElements(By.className("rating-box__value"));
		if (lse.size() != 1) {
			System.out.println("Khong tim duoc the rating");
			return -1;
		}
		// System.out.println(lse.get(0).getText());
		return Float.parseFloat(lse.get(0).getText());
	}

	private String getAddress(WebElement element) {
		String address = "";
		String street = "", city = "";
		// thẻ có itemtype = ...postalAddressList là thẻ chứa địa chỉ của hotel. Trong
		// thẻ này có 4 thẻ span
		List<WebElement> postalAddressList = element
				.findElements(By.xpath(".//em[@itemtype='http://schema.org/PostalAddress']"));
		// System.out.println(e.size() + "");
		if (postalAddressList.size() == 1) {
			List<WebElement> smaller = postalAddressList.get(0)
					.findElements(By.xpath(".//span[@itemprop='streetAddress']"));
			if (smaller.size() == 1)
				street += smaller.get(0).getText() + " ";
			smaller = postalAddressList.get(0).findElements(By.xpath(".//span[@itemprop='addressLocality']"));
			if (smaller.size() == 1)
				city += smaller.get(0).getText() + " ";
			smaller = postalAddressList.get(0).findElements(By.xpath(".//span[@itemprop='addressCountry']"));
			if (smaller.size() == 1)
				city += smaller.get(0).getText();
//			address += toUTF8(street);
//			address += toUTF8(city);
			address += street;
			address += city;
		}
		return address;
	}

	private List<String> getListImage(WebElement element) {
		List<String> res = new ArrayList<String>();
		while (true) {
			List<WebElement> le1 = element.findElements(By.xpath(".//img[@class='gal-mob__img']"));
			List<WebElement> le2 = element.findElements(By.xpath(".//img[@class='gal-collage__img']"));
			if (le1.size() == 1) {
				res.add(le1.get(0).getAttribute("src"));
				// System.out.println(le1.get(0).getAttribute("src"));
			} else if (le2.size() == 1) {
				res.add(le2.get(0).getAttribute("src"));
				// System.out.println(le2.get(0).getAttribute("src"));
			}
			List<WebElement> btn = element
					.findElements(By.xpath(".//button[@class='gal-mob__arrow gal-mob__arrow--trailing']"));
			if (btn.size() == 0 || (btn.size() == 1 && btn.get(0).isDisplayed() == false)) {
				break;
			}
			btn.get(0).click();
		}
		return res;
	}

	private void sleep(int microsecond) {
		try {
			Thread.sleep(microsecond);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

//	private String toUTF8(String content) {
//		String value = "";
//		byte ptext[] = content.getBytes(Charsets.UTF_8);
//		value = new String(ptext, Charsets.UTF_8);
//		return value;
//	}

//	private void printOut(String content) throws IOException {
//		Writer out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("filename.txt"), "UTF-8"));
//		try {
//			out.write(content);
//		} finally {
//			out.close();
//		}
//	}

	public static void main(String[] args) {
		CrawlTrivago crawlTrivago = new CrawlTrivago();
		crawlTrivago.crawl("nha trang");
	}
}
