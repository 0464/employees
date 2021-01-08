<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>employeesList</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<!-- 메뉴 -->
	<div class="container"><br>
		<nav class="navbar navbar-expand-sm bg-dark navbar-dark">
			<ul class="navbar-nav">
				<li class="nav-item">
					<a class="nav-link" href="./index.jsp">홈으로</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="./departmentsList.jsp">departments</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="./deptEmpList.jsp">dept_emp</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="./deptManagerList.jsp">dept_manager</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="./employeesList.jsp">employees</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="./salariesList.jsp">salaries</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="./titlesList.jsp">titles</a>
				</li>
			</ul>
		</nav><br>
		<!-- 내용 -->
		<%
			request.setCharacterEncoding("UTF-8");
		
			int currentPage = 1; // 기본값을 1페이지로 설정
			int rowPerPage = 10; // 1페이지당 10개 제한
			if (request.getParameter("currentPage") != null) {
				currentPage = Integer.parseInt(request.getParameter("currentPage"));
			}
			// 성별 변수
			String searchGender = "선택안함";
			if (request.getParameter("searchGender") != null) {
				searchGender = request.getParameter("searchGender");
			}
			// 이름 변수
			String searchName = "";
			if (request.getParameter("searchName") != null) {
				searchName = request.getParameter("searchName");
			}
			// DB
			Class.forName("org.mariadb.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1004");
			// 쿼리문
			String sql = "";
			PreparedStatement stmt = null;
			// 동적 쿼리
			if (searchGender.equals("선택안함") && searchName.equals("")) {
				// 성별 x, 이름 x
				sql = "SELECT emp_no, birth_date, first_name, last_name, gender, hire_date FROM employees LIMIT ?, ?";
				
				stmt = conn.prepareStatement(sql);
				stmt.setInt(1, (currentPage-1)*rowPerPage); 
				stmt.setInt(2, rowPerPage);
			} else if (!searchGender.equals("선택안함") && searchName.equals("")) {
				// 성별 o, 이름 x
				sql = "SELECT emp_no, birth_date, first_name, last_name, gender, hire_date FROM employees WHERE gender=? LIMIT ?, ?";
				
				stmt = conn.prepareStatement(sql);
				stmt.setString(1, searchGender);
				stmt.setInt(2, (currentPage-1)*rowPerPage); 
				stmt.setInt(3, rowPerPage);
			} else if (searchGender.equals("선택안함") && !searchName.equals("")) {
				// 성별 x, 이름 o
				sql = "SELECT emp_no, birth_date, first_name, last_name, gender, hire_date FROM employees WHERE (first_name LIKE ? OR last_name LIKE ?) LIMIT ?, ?";
				
				stmt = conn.prepareStatement(sql);
				stmt.setString(1, "%"+searchName+"%");
				stmt.setString(2, "%"+searchName+"%");
				stmt.setInt(3, (currentPage-1)*rowPerPage); 
				stmt.setInt(4, rowPerPage);
			} else if (!searchGender.equals("선택안함") && !searchName.equals("")) {
				// 성별 o, 이름 o
				sql = "SELECT emp_no, birth_date, first_name, last_name, gender, hire_date FROM employees WHERE gender=? AND (first_name LIKE ? OR last_name LIKE ?) LIMIT ?, ?";
				
				stmt = conn.prepareStatement(sql);
				stmt.setString(1, searchGender);
				stmt.setString(2, "%"+searchName+"%");
				stmt.setString(3, "%"+searchName+"%");
				stmt.setInt(4, (currentPage-1)*rowPerPage); 
				stmt.setInt(5, rowPerPage);
			}
			// 결과 출력
			ResultSet rs = stmt.executeQuery();
		%>
		<!-- employees 테이블 목록 -->
		<h1>employees 테이블 목록</h1>
		<table class="table table-bordered table-hover">
			<thead>
				<tr>
					<th>emp_no</th>
					<th>birth_date</th>
					<th>first_name</th>
					<th>last_name</th>
					<th>gender</th>
					<th>hire_date</th>
				</tr>
			</thead>
			<tbody>
			<%
				while(rs.next()) {
			%>
				<tr>
					<td><%=rs.getInt("emp_no") %></td>
					<td><%=rs.getString("birth_date") %></td>
					<td><%=rs.getString("first_name") %></td>
					<td><%=rs.getString("last_name") %></td>
					<td>
					<%
						if(rs.getString("gender").equals("M")){
					%>
						남자
					<%
						}else{
					%>
						여자
					<%
						}
					%>
					</td>
					<td><%=rs.getString("hire_date") %></td>
				</tr>
			<%
				}
			%>
			</tbody>
		</table>
		<!-- 검색 -->
		<form class="form-inline mt-1 mb-1" method="post" action="./employeesList.jsp">
			<div class="form-group">
				<label>성별:</label>
				<select class="form-control ml-1 mr-1" name="searchGender">
				<%
					if (searchGender.equals("선택안함")) {
				%>
					<option value="선택안함" selected="selected">선택안함</option>
				<%
					} else {
				%>
					<option value="선택안함">선택안함</option>
				<%
					}
				%>
				<%
					if (searchGender.equals("M")) {
				%>
					<option value="M" selected="selected">남</option>
				<%
					} else {
				%>
					<option value="M">남</option>
				<%
					}
					if (searchGender.equals("F")) {
				%>
						<option value="F" selected="selected">여</option>
				<%
					} else {
				%>
						<option value="F">여</option>
				<%
					}
				%>
				</select>
				<!-- 검색 -->
				<label>이름 :</label>
				<input class="form-control ml-1 mr-1" type="text" name="searchName" value="<%=searchName %>">
				<button class="form-control btn btn-outline-success"type="submit">검색</button>
			</div>
		</form><br>
		<!-- 페이징 네비게이션 -->
		<ul class="pagination justify-content-center">
		<% 
			if(currentPage != 1) {
		%>
			<li class="page-item">
				<a class="page-link" href="./employeesList.jsp?currentPage=1&searchGender=<%=searchGender%>&searchName=<%=searchName%>">처음으로</a>
			</li>
		<%
			}
			if(currentPage > 1) {
		%>
			<li class="page-item">
				<a class="page-link" href="./employeesList.jsp?currentPage=<%=currentPage-1%>&searchGender=<%=searchGender%>&searchName=<%=searchName%>">이전</a>
			</li>
		<%
			}
		%>
		<%
			String sql2 = "select count(*) from employees";
			PreparedStatement stmt2 = conn.prepareStatement(sql2);
			ResultSet rs2 = stmt2.executeQuery();
			int totalCount = 0;
			if(rs2.next()) {
				totalCount = rs2.getInt("count(*)");
			}
			int lastPage = totalCount / rowPerPage;
			if(totalCount % rowPerPage != 0) {
				lastPage ++;
			}
			if(currentPage < lastPage) {
		%>
			<li class="page-item">
				<a class="page-link" href="./employeesList.jsp?currentPage=<%=currentPage+1%>&searchGender=<%=searchGender%>&searchName=<%=searchName%>">다음</a>
			</li>
		<%
			}
			if (currentPage < lastPage) {
		%>
			<li class="page-item">
				<a class="page-link" href="./employeesList.jsp?currentPage=<%=lastPage%>&searchGender=<%=searchGender%>&searchName=<%=searchName%>">마지막으로</a>
			</li>
		<%
			}
		%>
		</ul>
	</div>
</body>
</html>