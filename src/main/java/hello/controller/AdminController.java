package hello.controller;

import hello.dao.PostDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

/**
 * Mỗi bài đăng có 2 field: enabled và approved
 * enabled = 0 & approved = 0: bài đăng vừa đăng và chưa được admin duyệt
 * enabled = 0 & approved = 1: bài đăng đã được admin duyệt và bài này ko được accept
 * enabled = 1 & approved = 1: bài đăng đã được admin duyệt và bài này được accept
 * enabled = 1 & approved = 0: KHÔNG XẢY RA
 */
@Controller
public class AdminController {

	@Autowired
	PostDAO postDAO;

	@RequestMapping(value= {"/{locale:en|vi}/admin", "/admin"})
	public String adminHome() {
		return "adminPage";
	}

	/**
	 * Nếu admin duyệt bài đăng mà thấy ko ổn thì ko enable bài đăng đó thôi, chứ ko xóa hẳn đi!
	 * Nếu muốn xóa thì sẽ xóa ở chỗ khác
	 * @return
	 */
	@RequestMapping(value= {"/{locale:en|vi}/admin/approve-post", "/admin/approve-post"})
	public String approvePost(Model model) {
		//model.addAttribute("postList", postDAO.getPostsToApprove());
		return "approve_post";
	}

	@RequestMapping(value= {"/{locale:en|vi}/admin/delete-post", "/admin/delete-post"})
	public String deletePost() {
		return "delete_post";
	}

	@RequestMapping(value= {"/admin/do-approve-post"}, method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String doApprovePost(HttpServletRequest request) {
		int postId = Integer.valueOf(request.getParameter("post_id"));
		String kq = postDAO.approvePost(postId);
		String kqReturn;
		if("OK".equals(kq)) {
			kqReturn = "{\"status\": \"success\", \"error\": null}";
		} else {
			kqReturn = "{\"status\": \"fail\", \"error\": \"" + kq + "\"}";
		}
		System.out.println("kqReturn = " + kqReturn);
		return kqReturn;
	}

	@RequestMapping(value= {"/admin/do-decline-post"}, method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String doDeclinePost(HttpServletRequest request) {
		int postId = Integer.valueOf(request.getParameter("post_id"));
		String kq = postDAO.declinePost(postId);
		String kqReturn;
		if("OK".equals(kq)) {
			kqReturn = "{\"status\": \"success\", \"error\": null}";
		} else {
			kqReturn = "{\"status\": \"fail\", \"error\": \"" + kq + "\"}";
		}
		System.out.println("kqReturn = " + kqReturn);
		return kqReturn;
	}
}
