<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
	<!-- �޴� -->
	<div>
		<table border="1">
			<tr>
				<td><a href="./index.jsp">Ȩ����</a></td>
				<td><a href="./departmentsList.jsp">departments ���̺� ���</a></td>
				<td><a href="./deptEmpList.jsp">dept_emp ���̺� ���</a></td>
				<td><a href="./deptManagerList.jsp">dept_manager ���̺� ���</a></td>
				<td><a href="./employeesList.jsp">employees ���̺� ���</a></td>
				<td><a href="./salariesList.jsp">salaries ���̺� ���</a></td>
				<td><a href="./titlesList.jsp">titles ���̺� ���</a></td>
			</tr>
		</table>
	</div>
	
	<!-- ���� -->
	<%
		request.setCharacterEncoding("UTF-8");
	
		int currentPage = 1; // �⺻���� 1�������� ����
		int rowPerPage = 10; // 1�������� 10�� ����
		if (request.getParameter("currentPage") != null) {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		// ���� ����
		String searchGender = "���þ���";
		if (request.getParameter("searchGender") != null) {
			searchGender = request.getParameter("searchGender");
		}
		// �̸� ����
		String searchName = "";
		if (request.getParameter("searchName") != null) {
			searchName = request.getParameter("searchName");
		}
		// DB
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1004");
		// ������
		String sql = "";
		PreparedStatement stmt = null;
		// ���� ����
		if (searchGender.equals("���þ���") && searchName.equals("")) {
			// ���� x, �̸� x
			sql = "SELECT emp_no, birth_date, first_name, last_name, gender, hire_date FROM employees LIMIT ?, ?";
			
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, (currentPage-1)*rowPerPage); 
			stmt.setInt(2, rowPerPage);
		} else if (!searchGender.equals("���þ���") && searchName.equals("")) {
			// ���� o, �̸� x
			sql = "SELECT emp_no, birth_date, first_name, last_name, gender, hire_date FROM employees WHERE gender=? LIMIT ?, ?";
			
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, searchGender);
			stmt.setInt(2, (currentPage-1)*rowPerPage); 
			stmt.setInt(3, rowPerPage);
		} else if (searchGender.equals("���þ���") && !searchName.equals("")) {
			// ���� x, �̸� o
			sql = "SELECT emp_no, birth_date, first_name, last_name, gender, hire_date FROM employees WHERE (first_name LIKE ? OR last_name LIKE ?) LIMIT ?, ?";
			
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+searchName+"%");
			stmt.setString(2, "%"+searchName+"%");
			stmt.setInt(3, (currentPage-1)*rowPerPage); 
			stmt.setInt(4, rowPerPage);
		} else if (!searchGender.equals("���þ���") && !searchName.equals("")) {
			// ���� o, �̸� o
			sql = "SELECT emp_no, birth_date, first_name, last_name, gender, hire_date FROM employees WHERE gender=? AND (first_name LIKE ? OR last_name LIKE ?) LIMIT ?, ?";
			
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, searchGender);
			stmt.setString(2, "%"+searchName+"%");
			stmt.setString(3, "%"+searchName+"%");
			stmt.setInt(4, (currentPage-1)*rowPerPage); 
			stmt.setInt(5, rowPerPage);
		}
		// ��� ���
		ResultSet rs = stmt.executeQuery();
	%>
	<!-- employees ���̺� ��� -->
	<h1>employees ���̺� ���</h1>
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
							����
						<%
							}else{
						%>
							����
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
	<!-- �˻� -->
	<form method="post" action="./employeesList.jsp">
		<div>
			����:
			<select name="searchGender">
				<%
					if (searchGender.equals("���þ���")) {
				%>
						<option value="���þ���" selected="selected">���þ���</option>
				<%
					} else {
				%>
						<option value="���þ���">���þ���</option>
				<%
					}
				%>
				<%
					if (searchGender.equals("M")) {
				%>
						<option value="M" selected="selected">��</option>
				<%
					} else {
				%>
						<option value="M">��</option>
				<%
					}
				%>
				
				<%
					if (searchGender.equals("F")) {
				%>
						<option value="F" selected="selected">��</option>
				<%
					} else {
				%>
						<option value="F">��</option>
				<%
					}
				%>
			</select>
			<!-- �˻� -->
			�̸�:
			<input type="text" name="searchName" value="<%=searchName %>">
			<button type="submit">�˻�</button>
			</div>
		<div>
			<!-- ����¡ �׺���̼� -->
			<% 
				if(currentPage != 1) {
			%>
					<a href="./employeesList.jsp?currentPage=1&searchGender=<%=searchGender%>&searchName=<%=searchName%>">ó������</a>
			<%
				}
				if(currentPage > 1) {
			%>
					<a href="./employeesList.jsp?currentPage=<%=currentPage-1%>&searchGender=<%=searchGender%>&searchName=<%=searchName%>">����</a>
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
					<a href="./employeesList.jsp?currentPage=<%=currentPage+1%>&searchGender=<%=searchGender%>&searchName=<%=searchName%>">����</a>
			<%
				}
				if (currentPage < lastPage) {
			%>
					<a href="./employeesList.jsp?currentPage=<%=lastPage%>&searchGender=<%=searchGender%>&searchName=<%=searchName%>">����������</a>
			<%
				}
			%>
		</div>
	</form>
</body>
</html>