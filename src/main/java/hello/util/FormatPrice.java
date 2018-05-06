package hello.util;

import java.text.NumberFormat;
import java.util.Locale;

public class FormatPrice {
	/*
	 * Thường thì giá thuê sẽ dưới tiền tỷ, do đó input để kiểu int
	 */
	public String formatPrice(int price) {
		NumberFormat formatter = NumberFormat.getInstance(new Locale("vi", "VN"));
		return formatter.format(price);
	}
	
//	public static void main(String[] args) {
//		FormatPrice fd = new FormatPrice();
//		System.out.println(fd.formatPrice(123456789));
//		System.out.println(fd.formatPrice(987000));
//		System.out.println(fd.formatPrice(1982000));
//		System.out.println(fd.formatPrice(3251));
//		System.out.println(fd.formatPrice(5000));
//		System.out.println(fd.formatPrice(1234567890));
//	}
}
