package hello.validator;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

/*
 * mật khẩu phải có độ dài trong khoảng 4-20 ký tự, và phải chứa ít nhất 1 tự đặc biệt
 */
public class MyPasswordValidator implements ConstraintValidator<MyPassword, String> {

	@Override
	public void initialize(MyPassword arg0) {
		//do nothing
	}

	@Override
	public boolean isValid(String pass, ConstraintValidatorContext arg1) {
		if(pass.length() < 4 || pass.length() > 20) return false;
		
		String specialChar [] = {"@", "!", "$", "%", "^", "&", "*", "<", ">"};
		int numOfSpecialChar = 0;
		for(String c : specialChar) {
			if(pass.contains(c)) {
				numOfSpecialChar++;
				break;
			}
		}
		if(numOfSpecialChar == 0) return false;
		
		return true;
	}

}
