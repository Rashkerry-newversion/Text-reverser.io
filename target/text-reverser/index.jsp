<%@ page import="app.TextReverser" %>
<html>
<head>
  <title>Fun Text Reverser!</title>
  <style>
    body { font-family: Arial; background-color: #f0f8ff; padding: 40px; }
    .container { background: white; padding: 20px; border-radius: 8px; width: 400px; margin: auto; text-align: center; }
    input, button { padding: 10px; margin-top: 10px; width: 80%; }
  </style>
</head>
<body>
  <div class="container">
    <h2>🔁 Reverse Your Text 🔁</h2>
    <form method="post">
      <input type="text" name="text" placeholder="Type something fun!" />
      <br>
      <button type="submit">Reverse!</button>
    </form>

    <%
      String input = request.getParameter("text");
      if (input != null && !input.trim().isEmpty()) {
        String reversed = TextReverser.reverse(input); // ✅ fixed here
    %>
        <p><strong>Reversed Text:</strong> <%= reversed %></p>
    <%
      }
    %>
  </div>
</body>
</html>

</html>