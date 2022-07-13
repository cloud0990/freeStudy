package controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import dao.UsersDao;
import vo.UsersVo;

@Controller
@RequestMapping("/users/")
public class UsersController {
	
	@Autowired
	HttpServletRequest request;
	@Autowired
	HttpServletResponse response;
	@Autowired
	HttpSession session;

	UsersDao usersDao;
	//Setter Injection
	public void setUsersDao(UsersDao usersDao) {
		this.usersDao = usersDao;
	}

	@RequestMapping("list.do")
	public String selectList(Model model) {
		
		List<UsersVo> list = usersDao.selectList();
		
		model.addAttribute("list", list);

		return "users/users_list";
	}
	
	//회원가입
	@RequestMapping("insert_form.do")
	public String insert_form() {
		
		return "users/users_insert_form";
	}
	@RequestMapping("insert.do")
	public String insert(UsersVo vo) {
		
		int res = usersDao.insert(vo);
		
		return "redirect:list.do";
	}
	
	//로그인
	@RequestMapping("login_form.do")
	public String login_form() {
		
		return "users/users_login_form";
	}
	@RequestMapping("modify_form.do")
	public String modify_form(UsersVo vo, Model model) {
		
		vo = usersDao.selectOne(vo.getU_idx());
		
		model.addAttribute("vo", vo);
		
		return "users/users_modify_form";
	}
	
	
	@RequestMapping("modify.do")
	public String modify(UsersVo vo) {
		
		int res = usersDao.update(vo);
		
		return "redirect:list.do";
	}
	
	@RequestMapping("logout.do")
	public String logout() {
		
		session.removeAttribute("user");
		
		return "redirect:list.do";
	}
	
	@RequestMapping("login.do")
	public String login(UsersVo user, Model model) {
		
		user = usersDao.selectOne(user.getU_id());
		
		if(user==null) {
			
			//model객체는, redirect시에는 파라미터로 전달된다.
			model.addAttribute("reason", "fail_id");
			
			return "redirect:login_form.do";
		}
		
		if(!user.getU_pwd().equals(user.getU_pwd())) {
			
			model.addAttribute("reason", "fail_pwd");
			model.addAttribute("m_id", user.getU_id());
			
			return "redirect:login_form.do";
		}
		
		session = request.getSession();
		session.setAttribute("user", user);
		
		return "redirect:../board/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(int u_idx) {
		
		int res = usersDao.delete(u_idx);
		
		return "redirect:list.do";
	}
	
	@RequestMapping(value="check_id.do", produces="text/json; charset=utf-8;")
	@ResponseBody
	public String checkId(UsersVo vo) {
		
		vo = usersDao.selectOne(vo.getU_id());
		
		boolean bResult = (vo==null) ? true : false;
		
		JSONObject json = new JSONObject();
		
		json.put("result", bResult);
		
		return json.toJSONString();
	}
	
}