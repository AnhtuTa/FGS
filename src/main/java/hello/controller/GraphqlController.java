package hello.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class GraphqlController {
	@Autowired
	private Environment env;

	@RequestMapping(value = { "/graphql" }, method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String graphql(Model model, HttpServletRequest request) {
		//Cách sau bị lỗi!
//		String query = request.getParameter("query");
//		query = HtmlUtils.htmlEscape(query);
//		System.out.println("query = " + query);
		
		try {
			String webserviceHost = env.getProperty("graphql.host");
			URL url = new URL(webserviceHost + request.getSession().getAttribute("currentURI"));
			//URL url = new URL("http://localhost:3000/graphql/hotel?query=%0Aquery%20%7B%0A%20%20hotel(id%3A%2012)%20%7B%0A%20%20%20%20image_urls%0A%20%20%7D%0A%7D%0A");

			InputStream inputStream = url.openConnection().getInputStream();
	        StringBuilder builder = new StringBuilder();
	        BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));

	        String line;
	        while((line = reader.readLine()) != null){
	            builder.append(line + "\n");
	        }
	        
	        return builder.toString();
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return "";
	}

}
