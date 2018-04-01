package hello.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/*
 * Mã hóa pass = BCryptPasswordEncoder. KHÔNG ĐƯỢC SỬA ĐỔI cách mã hóa!
 */
public class EncryptPassword {
	public static String encriptPassword(String pass) {
		return new BCryptPasswordEncoder().encode(pass);
	}
}
