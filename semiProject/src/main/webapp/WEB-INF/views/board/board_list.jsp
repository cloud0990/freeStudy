<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 목록</title>
<!-- Bootstrap 외부라이브러리등록 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<!-- css  -->
<style type="text/css">
* {
	margin:0;
	padding:0;
}	
	
#box {
	width: 1000px;
	margin: auto;
	margin-top: 50px;
}

#title {
	text-align: left;
	font-size: 28px;
	font-weight: bold;
	color: gray;
	text-shadow: 1px 1px 3px gray;
}
		
#logInOut {
	text-align: right;
}

#writeBtn {
	margin-bottom: 5px;
	margin-top: 8px;
}

.headText, td {
	text-align: center;
}
</style>
<!-- 자바스크립트 -->
<script type="text/javascript">
	
	function insert_form() {
		
		// 로그인 여부 확인
		if("${empty user}"=="true") {
			
			if(!confirm('로그인 후 이용가능합니다.\n로그인 하시겠습니까?')) return;
			
			// 로그인 폼으로 이동
			location.href='${pageContext.request.contextPath}/users/login_form.do';
			
			return;
		}
		
		location.href='insert_form.do';
		
	}// end : insert_form()

</script>
</head>
<body>

<div id="box">
	<h1 id="title">게시판</h1>

<!-- 로그인/로그아웃버튼 -->	
	<div id="logInOut">
		<!-- 로그인 안 된 경우 -->
		<c:if test="${empty user}">
			<input class="btn btn-primary" type="button" value="로그인"   onclick="location.href='${pageContext.request.contextPath}/users/login_form.do'">
			<input class="btn btn-success" type="button" value="회원가입" onclick="location.href='${pageContext.request.contextPath}/users/insert_form.do'">
		</c:if>
		
		<!-- 로그인 된 경우 : 일반회원 -->
		<c:if test="${ not empty user && user.u_grade=='일반' }">
			<b>${user.u_nickname}</b> 님 환영합니다.
			<input class="btn btn-danger"  type="button" value="로그아웃" onclick="location.href='${pageContext.request.contextPath}/users/logout.do'">
		</c:if>
		<!-- 로그인 된 경우 : 관리자회원 -->
		<c:if test="${ not empty user && user.u_grade=='관리자' }">
			<b>${user.u_nickname}</b> 님(관리자) 환영합니다.
			<input class="btn btn-primary" type="button" value="회원관리" onclick="location.href='${pageContext.request.contextPath}/users/list.do'">
			<input class="btn btn-danger"  type="button" value="로그아웃" onclick="location.href='${pageContext.request.contextPath}/users/logout.do'">
		</c:if>
		
		<!-- 글쓰기버튼 -->	
			<div>
				<input class="btn btn-info" type="button" value="새글작성" id="writeBtn" onclick="insert_form();">
			</div>
	</div>
<!-- 게시판 목록 출력 -->
	<table class="table table-striped">
		
		<tr class="default">
			<th class="headText">번호</th>	
			<th class="headText" width="60%">제목</th>	
			<th class="headText">작성자</th>	
			<th class="headText">작성일자</th>	
			<th class="headText">조회수</th>	
		</tr>
		
		<!-- 데이터가 없는 경우 -->
		<c:if test="${empty list}">
			<tr>
				<td colspan="5" align="center">
					<font color="red">작성된 게시글이 없습니다.</font>
				</td>
			</tr>
		</c:if>

		<!-- 데이터가 있는 경우 -->
		<c:forEach var="vo" items="${list}">
			<tr>
				<td>${vo.b_idx}</td>	

				<td style="text-align: left;">
					
					<!-- 들여쓰기 (1 ~ b_depth 반복)-->
					<c:forEach begin="1" end="${vo.b_depth}">
						&nbsp;&nbsp;&nbsp;
					</c:forEach>
					<c:if test="${vo.b_depth ne 0}">ㄴ</c:if>

					<a href="view.do?b_idx=${vo.b_idx}">${vo.b_subject}</a>
				</td>	

				<td><span class="badge">${vo.u_nickname}</span></td>	
				<td>${fn:substring(vo.b_regdate,0,16)}</td>	
				<td>${vo.b_readhit}</td>	
			</tr>
		</c:forEach>
	</table>
	
</div><!-- end : box -->

</body>
</html>