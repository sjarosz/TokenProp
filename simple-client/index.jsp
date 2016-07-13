<%@page import="java.io.*" %>
<%@page import="java.util.*" %>
<%@page import="java.net.*" %>
<%@page import="java.nio.charset.StandardCharsets" %>

<html>
<head>
<script>
   function getCookie(cname) {
       var name = cname + "=";
       var ca = document.cookie.split(';');
       for(var i = 0; i <ca.length; i++) {
           var c = ca[i];
           while (c.charAt(0)==' ') {
               c = c.substring(1);
           }
           if (c.indexOf(name) == 0) {
               return c.substring(name.length,c.length);
           }
       }
       return "";
   }

  token = getCookie("localTokenRef").split(".");
  console.log("JWT - Scope JavaScript: "+getCookie("localTokenRef"));
  console.log("JWT Payload - Scope JavaScript: "+atob(token[1]));
</script>
</head>
<body>
<h1>Simple Client</h1>
<h2>Headers</h2>
<hr>

 <%
 out.println("<ul>");

 java.util.Enumeration names = request.getHeaderNames();
 while (names.hasMoreElements()) {
   String name = (String) names.nextElement();
   String value = request.getHeader(name);
   out.println(" <li> <b>" + name + "=</b>" + value +"</li>");
 }
 out.println("</ul>");
 %>

<hr>
<a href="http://iam.forgerockdemo.com/openam/oauth2/authorize?response_type=id_token&scope=openid%20profile&nonce=1234&client_id=MyClientID&redirect_uri=http://iam.forgerockdemo.com:18080/simpleclient/token.jsp">Get JWT Token</a> VIA OpenID Connect: Implicit Flow
<p> 
<hr>

<p>

<%
  	String jwt=null;
  	String jwtPayload=null;
	Cookie[] cookies = request.getCookies();
	if (cookies!=null){ 
        	for(int i = 0; i < cookies.length; i++) { 
            	Cookie c = cookies[i];
            		if (c.getName().equals("localTokenRef")) {
                		jwt=c.getValue();
            		}
        	} 
	}

   String recv;
   String recvbuff="";

   if (jwt != null){
     URL jsonpage = new URL("http://iam.forgerockdemo.com:58080/simplews/");
     URLConnection urlcon = jsonpage.openConnection();
     urlcon.setRequestProperty("x-header-oidc-token", jwt);
     urlcon.setRequestProperty("Content-Type", "application/json");

      InputStream is = urlcon.getInputStream();
      int c;
      while ((c = is.read()) != -1)
        recvbuff += (char) c;
     is.close();
   }

   String[] jwtParts=null;
   byte[] decodedValue = null;
   if (jwt == null){
      jwt="anonymous";
      jwtPayload="anonymous";
   } else {
      jwtParts = jwt.split("\\.");  // split token
      decodedValue = Base64.getDecoder().decode(jwtParts[1]);
      jwtPayload = new String(decodedValue, StandardCharsets.UTF_8);
   }

%>

JWT Scope - WebApp: <%=jwt%><p>
JWT Payload Scope - WebApp: <%=jwtPayload%>

<p>
<hr>
<h1>REST Web Service Output</h1>
<pre>
<textarea rows="20" cols="80">
<%=recvbuff%>
</textarea>
</pre>
<p>

<a href="http://iam.forgerockdemo.com/openam/UI/Logout?goto=http%3A%2F%2Fiam.forgerockdemo.com%3A18080%2Fsimpleclient%2F">Logout</a>
</body>
 
</html> 