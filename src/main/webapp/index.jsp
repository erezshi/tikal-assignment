<%@page import="org.shindelman.demo.HelloHandler"%>
<html>
<body>
	<%
		HelloHandler handler = new HelloHandler();
		out.print(handler.sayHello());
	%>
</body>
</html>
