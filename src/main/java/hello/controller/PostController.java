package hello.controller;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import hello.util.PostUtils;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import hello.dao.DistrictDAO;
import hello.dao.ProvinceDAO;
import hello.model.District;
import hello.model.Province;

@Controller
public class PostController {
    @Autowired
    ProvinceDAO provinceDAO;

    @Autowired
    DistrictDAO districtDAO;

    @Autowired
    private Environment env;

    @RequestMapping(value = {"/{locale:en|vi}/post", "/post"}, method = RequestMethod.GET)
    public String post(Model model) {
        List<Province> provinceList = provinceDAO.getAllProvinces();
        List<District> districtList = districtDAO.getDistricts(1);
        model.addAttribute("provinceList", provinceList);
        model.addAttribute("districtList", districtList);
        model.addAttribute("requireSelectDistrict", 1);

        return "post";
    }

    /*
    Demo query:
        mutation {
            insertPost(input: {
                user_id: 4,
                        name: "Title of post",
                        description: "This is content",
                        avatar: null,
                        image_urls: "farearew",
                        street: "street",
                        district: "fearewr",
                        city: "fewraw",
                        area: 32,
                        price: 2121000,
                        contact_name: "att",
                        contact_phone: "094304034",
                        contact_email: "feawrw@feawf",
                        contact_address: "2feakf3fas"
            }) {
                status
                        error
            }
        }
     */
    @RequestMapping(value = {"/{locale:en|vi}/post", "/post"}, method = RequestMethod.POST)
    public String doPost(HttpServletRequest request) {
//        Enumeration<String> params = request.getParameterNames();
//        while(params.hasMoreElements()) {
//            String key = params.nextElement();
//            System.out.println(key + " = " + request.getParameter(key));
//        }

        int cityId = Integer.valueOf(request.getParameter("city"));
        int districtId = Integer.valueOf(request.getParameter("district"));
        String city = provinceDAO.getProvinceName(cityId);
        String district = districtDAO.getDistrictName(districtId);
        String street = request.getParameter("street");
        String price = request.getParameter("price");
        String area = request.getParameter("area");
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        content = content.replaceAll("(\r\n|\n)", "<br>");      //thay thế ký tự xuống dòng = thẻ <br> để lúc hiển thị cho dễ
        System.out.println(content);
        StringBuilder builder = new StringBuilder();
        String imageUrls = "null";
        String avatar = "null";

    	if(request.getParameter("image_url") != null) {
            String []arr = request.getParameterValues("image_url");
            for(int i = 0; i < arr.length - 1; i++) {
                builder.append(arr[i]).append("|");
            }
            builder.append(arr[arr.length - 1]);
            imageUrls = "\"" + builder.toString() + "\"";
            avatar = "\"" + arr[0] + "\"";    //avatar sẽ là ảnh đầu tiên người dùng đăng lên
        }

        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        long userId = Long.valueOf(request.getSession().getAttribute("userId").toString());

        String query = "mutation {" +
                "  insertPost(input: {" +
                "    user_id: " + userId + "," +
                "    name: \"" + title + "\"," +
                "    description: \"" + content + "\"," +
                "    avatar: " + avatar + "," +             //Chú ý: avatar và image_urls ko có cặp dấu "", vì đề phòng trường hợp ko có ảnh, lúc này avatar = null, chứ ko phải: avatar = "null"
                "    image_urls: " + imageUrls + "," +
                "    street: \"" + street + "\"," +
                "    district: \"" + district + "\"," +
                "    city: \"" + city + "\"," +
                "    area: " + area + "," +
                "    price: " + price + "," +
                "    contact_name: \"" + name + "\"," +
                "    contact_phone: \"" + phone + "\"," +
                "    contact_email: \"" + email + "\"," +
                "    contact_address: \"" + address + "\"" +
                "  }) {" +
                "    status" +
                "    error" +
                "  }" +
                "}";

        String webserviceHost = env.getProperty("graphql.host");
        String urlString = webserviceHost + "/graphql";
        String urlParams = "query=" + query.replace(" ", "%20");
        System.out.println("[PostController] url = " + urlString + "?" + urlParams);

        try {
            String res = PostUtils.sendPost(new URL(urlString), urlParams);
            System.out.println("[PostController] response = " + res);
            JSONObject json = new JSONObject(res);
            JSONObject insertPost = json.getJSONObject("data").getJSONObject("insertPost");
            String status = insertPost.getString("status");
            if("success".equals(status)) {
                request.setAttribute("post_success", "1");
            } else {
                request.setAttribute("post_success", "0");
            }

            return "post";
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "post";
    }

    public static void main(String[] args) {
        String str = "New year's resolution 2018:\n" +
                "1. Đọc sách 30'/ngày (1 cuốn mỗi tháng)\n" +
                "2. Nói tiếng anh hàng ngày\n" +
                "3. Ngủ sớm trước 12h30\n" +
                "4. Học từ mới hàng ngày\n" +
                "5. Học xong series YDKJS\n" +
                "6. Tập TD hàng ngày (Thor: 2-3h/day, 2-3times/day...)\n" +
                "7. Đọc báo, đọc AEE, nghe tiếng anh hàng ngày\n";
        str = str.replaceAll("(\r\n|\n)", "<br>");
        System.out.println(str);
    }
}
