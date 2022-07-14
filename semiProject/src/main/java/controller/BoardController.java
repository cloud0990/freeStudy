package controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import dao.BoardDao;
import vo.BoardVo;

@Controller
@RequestMapping("/board/")
public class BoardController {
	
	//전역변수처럼 선언되어있지만, 해당 메소드가 호출 될 때마다 DS가 넣어줌
	@Autowired
	HttpSession        session; 
	@Autowired
	HttpServletRequest request;
	@Autowired
	HttpServletRequest response;
	
	// 인터페이스(사용설명서) 객체를 생성한다.
	// -> Override는 마지막에 재정의된 메소드가 호출되기때문에, Impl 클래스 내에서 재정의된 메소드가 호출된다.
	BoardDao boardDao;
	public void setBoardDao(BoardDao boardDao) {
		this.boardDao = boardDao;
	}

	// 전체조회
	@RequestMapping("list.do")
	public String list(Model model) {
		
		//세션에 저장되어있는 show 정보 삭제
		session.removeAttribute("show");
		
		List<BoardVo> list = boardDao.selectList();
		
		model.addAttribute("list", list);
		
		return "board/board_list";
	}
	
	// 게시글 상세보기
	@RequestMapping("view.do")
	public String view(int b_idx, Model model) {
		
		//b_idx에 해당하는 게시물 정보 얻어오기
		BoardVo vo = boardDao.selectOne(b_idx);
		
		//해당게시물을 안 봤으면 조회수 증가
		if(session.getAttribute("show")==null) {
			
			//해당 페이지가 호출될 때마다 조회수 증가 -> 문제점 : 같은 사용자가 계속 새로고침해도 조회수로 적용되기때문에 session 저장
			int res = boardDao.update_readhit(b_idx);
			
			//show정보를 세션에 넣는다.
			session.setAttribute("show", true);
			
		}// end : if
		
		//결과적으로 DS가 request binding 해줌
		model.addAttribute("vo", vo);
		
		return "board/board_view";
	}
	
	// 새 글 쓰기 폼 띄우기
	@RequestMapping("insert_form.do")
	public String insert_form() {
		
		return "board/board_insert_form";
	}
	
	@RequestMapping("insert.do")
	public String insert(BoardVo vo, Model model) {
		
		//세션이 만료되어 로그아웃됐을 경우 글쓰기 제한
		if(session.getAttribute("user") == null) {
				
			model.addAttribute("reason", "session_timeout");

			return "redirect:../users/login_form.do";
		}
		
		
		String b_ip = request.getRemoteAddr();	
		
		vo.setB_ip(b_ip);
		
		int res = boardDao.insert(vo);
		
		return "redirect:list.do";
	}
	
	// 게시글 삭제
	@RequestMapping("delete.do")
	public String delete(int b_idx) {
		
		int res = boardDao.delete(b_idx);
		
		return "redirect:list.do";
	}
	
	
	// 답글쓰기 폼 띄우기
	@RequestMapping("reply_form.do")
	public String reply_form() {
		
		return "board/board_reply_form";
	}
	
	// 답글쓰기
	@RequestMapping("reply.do")
	public String reply(BoardVo vo) { 	
		
		String b_ip = request.getRemoteAddr();
		vo.setB_ip(b_ip);
		
		//기준글 정보 얻어오기
		BoardVo baseVo = boardDao.selectOne(vo.getB_idx());
		
		//기준글보다 b_step이 큰 게시물은 b_step + 1
		int res = boardDao.update_step(baseVo);
		
		//현재 답글의 정보 갱신 : 그룹글번호 그대로 받기 (같은 그룹에 있기 위함)
		vo.setB_ref(baseVo.getB_ref());
		vo.setB_step(baseVo.getB_step()+1);  //원래의 b_step보다  +1 셋팅 (원본글의 바로 밑에 위치)
		vo.setB_depth(baseVo.getB_depth()+1);//원래의 b_depth보다 +1 셋팅 (대댓글의 바로 밑에 위치) 
		
		//답글 등록
		res = boardDao.reply(vo);
		
		return "redirect:list.do";
	}
	
	// 수정폼 띄우기
	@RequestMapping("modify_form.do") 
	public String modify_form(int b_idx, Model model) {
		
		BoardVo vo = boardDao.selectOne(b_idx);
		
		model.addAttribute("vo", vo);
		
		return "board/board_modify_form";
	}
	
	// 수정하기
	@RequestMapping("modify.do")
	public String modify(BoardVo vo) {
		
		int res = boardDao.update(vo);
		
		return "redirect:list.do";
	}
	
	
	
}