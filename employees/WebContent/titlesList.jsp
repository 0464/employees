<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>titlesList</title>
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
		<!-- titlesList 테이블 목록 -->
		<h1>titles 테이블 목록</h1>
		<%
			int currentPage = 1;
			int rowPerPage = 10;
			if(request.getParameter("currentPage") != null) {
				currentPage = Integer.parseInt(request.getParameter("currentPage"));
			}
			Class.forName("org.mariadb.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1004");
			
			String sql = "select emp_no,title,from_date,to_date from titles order by emp_no asc limit ?,?";
			PreparedStatement stmt = conn.prepareStatement(sql);
			stmt.setInt(1, (currentPage-1)*rowPerPage);
			stmt.setInt(2, rowPerPage);
			ResultSet rs = stmt.executeQuery();
		%>
		<table class="table table-bordered table-hover">
			<thead>
				<tr>
					<th>emp_no</th>
					<th>title</th>
					<th>from_date</th>
					<th>to_date</th>
				</tr>
			</thead>
			<tbody>
			<%
				while(rs.next()) {
			%>
				<tr>
					<td><%=rs.getInt("emp_no") %></td>
					<td><%=rs.getString("title") %></td>
					<td><%=rs.getString("from_date") %></td>
					<td><%=rs.getString("to_date") %></td>
				</tr>
			<%
				}
			%>
			</tbody>
		</table>
		<!-- 페이징 네비게이션 -->
		<ul class="pagination justify-content-center">
		<% 
			if(currentPage != 1) {
		%>
			<li class="page-item">
				<a class="page-link" href="./titlesList.jsp?currentPage=1">처음으로</a>
			</li>
		<%
			}
			if(currentPage > 1) {
		%>
			<li class="page-item">
				<a class="page-link" href="./titlesList.jsp?currentPage=<%=currentPage-1%>">이전</a>
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
				lastPage += 1;
			}
			if(currentPage < lastPage) {
		%>
			<li class="page-item">
				<a class="page-link" href="./titlesList.jsp?currentPage=<%=currentPage+1%>">다음</a>
			</li>
		<%
			}
			if (currentPage < lastPage) {
		%>
			<li class="page-item">
				<a class="page-link" href="./titlesList.jsp?currentPage=<%=lastPage%>">마지막으로</a>
			</li>
		<%
			}
		%>
		</ul>
	</div>
</body>
</html>