<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Page Not Found | KS.Studio</title>
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
            color: #e94560;
            margin-bottom: 20px;
            animation: float 3s ease-in-out infinite;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-20px); }
        }
        
        .error-code {
            font-size: 100px;
            font-weight: 700;
            color: #e94560;
            margin-bottom: 10px;
            text-shadow: 0 0 20px rgba(233, 69, 96, 0.5);
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
        
        .btn-home {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 15px 35px;
            background: linear-gradient(135deg, #2f5d50, #1a3a32);
            color: #fff;
            text-decoration: none;
            border-radius: 50px;
            font-weight: 500;
            font-size: 16px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(47, 93, 80, 0.3);
        }
        
        .btn-home:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 25px rgba(47, 93, 80, 0.5);
        }
        
        .suggestions {
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .suggestions h4 {
            font-size: 14px;
            color: #888;
            margin-bottom: 15px;
            text-transform: uppercase;
            letter-spacing: 2px;
        }
        
        .suggestions a {
            display: inline-block;
            color: #e94560;
            text-decoration: none;
            margin: 0 10px;
            transition: color 0.3s;
        }
        
        .suggestions a:hover {
            color: #fff;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <i class="bi bi-camera-video-off error-icon"></i>
        <div class="error-code">404</div>
        <h1 class="error-title">Page Not Found</h1>
        <p class="error-message">
            Oops! The page you're looking for doesn't exist or has been moved. 
            It might have been removed, renamed, or is temporarily unavailable.
        </p>
        <a href="${pageContext.request.contextPath}/" class="btn-home">
            <i class="bi bi-house-door"></i>
            Back to Homepage
        </a>
        
        <div class="suggestions">
            <h4>Quick Links</h4>
            <a href="${pageContext.request.contextPath}/jsp/client/Homepage.jsp">Homepage</a>
            <a href="${pageContext.request.contextPath}/jsp/client/Login.jsp">Login</a>
            <a href="${pageContext.request.contextPath}/jsp/client/Packages.jsp">Packages</a>
        </div>
    </div>
</body>
</html>
