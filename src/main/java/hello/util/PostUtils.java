package hello.util;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;

public class PostUtils {
    private static final String USER_AGENT = "Mozilla/5.0";

    public static String sendPost(URL url, String urlParameters) throws Exception {
        byte[] postData = urlParameters.getBytes(StandardCharsets.UTF_8);
        int postDataLength = postData.length;

        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setDoOutput(true);
        conn.setInstanceFollowRedirects(false);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("User-Agent", USER_AGENT);
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        conn.setRequestProperty("charset", "utf-8");
        conn.setRequestProperty("Content-Length", Integer.toString(postDataLength));
        conn.setUseCaches(false);

        Writer out = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
        out.write(urlParameters);
        out.flush();
        out.close();

        //int responseCode = conn.getResponseCode();
        //System.out.println("\n[PostUtils] Sending 'POST' request to URL : " + url);
        //System.out.println("[PostUtils] Response Code : " + responseCode);

        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), Charset.forName("UTF-8")));
        String inputLine;
        StringBuffer response = new StringBuffer();

        while ((inputLine = in.readLine()) != null) {
            response.append(inputLine);
        }
        in.close();

        //print result
        return response.toString();
    }

    public static String escapeHtmlSQL(String input) {
        return input.replace(" ", "%20");
    }
}
