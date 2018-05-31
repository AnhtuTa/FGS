package hello.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;

@Controller
public class GoogleAPIController {
    @Autowired
    private Environment env;

    @RequestMapping(value = { "/autocomplete/json" }, method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String autocomplete(Model model, HttpServletRequest request) {
        try {
            URL url = new URL("https://maps.googleapis.com/maps/api/place" + request.getSession().getAttribute("currentURI") + "&types=geocode&language=vi&components=country:vn&key=AIzaSyAKzKoLguTtClfCpuh4jjFLmvig9jtPqoY");
            System.out.println("url = " + url);
            String input = request.getParameter("input");
            //System.out.println("params: " + request.getParameter("input"));

            InputStream inputStream = url.openConnection().getInputStream();
            StringBuilder builder = new StringBuilder();
            BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));

            String line;
            while((line = reader.readLine()) != null){
                builder.append(line + "\n");
            }

            String temp = builder.substring(0, builder.length()-2);     //bỏ dấu }
            builder = new StringBuilder(temp);

            String webserviceHost = env.getProperty("graphql.host");
            //url = new URL(webserviceHost + "/graphql?query=query%20%7B%0A%09hotelsByName(name%3A%20\"" + input.replace(" ", "%20") + "\")%20%0A%7D");
            //url = new URL(webserviceHost + "/graphql?query=%0Aquery%20%7B%0A%20%20hotels(name%3A%20\"" + input.replace(" ", "%20") + "\")%20%7B%0A%20%20%20%20name%0A%20%20%7D%0A%7D%0A");
            url = new URL(webserviceHost + "/graphql?query=query%20%7B%0A%09hotels(start%3A0%2C%20nums%3A%20100%2C%20search_by%3A%20%22name%22%2C%20input%3A%20%22" + input.replace(" ", "%20") + "%22)%20%7B%0A%20%20%20%20name%0A%20%20%7D%0A%7D");
            
            builder.append(",")
                    .append("\"hotels\": ");

            inputStream = url.openConnection().getInputStream();
            reader = new BufferedReader(new InputStreamReader(inputStream));

            while((line = reader.readLine()) != null){
                builder.append(line + "\n");
            }
            builder.append("}");
            return builder.toString();
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return "";
    }
}
