<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
	<!-- 메뉴 -->
	<div>
		<table border="1">
			<tr>
				<td><a href="./index.jsp">홈으로</a></td>
				<td><a href="./departmentsList.jsp">departments 테이블 목록</a></td>
				<td><a href="./deptEmpList.jsp">dept_emp 테이블 목록</a></td>
				<td><a href="./deptManagerList.jsp">dept_manager 테이블 목록</a></td>
				<td><a href="./employeesList.jsp">employees 테이블 목록</a></td>
				<td><a href="./salariesList.jsp">salaries 테이블 목록</a></td>
				<td><a href="./titlesList.jsp">titles 테이블 목록</a></td>
			</tr>
		</table>
	</div>
	
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
	<table border="1">
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
	<form method="post" action="./employeesList.jsp">
		<div>
			성별:
			<select name="searchGender">
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
				%>
				
				<%
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
			이름:
			<input type="text" name="searchName" value="<%=searchName %>">
			<button type="submit">검색</button>
			</div>
		<div>
			<!-- 페이징 네비게이션 -->
			<% 
				if(currentPage != 1) {
			%>
					<a href="./employeesList.jsp?currentPage=1&searchGender=<%=searchGender%>&searchName=<%=searchName%>">처음으로</a>
			<%
				}
				if(currentPage > 1) {
			%>
					<a href="./employeesList.jsp?currentPage=<%=currentPage-1%>&searchGender=<%=searchGender%>&searchName=<%=searchName%>">이전</a>
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
					<a href="./employeesList.jsp?currentPage=<%=currentPage+1%>&searchGender=<%=searchGender%>&searchName=<%=searchName%>">다음</a>
			<%
				}
				if (currentPage < lastPage) {
			%>
					<a href="./employeesList.jsp?currentPage=<%=lastPage%>&searchGender=<%=searchGender%>&searchName=<%=searchName%>">마지막으로</a>
			<%
				}
			%>
		</div>
	</form>
</body>
</html>