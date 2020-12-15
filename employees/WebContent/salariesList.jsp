<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*"%>
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
				<td><a href="salariesList.jsp">salaries 테이블 목록</a></td>
				<td><a href="titlesList.jsp">titles 테이블 목록</a></td>
			</tr>
		</table>
	</div>

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
	<table border="1">
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
	<form method="post" action="./salariesList.jsp">
		<select name="beginSalary">
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
		<select name="endSalary">
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
		<button type="submit">검색</button>
	</form>
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
	<div>
		<%
			if (currentPage != 1) {
		%>
		<a href="./salariesList.jsp?currentPage=<%=1%>&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>">처음으로</a>
		<%
			}
		if (currentPage > 1) {
		%>
		<a href="./salariesList.jsp?currentPage=<%=currentPage - 1%>&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>">이전</a>
		<%
			}
		if (currentPage < lastPage) {
		%>
		<a href="./salariesList.jsp?currentPage=<%=currentPage + 1%>&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>">다음</a>
		<%
			}
		if (currentPage != lastPage) {
		%>
		<a href="./salariesList.jsp?currentPage=<%=lastPage%>&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>">마지막으로</a>
		<%
			}
		%>
	</div>
</body>
</html>