package hello.util;

public class StringUtils {
    public static String addSlashToDoubleQuote(String input) {
        return input.replace("\"", "\\\"");
    }

//    public static void main(String[] args) {
//        System.out.println(StringUtils.addSlashToDoubleQuote("fkweoaf feowkf fgja\"flew \"lfpewa \"lfpewal\"ewl"));
//    }
}
