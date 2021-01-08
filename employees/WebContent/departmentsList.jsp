<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>departmentList</title>
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
		<%
			int currentPage = 1; // 기본값을 1페이지
			int rowPerPage = 10; // 페이지당 10개 제한
			if (request.getParameter("currentPage") != null) {
				currentPage = Integer.parseInt(request.getParameter("currentPage"));
			}
			// 부서 변수
			String searchDeptName = "";
			if (request.getParameter("searchDeptName") != null) {
				searchDeptName = request.getParameter("searchDeptName");
			}
			// DB 접속
			Class.forName("org.mariadb.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1004");
			// 쿼리
			String sql = "";
			PreparedStatement stmt = null;
			// 동적 쿼리
			if (searchDeptName.equals("")) {
				// dept_name x
				sql = "SELECT dept_no, dept_name FROM departments ORDER BY dept_no ASC LIMIT ?, ?";
				stmt = conn.prepareStatement(sql);
				stmt.setInt(1, (currentPage-1)*rowPerPage); 
				stmt.setInt(2, rowPerPage);
			} else {
				// dept_name o
				sql = "SELECT dept_no, dept_name FROM departments WHERE dept_name LIKE ? ORDER BY dept_no ASC LIMIT ?, ?";
				stmt = conn.prepareStatement(sql);
				stmt.setString(1, "%"+searchDeptName+"%");
				stmt.setInt(2, (currentPage-1)*rowPerPage); 
				stmt.setInt(3, rowPerPage);
			}
			ResultSet rs = stmt.executeQuery();
		%>
		<!-- 목록 -->
		<h1>departments 테이블 목록</h1>
		<table class="table table-bordered table-hover">
			<thead>
				<tr>
					<th style="width:200px">dept_no</th>
					<th>dept_name</th>
				</tr>
			</thead>
			<tbody>
				<%
					while (rs.next()) {
				%>
						<tr>
							<td><%=rs.getString("dept_no") %></td>
							<td><%=rs.getString("dept_name") %></td>
						</tr>
				<%
					}
				%>
			</tbody>
		</table>
		<!-- 검색 -->
		<form method="post" action="./departmentsList.jsp">
			<div class="form-inline">
				<input class="form-control mr-1" type="text" name="searchDeptName" placeholder="dept_name" value="<%=searchDeptName %>">
				<button class="btn btn-outline-success" type="submit">검색</button>
			</div>
		</form>
		<!-- 페이지 전환부 -->
		<%
			// 1 페이지일 경우 이전 버튼과 처음으로 버튼 없음
			if (currentPage > 1) {
				if (searchDeptName.equals("")) { // dept_name x
		%>
					<a href='departmentsList.jsp'>처음으로</a>
					<a href='departmentsList.jsp?currentPage=<%=currentPage-1%>'>이전</a>
		<%
				} else if (!searchDeptName.equals("")) { // dept_name o
		%>
					<a href='departmentsList.jsp?deptName=<%=searchDeptName %>'>처음으로</a>
					<a href='departmentsList.jsp?currentPage=<%=currentPage-1%>&deptName=<%=searchDeptName %>'>이전</a>
		<%
				}
			}
			// 마지막으로, 다음
			String sql2 = "SELECT COUNT(*) FROM departments"; // count는 쿼리 행을 알수 있다.
			PreparedStatement stmt2 = conn.prepareStatement(sql2);
			ResultSet rs2 = stmt2.executeQuery();
			
			int totalCount = 0;
	
			if (rs2.next()) {
				totalCount = rs2.getInt("count(*)");
			}
			int lastPage = totalCount / rowPerPage;
			if (totalCount % rowPerPage != 0) {
				lastPage ++;
			}
			
			if (currentPage < lastPage) {
				if (searchDeptName.equals("")) { // dept_name x
		%>
					<a href='departmentsList.jsp?currentPage=<%=currentPage+1%>'>다음</a>
					<a href='departmentsList.jsp?currentPage=<%=lastPage%>'>마지막으로</a>
		<%
				} else if (!searchDeptName.equals("")) { // dept_name o
		%>
					<a href='departmentsList.jsp?currentPage=<%=currentPage+1%>&deptName=<%=searchDeptName %>'>다음</a>
					<a href='departmentsList.jsp?currentPage=<%=lastPage%>&deptName=<%=searchDeptName %>'>마지막으로</a>
		<%
				}
			}
		%>
	</div>
</body>
</html>