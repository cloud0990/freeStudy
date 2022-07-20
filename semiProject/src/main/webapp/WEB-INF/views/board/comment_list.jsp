<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
* {
	margin: 0px;
	padding: 0px;
}
.nickname {
	font-size: 30px;
	font-weight: bold;
}
.content_type {
	margin-top: 10px;
	font-size: 16px;
	min-height:60px;
}
.content_type, .regdate_type {
	border: 1px solid #cccccc;
	padding: 5px;
}
.x_btn {
	float:right;
	color:white;
	border:none;
	font-size: 20px;
	font-weight: bold;
	background: none;
	margin-right: 10px;
}
#box {
	min-height: 600px;
	margin-bottom:50px;
}
</style>
<script type="text/javascript">
function comment_del(c_idx) {
	if(!confirm('정말 삭제하시겠습니까?')) return;
	//Ajax로 삭제
	$.ajax({
		url:'comment_delete.do',
		data:{'c_idx':c_idx},
		dataType:'json',
		success : function(res){
			if(res.result) {
				//삭제 후, 댓글 목록 다시 가져오기
				comment_list(global_page);
			}
		}
	});
}// end : comment_del
</script>
</head>
<body>

<hr>
<!-- 페이징 메뉴 -->
<a name="comment_page"></a>
<div style="font-size:18px;">
	<a href="#comment_page" onclick="comment_list(1);">1</a>&nbsp;&nbsp;
	<a href="#comment_page" onclick="comment_list(2);">2</a>&nbsp;&nbsp;
	<a href="#comment_page" onclick="comment_list(3);">3</a>&nbsp;&nbsp;
</div>

<div id="box">
<!-- for(CommentVo vo : list) -->
<c:forEach var="vo" items="${list}">
<hr>
	<div>
		<div class="nickname"><span class="badge">${vo.u_nickname}</span></div>		
		<div class="content_type">${vo.c_content}
			<!-- 작성자만 삭제가능 -->
			<c:if test="${user.u_idx eq vo.u_idx}">
				<input type="button" value="X" class="x_btn" onclick="comment_del('${vo.c_idx}');">
			</c:if>
		</div>
		<div class="regdate_type">작성일자: ${fn:substring(vo.c_regdate,0,16)}</div>
	</div>
</c:forEach>	
</div>
</body>
</html>