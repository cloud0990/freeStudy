<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>

<!-- BootStrap 3.x 라이브러리 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<!-- 다음 주소찾기 API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<!-- SweetAlert2 라이브러리 -->
<script src="//cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<!-- CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/users_insert_form.css">
<!-- 자바스크립트 -->
<script type="text/javascript">
	
	//아이디 졍규식
	var regular_id = /^[a-zA-Z0-9]{3,16}$/;

	$(document).ready(function(){
		
		//키보드이벤트 처리
		//아이디 입력창에서 키가 입력되면 해당함수 호출 (시스템에 의해서 자동으로 호출된다 -> callback 익명함수)
		//어떤 키인지는 중요하지 않고, 눌린 것이 중요함
		$("#u_id").keyup(function(event){
			
			var u_id = $(this).val();
			
			if(regular_id.test(u_id)==false){
				
				$("#id_msg").html("영문자/숫자조합 3~16자리만 입력하세요.").css("color", "red");
				
				//가입버튼 비활성화
				$("#btn_register").attr("disabled", true);
				
				return;
			}

			$.ajax({
				
				url     : 'check_id.do',         
				data    : {'u_id' : u_id}, //Parameter -> check_id.do?u_id=one
				dataType: 'json',                //서버로부터 전달받을 데이터 타입지정
				success : function(result_data){

					if(result_data.result){ //사용가능
						
						$("#id_msg").html("사용가능한 ID 입니다.").css("color", "blue");

						$("#btn_register").attr("disabled", false);
					
					}else { //사용불가
						
						$("#id_msg").html("이미 사용 중인 ID 입니다.").css("color", "red");
						
						$("#btn_register").attr("disabled", true);
					}
				}
			}); // end : Ajax
		});	// end : keyEvent
	}); // end : document

	//주소찾기
	function find(){
		
		 //팝업 위치를 지정(화면의 가운데 정렬)
         var width  = 500; 
         var height = 600; 
		
		 new daum.Postcode({
	        oncomplete: function(data) {
	            
	            //데이터는 json으로 들어옴
	            //data = {'zonecode' : 12344, 'address' : '서울특별시 관악구', 'roadAddress' : '...', 'jibunAddress' : '...'}
	            
	        	//선택된 주소의 우편번호 넣기
	        	$("#u_zipcode").val(data.zonecode);
	        	
	        	//선택된 주소의 주소 넣기
	        	$("#u_addr").val(data.address);
	        },
	        
            width: width, 
            height: height
	    
		 }).open({
            left: (window.screen.width / 2) - (width / 2),
            top : (window.screen.height / 2) - (height / 2)
		 });
	}// end : find()
	
	//가입하기
	function send(f){
		
		var u_nickname = f.u_nickname.value.trim();
		var u_id       = f.u_id.value.trim();
		var u_pwd      = f.u_pwd.value.trim();
		var u_zipcode  = f.u_zipcode.value.trim();
		var u_addr     = f.u_addr.value.trim();
				
		if(u_nickname==''){
			alert('닉네임을 입력하세요.');
			f.u_nickname.value=null;
			f.u_nickname.focus();
			return;
		}
		
		if(u_id==''){
			alert('아이디를 입력하세요.');
			f.u_id.value=null;
			f.u_id.focus();
			return;
		}
		
		if(u_pwd==''){
			alert('비밀번호를 입력하세요.');
			f.u_pwd.value=null;
			f.u_pwd.focus();
			return;
		}
		
		if(u_zipcode==''){
			alert('우편번호를 입력하세요.');
			f.u_zipcode.value=null;
			f.u_zipcode.focus();
			return;
		}
		
		if(u_addr==''){
			alert('주소를 입력하세요.');
			f.u_addr.value=null;
			f.u_addr.focus();
			return;
		}

		Swal.fire({
		  title: '가입하시겠습니까?',
		  text: "입력된 정보로 가입합니다.",
		  icon: 'question',
		  showCancelButton: true,
		  confirmButtonColor: '#3085d6', 
		  cancelButtonColor: '#d33',
		  confirmButtonText: '가입',
		  cancelButtonText: '취소'
		}).then((result) => {
		  if (result.isConfirmed) {
				f.action = "insert.do"; //전송대상 지정
				f.submit(); //전송
		  }
		});
	}// end : send(f)
</script>
</head>
<body>
<form>
	<div id="box">
	   <div>
	      <div style="margin-top: 30px;"><h4>회원가입</h4></div>
	      <div style="margin-top: 30px;">
	      		<table class="table table-striped" id="insert_box">
	      			<tr>
	      				<th>닉네임</th>
      					<td><input name="u_nickname" id="u_nickname"></td>
	      			</tr>
      				<tr>
	      				<th>아이디</th>
      					<td><input name="u_id" id="u_id">
      						
      						<!-- 아이디 중복체크 -->
      						<span id="id_msg"></span>
      					</td>
	      			</tr>
      				<tr>
	      				<th>비밀번호</th>
      					<td><input type="password" name="u_pwd" id="u_pwd"></td>
	      			</tr>
      				<tr>
	      				<th>우편번호</th>
      					<td><input id="u_zipcode" name="u_zipcode">
      					
      						<input class="btn btn-default" type="button" value="Find Address" onclick="find();">
      					</td>
	      			</tr>
      				<tr>
	      				<th>주소</th>
      					<td><input name="u_addr" id="u_addr" size="50px"></td>
	      			</tr>
	      			
	      			<!-- 버튼생성 -->
	      			<tr>
	      				<td colspan="2" align="center">
	      					<div style="margin-bottom: 20px;">
		      					<input type="button" value="회원가입" id="btn_register" disabled="disabled" onclick="send(this.form);">
		      					<input type="button" value="목록보기" id="btn_list"     onclick="location.href='${pageContext.request.contextPath}/board/list.do'">
	      					</div>
	      				</td>
	      			</tr>
	      		</table>	
	      </div>
	   </div>
	</div>
</form>

</body>
</html>