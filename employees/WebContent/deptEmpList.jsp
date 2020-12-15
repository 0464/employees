<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
<!-- 메뉴  -->
	<div>
		<table border ="1">
			<tr>
				<td><a href="./">홈으로</a></td>
				<td><a href="./departmentsList.jsp">departments 테이블 목록</a></td>
				<td><a href="./deptEmpList.jsp">dept_emp 테이블 목록</a></td>
				<td><a href="./deptManagerList.jsp">dept_manager 테이블 목록</a></td>
				<td><a href="./employeesList.jsp">employees 테이블 목록</a></td>
				<td><a href="./salariesList.jsp">salaries 테이블 목록</a></td>
				<td><a href="./titlesList.jsp">titles 테이블 목록</a></td>
			</tr>
		</table>
	</div>
	
	<!-- dept_emp 테이블 목록 -->
	<h1>dept_emp 테이블 목록</h1>
	<%
		request.setCharacterEncoding("utf-8");
	
		//체크박스 변수
		String ck = "no";
		if(request.getParameter("ck") != null){
			ck = request.getParameter("ck"); // ck = "yes";
		}
		
		//select 부서 변수
		String deptNo = "";
		if(request.getParameter("deptNo") != null){
			deptNo = request.getParameter("deptNo");
		}
		
		//현재 페이지
		int currentPage = 1;
		
		if(request.getParameter("currentPage") != null){
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		
		int rowPerPage = 10;
		
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1004");
		System.out.println(conn + "<- conn");
		
		String sql1 = "";
		String sql2 = "";
		PreparedStatement stmt = null;
		PreparedStatement stmt2 = null;
		
		// 동적쿼리
		// 1. 체크x, 부서검색x
		if(ck.equals("no") && deptNo.equals("")){
			sql1 = "select emp_no, dept_no, from_date, to_date from dept_emp order by emp_no desc limit ?, ?";
			stmt = conn.prepareStatement(sql1);
			stmt.setInt(1, (currentPage-1)*rowPerPage);
			stmt.setInt(2, rowPerPage);
			sql2 = "select count(*) from dept_emp order by emp_no desc";
			stmt2 = conn.prepareStatement(sql2);
		// 2. 체크o, 부서검색x
		}else if(ck.equals("yes") && deptNo.equals("")){
			sql1 = "select emp_no, dept_no, from_date, to_date from dept_emp where to_date = '9999-01-01' order by emp_no desc limit ?, ?";
			stmt = conn.prepareStatement(sql1);
			stmt.setInt(1, (currentPage-1)*rowPerPage);
			stmt.setInt(2, rowPerPage);
			sql2 = "select count(*) from dept_emp where to_date = '9999-01-01'";
			stmt2 = conn.prepareStatement(sql2);
		// 3. 체크x, 부서검색o
		}else if(ck.equals("no") && deptNo.equals("")){
			sql1 = "select emp_no, dept_no, from_date, to_date from dept_emp where dept_no = ? order by emp_no desc limit ?, ?";
			stmt = conn.prepareStatement(sql1);
			stmt.setString(1, deptNo);
			stmt.setInt(2, (currentPage-1)*rowPerPage);
			stmt.setInt(3, rowPerPage);
			sql2 = "select count(*) from dept_emp where dept_no = ?";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setString(1, deptNo);
		// 4. 체크o, 부서검색o
		}else{
			sql1 = "select emp_no, dept_no, from_date, to_date from dept_emp where dept_no = ? and to_date = '9999-01-01' order by emp_no desc limit ?, ?";
			stmt = conn.prepareStatement(sql1);
			stmt.setString(1, deptNo);
			stmt.setInt(2, (currentPage-1)*rowPerPage);
			stmt.setInt(3, rowPerPage);
			sql2 = "select count(*) from dept_emp where dept_no = ? and to_date = '9999-01-01'";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setString(1, deptNo);
		}
		
		ResultSet rs1 = stmt.executeQuery();
		ResultSet rs2 = stmt2.executeQuery();
		
		// 테이블 총 개수
		int totalCount = 0;
		if(rs2.next()){
			totalCount = rs2.getInt("count(*)");
		}
				
		int lastPage = totalCount / rowPerPage;
		if(totalCount % rowPerPage != 0){
			lastPage ++;
		}
		
		//departments에 있는 dept_no 가져오기
		String sql3 = "select dept_no from departments";
		PreparedStatement stmt3 = conn.prepareStatement(sql3);
		ResultSet rs3 = stmt3.executeQuery();
	%>
	<!-- 현재 부서에 근무중인지 어느 부서인지 검색 -->
	<form action="./deptEmpList.jsp">
		<%
			if(ck.equals("no")){
		%>
				<input type="checkbox" name="ck" value="yes">현재 부서에 근무중
		<%
			}else{
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
	<!-- 목록 -->
	<table border="1">
		<thead>
			<tr>
				<th>emp_no</th>
				<th>dept_no</th>
				<th>from_date</th>
				<th>to_date</th>
			</tr>
		</thead>
		<tbody>
		<%
			while(rs1.next()){
		%>
			<tr>
				<td><%=rs1.getInt("emp_no")%></td>
				<td><%=rs1.getString("dept_no") %></td>
				<td><%=rs1.getString("from_date") %></td>
				<td><%=rs1.getString("to_date") %></td>
			</tr>
		<%
			}
		%>
		</tbody>
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