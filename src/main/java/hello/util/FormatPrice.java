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

    /**
     *
     * @param priceString kiểu String, là price có các dấu . ngăn cách giữa 3 số
     * @return 1 price kiểu int
     */
	public int getPrice(String priceString) {
	    return Integer.parseInt(priceString.replace(".", ""));
    }
	
//	public static void main(String[] args) {
//		FormatPrice fd = new FormatPrice();
//		System.out.println(fd.formatPrice(123456789));
//		System.out.println(fd.formatPrice(987000));
//		System.out.println(fd.formatPrice(1982000));
//		System.out.println(fd.formatPrice(3251));
//		System.out.println(fd.formatPrice(5000));
//		System.out.println(fd.formatPrice(1234567890));
//
//		String price = "1.982.000";
//        System.out.println(fd.getPrice(price));
//	}
}
