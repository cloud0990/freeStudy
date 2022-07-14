<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- JSTL태그라이브러리등록 : ArrayList가 여기로 넘어오니까 반복문으로 처리하기위함 -->
<%@taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>    
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>    
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전체 회원 목록</title>
<!-- BootStrap 3.x 라이브러리  -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<!-- SweetAlert2 라이브러리 -->
<script src="//cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<!-- CSS  -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/users_list.css">
<!-- 자바스크립트 -->
<script type="text/javascript">
	
	// 인자값에 해당하는 회원 삭제
	function del(u_idx){
		
		Swal.fire({
		  title: '정말 삭제하시겠습니까?',
		  text : "선택하신 사용자가 삭제됩니다.",
		  icon: 'question',
		  showCancelButton: true,
		  confirmButtonColor: '#3085d6', 
		  cancelButtonColor : '#d33',
		  confirmButtonText : '삭제',
		  cancelButtonText  : '취소'
		
		}).then((result) => {
		  
		  if (result.isConfirmed) {
			  location.href="delete.do?u_idx=" + u_idx;
		  }
		});
	}// end : del
</script>
</head>
<body>
	<!-- 전체회원 목록 출력 -->
	<div id="box">
		<h1 id="title">회원 목록</h1>		
			
			<!-- 회원가입 / 로그인 버튼 -->
			<div id="join">
				<input class="btn btn-success" type="button" value="돌아가기" onclick="location.href='../board/list.do'">		
			</div>
			
			<!-- 실제 데이터 출력 -->
			<div>
				<table class="table table-striped">
					<!-- 제목 -->				
					<tr class="default">
						<th>번호</th>
						<th>닉네임</th>
						<th>아이디</th>
						<th>비밀번호</th>
						<th>우편번호</th>
						<th>주소</th>
						<th>회원등급</th>
						<th>가입일자</th>
						<th>편집</th>
					</tr>
					
				<!-- 데이터가 없는 경우 -->
					<c:if test="${empty list}">
						<tr>
							<td colspan="10" align="center">
								<font color="red">등록된 회원이 없습니다.</font>
							</td>
						</tr>
					</c:if>
					
			   <!-- 데이터가 있는 경우 -->					
			   <c:forEach var="vo" items="${list}">
					<tr>
						<td>${vo.u_idx}</td>
						<td>${vo.u_nickname}</td>
						<td>${vo.u_id}</td>
						<td>${vo.u_pwd}</td>
						<td>${vo.u_zipcode}</td>
						<td>${vo.u_addr}</td>
						<td>${vo.u_grade}</td>
						<td>${ fn:substring(vo.u_regdate,0,10)}</td>
						<td>
							<input class="btn btn-info"    type="button" value="수정" onclick="location.href='modify_form.do?u_idx=${vo.u_idx}';">
							<input class="btn btn-danger"  type="button" value="삭제" onclick="del(${vo.u_idx})">
						</td>
					</tr>
				</c:forEach>
			</table>
		</div>
	</div>
</body>
</html>