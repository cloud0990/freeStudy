<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 상세보기</title>
<!-- Bootstrap 외부라이브러리등록 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<!-- css -->
<style type="text/css">

* {
	margin:0;
	padding:0;
}

#box {
	width: 800px;
	margin: auto;
	margin-top: 100px;	
	
}

#subject {
	box-shadow: 1px 1px 2px black;
	border: 2px solid #cccccc;
	padding: 5px;
	margin-bottom: 15px;
	font-size: 18px;
	font-weight: bold;
}

#content {
	box-shadow: 1px 1px 2px black;
	border: 2px solid #cccccc;
	padding: 5px;
	margin-bottom: 15px;
	min-height: 100px;
	font-size: 18px;
}

#regdate {
	box-shadow: 1px 1px 2px black;
	border: 2px solid #cccccc;
	padding: 5px;
	margin-bottom: 15px;
}

#jobBtn {

}

#btn {
	float: right;
}

.badge {
	height: 20px;
	font-size: 13px;
}
</style>
<!-- 자바스크립트 -->
<script type="text/javascript">
	
	function reply_form() {
		
		//로그인하지 않았을 경우, 로그인 폼으로 이동
		if("${empty user}"=="true") {
			
			if(!confirm('답글쓰기는 로그인 후 이용가능합니다.\n로그인 하시겠습니까?')) {
			
				return;		

			} else {
				// url상에 특수문자.. 포함되어있을 수 있기때문에 encodeURIComponent로 인코딩
				// 로그인 폼으로 이동 후, 다시 목록보기를 했을 때, 로그인 하기 직전에 있던 페이지로 이동한다.
				location.href="${pageContext.request.contextPath}/users/login_form.do?url=" + encodeURIComponent(location.href);
			}
		//로그인 했을 경우, 답글쓰기 폼으로 이동	
		} else {
			
			location.href="reply_form.do?b_idx=${vo.b_idx}";
		}
	}// end : reply_form
	
	function del(b_idx) {
		
		if(!confirm('게시글을 정말 삭제하시겠습니까?')) return;
		
		location.href="delete.do?b_idx=" + b_idx;
	}// end : del
	
</script>
</head>
<body>

<div id="box">
	<div id="subject"><span class="badge">제목</span> ${vo.b_subject}</div>
	<div id="content">${vo.b_content}</div>
	<div id="regdate">
		<span class="badge">by ${vo.u_nickname}</span><br>
		작성일자: ${fn:substring(vo.b_regdate,0,16)}</div>
	<div id="jobBtn">
		
		<input class="btn btn-primary" type="button" value="목록보기" onclick="location.href='list.do'">
		
		<!-- 답글은 메인글에만 달 수 있음 -->
		<c:if test="${vo.b_step eq 0}">
			<input class="btn btn-success" type="button" value="답글쓰기" onclick="reply_form();">
		</c:if>
		
		<!-- 수정/삭제 권한은 게시글 작성자 본인에게만 부여 -->
		<c:if test="${user.u_idx eq vo.u_idx}">
			<div id="btn">
				<input class="btn btn-info"   type="button" value="수정" onclick="location.href='modify_form.do?b_idx=' + ${vo.b_idx}">
				<input class="btn btn-danger" type="button" value="삭제" onclick="del(${vo.b_idx});">
			</div>
		</c:if>
		
	</div>
</div>

</body>
</html>