<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>dept_emp 목록</h1>
	<%
		int currentPage = 1; // currentPage가 넘어오지 않으면 1
		if(request.getParameter("currentPage") != null) {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		
		String ck = "no";
		if(request.getParameter("ck") != null) {
			ck = request.getParameter("ck");
		}
		
		String deptNo = "";
		if(request.getParameter("deptNo") != null) {
			deptNo = request.getParameter("deptNo");
		}
		
		int rowPerPage = 10;
		int beginRow = (currentPage-1)*rowPerPage;
		PreparedStatement stmt1 = null;
		PreparedStatement stmt2 = null;
		
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1004");
		String sql1 = "";
		String sql2 = "";
		if(ck.equals("no") && (deptNo.equals(""))) { // 체크 x, 부서검색 x
			stmt1 = conn.prepareStatement(sql1);
			stmt1.setInt(1, (currentPage-1)*rowPerPage);
			stmt1.setInt(2, rowPerPage);
			sql2 = "select count(*) from dept_emp order by emp_no desc";
			stmt2 = conn.prepareStatement(sql2);
			
		} else if(ck.equals("no") && (!deptNo.equals(""))) { // 체크 o, 부서검색 x
			sql1 = "select emp_no, dept_no, from_date, to_date from dept_emp where to_date = '9999-01-01' order by emp_no desc limit ?, ?";
			stmt1 = conn.prepareStatement(sql1);
			stmt1.setInt(1, (currentPage-1)*rowPerPage);
			stmt1.setInt(2, rowPerPage);
			sql2 = "select count(*) from dept_emp where to_date = '9999-01-01'";
			stmt2 = conn.prepareStatement(sql2);
			
		} else if(ck.equals("yes") && (deptNo.equals(""))) { // 체크 x, 부서검색 o
			sql1 = "select emp_no, dept_no, from_date, to_date from dept_emp where dept_no = ? order by emp_no desc limit ?, ?";
			stmt1 = conn.prepareStatement(sql1);
			stmt1.setString(1, deptNo);
			stmt1.setInt(2, (currentPage-1)*rowPerPage);
			stmt1.setInt(3, rowPerPage);
			sql2 = "select count(*) from dept_emp where dept_no = ?";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setString(1, deptNo);
			
		} else { // 체크 o, 부서검색 o
			sql1 = "select emp_no, dept_no, from_date, to_date from dept_emp where dept_no = ? and to_date = '9999-01-01' order by emp_no desc limit ?, ?";
			stmt1 = conn.prepareStatement(sql1);
			stmt1.setString(1, deptNo);
			stmt1.setInt(2, (currentPage-1)*rowPerPage);
			stmt1.setInt(3, rowPerPage);
			sql2 = "select count(*) from dept_emp where dept_no = ? and to_date = '9999-01-01'";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setString(1, deptNo);
		}
		PreparedStatement stmt = conn.prepareStatement(sql1);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs1 = stmt.executeQuery();
		ResultSet rs2 = stmt.executeQuery();
		
		int totalCount = 0;
		if(rs2.next()){
			totalCount = rs2.getInt("count(*)");
		}
				
		int lastPage = totalCount / rowPerPage;
		if(totalCount % rowPerPage != 0){
			lastPage += 1;
		}
		// dept_no 가져오기
		String sql3 = "select dept_no from departments";
		PreparedStatement stmt3 = conn.prepareStatement(sql3);
		ResultSet rs3 = stmt3.executeQuery();
	%>
	<form action="./deptEmpListTest.jsp">
	
		<%
			if(ck.equals("no")) {
		%>
				<input type="checkbox" name="ck" value="yes">현재 부서에 근무중
		<%
			} else {
		%>
				<input type="checkbox" name="ck" value="yes" checked="checked">현재 부서에 근무중
		<%
			}
		%>	
		<select name="deptNo">
			<option value="">선택안함</option>
			<%
				while(rs3.next()){
					if(deptNo.equals(rs3.getString("dept_no"))){
			%>
						<option value="<%=rs3.getString("dept_no")%>" selected="selected"><%=rs3.getString("dept_no")%></option>
			<%
					}else{
			%>
						<option value="<%=rs3.getString("dept_no")%>"><%=rs3.getString("dept_no")%></option>
			<%
					}
				}
			%>
		</select>
		<button type="submit">검색</button>
	</form>
	<table border = "1">
		<tr>
			<th>emp_no</th>
			<th>dept_no</th>
			<th>from_date</th>
			<th>to_date</th>
		</tr>
		<%
			while(rs1.next()) {
		%>
				<tr>
					<td><%=rs1.getInt("emp_no") %></td>
					<td><%=rs1.getString("dept_no") %></td>
					<td><%=rs1.getString("from_date") %></td>
					<td><%=rs1.getString("to_date") %></td>
				</tr>
		<%
			}
		%>
	</table>
	<!-- 페이징 네비게이션 -->
			<a href="./deptEmpList.jsp?currentPage=1&ck=<%=ck%>&deptNo=<%=deptNo%>">처음으로</a>
		<%
			if(currentPage > 1){
		%>
			<a href="./deptEmpList.jsp?currentPage=<%=currentPage-1%>&ck=<%=ck%>&deptNo=<%=deptNo%>">이전</a>
		<%
			}
		
		if(currentPage < lastPage){
		%>
			<a href="./deptEmpList.jsp?currentPage=<%=currentPage+1%>&ck=<%=ck%>&deptNo=<%=deptNo%>">다음</a>
		<%
		}
		%>
			<a href="./deptEmpList.jsp?currentPage=<%=lastPage%>&ck=<%=ck%>&deptNo=<%=deptNo%>">마지막으로</a>
</body>
</html>