<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1004");
	String sql1 = "select max(salary) from salaries";
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	ResultSet rs1 = stmt1.executeQuery();
	int beginSalary = 0;
	int endSalary = 0;
	int maxSalary = 0;
	if(rs1.next()) {
		maxSalary = rs1.getInt("max(salary)"); // 158,220
		endSalary = maxSalary;
	}
	if(request.getParameter("beginSalary") != null) {
		beginSalary = Integer.parseInt(request.getParameter("beginSalary"));
	}
	if(request.getParameter("endSalary") != null) {
		endSalary = Integer.parseInt(request.getParameter("endSalary"));
	}
	
	String sql2 = "select * from salaries where salary between ? and ? limit 0, 10";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setInt(1, beginSalary);
	stmt2.setInt(2, endSalary);
	ResultSet rs2 = stmt2.executeQuery();
%>
	<h1>salaries 목록</h1>
	<table border="1">
		<tr>
			<th>emp_no</th>
			<th>salary</th>
			<th>from_date</th>
			<th>to_date</th>
		</tr>
		<%
			while(rs2.next()) {
		%>
				<tr>
					<td><%=rs2.getInt("emp_no")%></td>
					<td><%=rs2.getInt("salary")%></td>
					<td><%=rs2.getString("from_date")%></td>
					<td><%=rs2.getString("to_date")%></td>
				</tr>
		<%		
			}
		%>
	</table>
	<form method="post" action="./salariesListTest.jsp">
		<select name="beginSalary">
			<%
				for(int i=0; i<maxSalary; i=i+10000) {
			%>
					<option value="<%=i%>"><%=i%></option>
			<%		
				}
			%>
		</select>
		<select name="endSalary">
			<option value="<%=maxSalary%>"><%=maxSalary%></option>
			<%	// a = maxSalary % 10000    maxSalary-a
				for(int i=maxSalary; i>0; i=i-10000) {
					int a = maxSalary % 10000;
			%>
					<option value="<%=i-a%>"><%=i-a%></option>
			<%		
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
</body>
</html>