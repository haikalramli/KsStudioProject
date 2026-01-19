<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Server Error | KS.Studio</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            color: #fff;
        }
        
        .error-container {
            text-align: center;
            padding: 40px;
            max-width: 600px;
        }
        
        .error-icon {
            font-size: 120px;
            color: #f39c12;
            margin-bottom: 20px;
            animation: shake 0.5s ease-in-out infinite;
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }
        
        .error-code {
            font-size: 100px;
            font-weight: 700;
            color: #f39c12;
            margin-bottom: 10px;
            text-shadow: 0 0 20px rgba(243, 156, 18, 0.5);
        }
        
        .error-title {
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 15px;
        }
        
        .error-message {
            font-size: 16px;
            color: #a0a0a0;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .btn-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 15px 30px;
            text-decoration: none;
            border-radius: 50px;
            font-weight: 500;
            font-size: 16px;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }
        
        .btn-home {
            background: linear-gradient(135deg, #2f5d50, #1a3a32);
            color: #fff;
            box-shadow: 0 4px 15px rgba(47, 93, 80, 0.3);
        }
        
        .btn-home:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 25px rgba(47, 93, 80, 0.5);
        }
        
        .btn-retry {
            background: transparent;
            color: #f39c12;
            border: 2px solid #f39c12;
        }
        
        .btn-retry:hover {
            background: #f39c12;
            color: #1a1a2e;
        }
        
        .error-details {
            margin-top: 40px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 12px;
            text-align: left;
        }
        
        .error-details summary {
            cursor: pointer;
            color: #888;
            font-size: 14px;
        }
        
        .error-details pre {
            margin-top: 15px;
            padding: 15px;
            background: rgba(0, 0, 0, 0.3);
            border-radius: 8px;
            font-size: 12px;
            color: #ff6b6b;
            overflow-x: auto;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
        
        .support-info {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: #888;
            font-size: 14px;
        }
        
        .support-info a {
            color: #f39c12;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <i class="bi bi-exclamation-triangle error-icon"></i>
        <div class="error-code">500</div>
        <h1 class="error-title">Internal Server Error</h1>
        <p class="error-message">
            Something went wrong on our end. Our team has been notified and is working to fix the issue. 
            Please try again later or contact support if the problem persists.
        </p>
        
        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/" class="btn btn-home">
                <i class="bi bi-house-door"></i>
                Back to Homepage
            </a>
            <button onclick="location.reload()" class="btn btn-retry">
                <i class="bi bi-arrow-clockwise"></i>
                Try Again
            </button>
        </div>
        
        <% if (exception != null) { %>
        <details class="error-details">
            <summary>Technical Details (for developers)</summary>
            <pre><%= exception.getMessage() %></pre>
        </details>
        <% } %>
        
        <div class="support-info">
            <p>Need help? Contact us at <a href="mailto:support@ksstudio.com">support@ksstudio.com</a></p>
        </div>
    </div>
</body>
</html>
