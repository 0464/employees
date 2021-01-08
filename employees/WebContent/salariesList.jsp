<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>salariesList</title>
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
		<!-- salariesList 테이블 목록 -->
		<h1>salaries 테이블 목록</h1>
		<%
			// utf-8
			request.setCharacterEncoding("utf-8");
			// db
			Class.forName("org.mariadb.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1004");
		
			int currentPage = 1;
			int rowPerPage = 10;
			int beginSalary = 0;
			int endSalary = 0;
			int maxSalary = 0;
			// currentPage
			if (request.getParameter("currentPage") != null) {
				currentPage = Integer.parseInt(request.getParameter("currentPage"));
			}
			// max salary
			String msql = "select max(salary) from salaries";
			PreparedStatement mstmt = conn.prepareStatement(msql);
			ResultSet mrs = mstmt.executeQuery();
			if (mrs.next()) {
				maxSalary = mrs.getInt("max(salary)"); // 158,220
				endSalary = maxSalary;
			}
			// beginSalary
			if (request.getParameter("beginSalary") != null) {
				beginSalary = Integer.parseInt(request.getParameter("beginSalary"));
			}
			// endSalary
			if (request.getParameter("endSalary") != null) {
				endSalary = Integer.parseInt(request.getParameter("endSalary"));
			}
			// 처음 페이지 변수
			String sql = "";
			sql = "select emp_no, salary, from_date,to_date from salaries where salary between ? and ? order by emp_no asc limit ?,?";
			PreparedStatement stmt = conn.prepareStatement(sql);
			stmt.setInt(1, beginSalary);
			stmt.setInt(2, endSalary);
			stmt.setInt(3, (currentPage - 1) * rowPerPage);
			stmt.setInt(4, rowPerPage);
			ResultSet rs = stmt.executeQuery();
		%>
		<table class="table table-bordered table-hover">
			<thead>
				<tr>
					<th>emp_no</th>
					<th>salary</th>
					<th>from_date</th>
					<th>to_date</th>
				</tr>
			</thead>
			<tbody>
			<%
				while (rs.next()) {
			%>
				<tr>
					<td><%=rs.getInt("emp_no")%></td>
					<td><%=rs.getInt("salary")%></td>
					<td><%=rs.getString("from_date")%></td>
					<td><%=rs.getString("to_date")%></td>
				</tr>
			<%
				}
			%>
			</tbody>
		</table>
		<form class="form-inline" method="post" action="./salariesList.jsp">
			<div class="form-group">
				<label>salary :</label>
				<select class="form-control ml-1 mr-1" name="beginSalary">
				<%
					for (int i = 0; i < maxSalary; i = i + 10000) {
						if (beginSalary == i) {
				%>
							<option value="<%=i%>" selected="selected"><%=i%></option>
				<%
						} else {
				%>
							<option value="<%=i%>"><%=i%></option>
				<%
						}
					}
				%>
				</select>
				<select class="form-control mr-1" name="endSalary">
					<option value="<%=maxSalary%>"><%=maxSalary%></option>
					<%
						// a = maxSalary % 10000    maxSalary-a
						for (int i = maxSalary; i > 0; i = i - 10000) {
							int a = maxSalary % 10000;
							if (endSalary == i) {
					%>
							<option value="<%=i - a%>" selected="selected"><%=i - a%></option>
					<%
							} else {
					%>
							<option value="<%=i - a%>"><%=i - a%></option>
					<%
							}
						}
					%>
					<%--
					<select name="endSalary">
					<%
						int a = maxSalary % 10000;
						for(int i=maxSalary; i>0; i=i-10000) {
							if(i==maxSalary) {
					%>
								<option value="<%=i%>"><%=i%></option>
					<%
							} else
					%>
							<option value="<%=i-a%>"><%=i-a%></option>
					<%		
						}
					%> 
					--%>
				</select>
				<button class="form-control btn btn-outline-success" type="submit">검색</button>
			</div>
		</form><br>
		<!-- 페이징 네비게이션 -->
		<%
			String sql2 = ""; // 마지막 페이지 변수
			sql2 = "select count(*) from salaries where salary between ? and ?";
			PreparedStatement stmt2 = conn.prepareStatement(sql2);
			stmt2.setInt(1, beginSalary);
			stmt2.setInt(2, endSalary);
			ResultSet rs2 = stmt2.executeQuery();
			int totalCount = 0;
			if (rs2.next()) {
				totalCount = rs2.getInt("count(*)");
			}
			int lastPage = totalCount / rowPerPage;
			if (totalCount % rowPerPage != 0) {
				lastPage ++;
			}
		%>
		<ul class="pagination justify-content-center">
		<%
			if (currentPage != 1) {
		%>
			<li class="page-item">
				<a class="page-link" href="./salariesList.jsp?currentPage=<%=1%>&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>">처음으로</a>
			</li>
		<%
			}
		if (currentPage > 1) {
		%>
			<li class="page-item">
				<a class="page-link" href="./salariesList.jsp?currentPage=<%=currentPage - 1%>&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>">이전</a>
			</li>
		<%
			}
		if (currentPage < lastPage) {
		%>
			<li class="page-item">
				<a class="page-link" href="./salariesList.jsp?currentPage=<%=currentPage + 1%>&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>">다음</a>
			</li>
		<%
			}
		if (currentPage != lastPage) {
		%>
			<li class="page-item">
				<a class="page-link" href="./salariesList.jsp?currentPage=<%=lastPage%>&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>">마지막으로</a>
			</li>
		<%
			}
		%>
		</ul>
	</div>
</body>
</html>