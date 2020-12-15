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
<!-- �޴�  -->
	<div>
		<table border ="1">
			<tr>
				<td><a href="./">Ȩ����</a></td>
				<td><a href="./departmentsList.jsp">departments ���̺� ���</a></td>
				<td><a href="./deptEmpList.jsp">dept_emp ���̺� ���</a></td>
				<td><a href="./deptManagerList.jsp">dept_manager ���̺� ���</a></td>
				<td><a href="./employeesList.jsp">employees ���̺� ���</a></td>
				<td><a href="./salariesList.jsp">salaries ���̺� ���</a></td>
				<td><a href="./titlesList.jsp">titles ���̺� ���</a></td>
			</tr>
		</table>
	</div>
	
	<!-- dept_emp ���̺� ��� -->
	<h1>dept_emp ���̺� ���</h1>
	<%
		request.setCharacterEncoding("utf-8");
	
		//üũ�ڽ� ����
		String ck = "no";
		if(request.getParameter("ck") != null){
			ck = request.getParameter("ck"); // ck = "yes";
		}
		
		//select �μ� ����
		String deptNo = "";
		if(request.getParameter("deptNo") != null){
			deptNo = request.getParameter("deptNo");
		}
		
		//���� ������
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
		
		// ��������
		// 1. üũx, �μ��˻�x
		if(ck.equals("no") && deptNo.equals("")){
			sql1 = "select emp_no, dept_no, from_date, to_date from dept_emp order by emp_no desc limit ?, ?";
			stmt = conn.prepareStatement(sql1);
			stmt.setInt(1, (currentPage-1)*rowPerPage);
			stmt.setInt(2, rowPerPage);
			sql2 = "select count(*) from dept_emp order by emp_no desc";
			stmt2 = conn.prepareStatement(sql2);
		// 2. üũo, �μ��˻�x
		}else if(ck.equals("yes") && deptNo.equals("")){
			sql1 = "select emp_no, dept_no, from_date, to_date from dept_emp where to_date = '9999-01-01' order by emp_no desc limit ?, ?";
			stmt = conn.prepareStatement(sql1);
			stmt.setInt(1, (currentPage-1)*rowPerPage);
			stmt.setInt(2, rowPerPage);
			sql2 = "select count(*) from dept_emp where to_date = '9999-01-01'";
			stmt2 = conn.prepareStatement(sql2);
		// 3. üũx, �μ��˻�o
		}else if(ck.equals("no") && deptNo.equals("")){
			sql1 = "select emp_no, dept_no, from_date, to_date from dept_emp where dept_no = ? order by emp_no desc limit ?, ?";
			stmt = conn.prepareStatement(sql1);
			stmt.setString(1, deptNo);
			stmt.setInt(2, (currentPage-1)*rowPerPage);
			stmt.setInt(3, rowPerPage);
			sql2 = "select count(*) from dept_emp where dept_no = ?";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setString(1, deptNo);
		// 4. üũo, �μ��˻�o
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
		
		// ���̺� �� ����
		int totalCount = 0;
		if(rs2.next()){
			totalCount = rs2.getInt("count(*)");
		}
				
		int lastPage = totalCount / rowPerPage;
		if(totalCount % rowPerPage != 0){
			lastPage ++;
		}
		
		//departments�� �ִ� dept_no ��������
		String sql3 = "select dept_no from departments";
		PreparedStatement stmt3 = conn.prepareStatement(sql3);
		ResultSet rs3 = stmt3.executeQuery();
	%>
	<!-- ���� �μ��� �ٹ������� ��� �μ����� �˻� -->
	<form action="./deptEmpList.jsp">
		<%
			if(ck.equals("no")){
		%>
				<input type="checkbox" name="ck" value="yes">���� �μ��� �ٹ���
		<%
			}else{
		%>
				<input type="checkbox" name="ck" value="yes" checked="checked">���� �μ��� �ٹ���
		<%
			}
		%>
		
		<select name="deptNo">
			<option value="">���þ���</option>
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
		<button type="submit">�˻�</button>
	</form>
	<!-- ��� -->
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
		<!-- ����¡ �׺���̼� -->
			<a href="./deptEmpList.jsp?currentPage=1&ck=<%=ck%>&deptNo=<%=deptNo%>">ó������</a>
		<%
			if(currentPage > 1){
		%>
			<a href="./deptEmpList.jsp?currentPage=<%=currentPage-1%>&ck=<%=ck%>&deptNo=<%=deptNo%>">����</a>
		<%
			}
		
		if(currentPage < lastPage){
		%>
			<a href="./deptEmpList.jsp?currentPage=<%=currentPage+1%>&ck=<%=ck%>&deptNo=<%=deptNo%>">����</a>
		<%
		}
		%>
			<a href="./deptEmpList.jsp?currentPage=<%=lastPage%>&ck=<%=ck%>&deptNo=<%=deptNo%>">����������</a>
</body>
</html>