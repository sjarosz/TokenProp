<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="java.nio.charset.StandardCharsets" %>
{
 <% 
  String samlPayload = null;
  String jwtPayload = null;

 java.util.Enumeration names = request.getHeaderNames();
 while (names.hasMoreElements()) {
   String name = (String) names.nextElement();
   String value = request.getHeader(name);
   out.println("\""+name + "\""+": " + "\""+value+"\",");
   if (name.equals("x-header-saml-token")) { samlPayload=value; }
   if (name.equals("x-header-oidc-token")) { jwtPayload=value; }
 } 

%>

<%
      if (samlPayload != null){ 
         byte[] decodedValue=null;
         decodedValue = Base64.getDecoder().decode(samlPayload);
         samlPayload = new String(decodedValue, StandardCharsets.UTF_8);
      }
    
      if (jwtPayload != null){ 
         String jwtParts[]=null;
         byte[] decodedValue=null;
         jwtParts = jwtPayload.split("\\.");  // split token
         decodedValue = Base64.getDecoder().decode(jwtParts[1]);
         jwtPayload = new String(decodedValue, StandardCharsets.UTF_8);
      }
%>

"decoded-jwt-payload": <%=jwtPayload%>,

"decoded-saml-payload": <%=samlPayload%>,
"content-type": "application/json"
}