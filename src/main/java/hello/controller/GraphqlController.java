package hello.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;

import hello.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import hello.util.PostUtils;

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

	@RequestMapping(value = { "/graphql" }, method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String graphqlPost(Model model, HttpServletRequest request) {
		try {
			String webserviceHost = env.getProperty("graphql.host");
			String query = request.getParameter("query");
			/*
			query là dữ liệu chưa mã hóa, VD:
			query = mutation {
			  insertReview(input: {
				user_id: 3
				hotel_id: 51
				review_point: 7
				comment: "Khách sạn này \"quá rẻ!\""
			  }) {
				status
				error
			  }
			}
			 */

			query = URLEncoder.encode(query, "UTF-8");
			URL url = new URL(webserviceHost + "/graphql");

			return PostUtils.sendPost(url, "query=" + query);
		} catch (MalformedURLException e) {
			e.printStackTrace();
			return "{\"error\": \"" + e.getMessage() + "\"}";
		} catch (IOException e) {
			e.printStackTrace();
			return "{\"error\": \"" + e.getMessage() + "\"}";
		} catch (Exception e) {
			e.printStackTrace();
			return "{\"error\": \"" + e.getMessage() + "\"}";
		}
	}

	@RequestMapping(value = { "/graphql/insert-review" }, method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String insertReview(Model model, HttpServletRequest request) {
		try {
			String webserviceHost = env.getProperty("graphql.host");
			int hotel_id = Integer.valueOf(request.getParameter("hotel_id"));
			int user_id = Integer.valueOf(request.getParameter("user_id"));
			int review_point = Integer.valueOf(request.getParameter("review_point"));
			String comment = request.getParameter("comment");		//comment đã add slash vào double quote ở bên AJAX rồi
			System.out.println("comment = " + comment);

			if(request.getSession().getAttribute("userId") == null || user_id != Integer.valueOf(request.getSession().getAttribute("userId").toString())) {
				//ko có quyền insert review cho người khác
				return getReturnMessage("fail", "you do not have permission to insert review for another person");
			}

			String query =
				"mutation {\n" +
					"insertReview(input: {\n" +
						"user_id: " + user_id + "\n" +
						"hotel_id: " + hotel_id +"\n" +
						"review_point: " + review_point + "\n" +
						"comment: \"" + comment + "\"" +
					"}) {\n" +
						"status\n" +
						"error\n" +
					"}\n" +
				"}";
			System.out.println("[insertReview()] query = " + query);

			query = URLEncoder.encode(query, "UTF-8");	//ko cần thay các ký tự khoảng trống = '%20'
			URL url = new URL(webserviceHost + "/graphql");

			return PostUtils.sendPost(url, "query=" + query);
		} catch (MalformedURLException e) {
			e.printStackTrace();
			return "{\"error\": \"" + StringUtils.addSlashToDoubleQuote(e.getMessage()) + "\"}";
		} catch (IOException e) {
			e.printStackTrace();
			return "{\"error\": \"" + StringUtils.addSlashToDoubleQuote(e.getMessage()) + "\"}";
		} catch (Exception e) {
			e.printStackTrace();
			return "{\"error\": \"" + StringUtils.addSlashToDoubleQuote(e.getMessage()) + "\"}";
		}
	}

	@RequestMapping(value = { "/graphql/update-review" }, method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateReview(Model model, HttpServletRequest request) {
		try {
			String webserviceHost = env.getProperty("graphql.host");
			int hotel_id = Integer.valueOf(request.getParameter("hotel_id"));
			int user_id = Integer.valueOf(request.getParameter("user_id"));
			int review_point = Integer.valueOf(request.getParameter("review_point"));
			String comment = request.getParameter("comment");		//comment đã add slash vào double quote ở bên AJAX rồi

			if(request.getSession().getAttribute("userId") == null || user_id != Integer.valueOf(request.getSession().getAttribute("userId").toString())) {
				//ko có quyền insert review cho người khác
				return getReturnMessage("fail", "you do not have permission to update review for another person");
			}

			String query =
				"mutation {\n" +
					"updateReview(hotel_id: " + hotel_id + ", user_id: " + user_id + ", review_point: " + review_point + ", comment: \"" + comment + "\") {\n" +
						"status\n" +
						"error\n" +
					"}\n" +
				"}";
			System.out.println("[updateReview()] query = " + query);

			query = URLEncoder.encode(query, "UTF-8");	//ko cần thay các ký tự khoảng trống = '%20'
			URL url = new URL(webserviceHost + "/graphql");

			return PostUtils.sendPost(url, "query=" + query);
		} catch (MalformedURLException e) {
			e.printStackTrace();
			return "{\"error\": \"" + StringUtils.addSlashToDoubleQuote(e.getMessage()) + "\"}";
		} catch (IOException e) {
			e.printStackTrace();
			return "{\"error\": \"" + StringUtils.addSlashToDoubleQuote(e.getMessage()) + "\"}";
		} catch (Exception e) {
			e.printStackTrace();
			return "{\"error\": \"" + StringUtils.addSlashToDoubleQuote(e.getMessage()) + "\"}";
		}
	}

	@RequestMapping(value = { "/graphql/delete-review" }, method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String deleteReview(Model model, HttpServletRequest request) {
		try {
			String webserviceHost = env.getProperty("graphql.host");
			int hotel_id = Integer.valueOf(request.getParameter("hotel_id"));
			int user_id = Integer.valueOf(request.getParameter("user_id"));

			if(request.getSession().getAttribute("userId") == null || user_id != Integer.valueOf(request.getSession().getAttribute("userId").toString())) {
				//ko có quyền delete review cho người khác
				return getReturnMessage("fail", "you do not have permission to delete review for another person");
			}

			String query =
				"mutation {\n" +
					"deleteReview(hotel_id: " + hotel_id + ", user_id: " + user_id + ") {\n" +
						"status\n" +
						"error\n" +
					"}\n" +
				"}";
			System.out.println("[deleteReview()] query = " + query);

			query = URLEncoder.encode(query, "UTF-8");	//ko cần thay các ký tự khoảng trống = '%20'
			URL url = new URL(webserviceHost + "/graphql");

			return PostUtils.sendPost(url, "query=" + query);
		} catch (MalformedURLException e) {
			e.printStackTrace();
			return "{\"error\": \"" + StringUtils.addSlashToDoubleQuote(e.getMessage()) + "\"}";
		} catch (IOException e) {
			e.printStackTrace();
			return "{\"error\": \"" + StringUtils.addSlashToDoubleQuote(e.getMessage()) + "\"}";
		} catch (Exception e) {
			e.printStackTrace();
			return "{\"error\": \"" + StringUtils.addSlashToDoubleQuote(e.getMessage()) + "\"}";
		}
	}

	private String getReturnMessage(String status, String error) {
		if(error == null) {
			status = status.replace("\"", "\\\"");
			return "{\"status\": \"" + status + "\"" + ", \"error\": null}";
		}
		else if (status == null) {
			error = error.replace("\"", "\\\"");
			return "{\"status\": null" + ", \"error\": \"" + error + "\"}";
		}
		else {
			status = status.replace("\"", "\\\"");
			error = error.replace("\"", "\\\"");
			return "{\"status\": \"" + status + "\", \"error\": \"" + error + "\"}";
		}
	}

//	public static void main(String[] args) {
//		System.out.println(new GraphqlController().getReturnMessage("success", null));
//		System.out.println(new GraphqlController().getReturnMessage("fail", "This is \"error\""));
//		System.out.println(new GraphqlController().getReturnMessage(null, "this \"is\" 'error';"));
//
//	}
}
