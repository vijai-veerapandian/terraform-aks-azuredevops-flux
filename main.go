package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"
)

type Response struct {
	Message   string    `json:"message"`
	Timestamp time.Time `json:"timestamp"`
	Version   string    `json:"version"`
}

type HealthResponse struct {
	Status string `json:"status"`
	Uptime string `json:"uptime"`
}

var startTime = time.Now()

func main() {
	// Get port from environment variable or default to 8080
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// Routes
	http.HandleFunc("/", homeHandler)
	http.HandleFunc("/health", healthHandler)
	http.HandleFunc("/api/status", statusHandler)

	fmt.Printf("Server starting on port %s...\n", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}

func homeHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/html")
	html := `
	<!DOCTYPE html>
	<html>
	<head>
		<title>Simple Go App</title>
		<style>
			body { font-family: Arial, sans-serif; margin: 40px; }
			.container { max-width: 600px; margin: 0 auto; }
			.endpoint { background: #f4f4f4; padding: 10px; margin: 10px 0; border-radius: 5px; }
		</style>
	</head>
	<body>
		<div class="container">
			<h1>Simple Go Web Application</h1>
			<p>Welcome to your containerized Go application!</p>
			
			<h2>Available Endpoints:</h2>
			<div class="endpoint">
				<strong>GET /</strong> - This home page
			</div>
			<div class="endpoint">
				<strong>GET /health</strong> - Health check endpoint
			</div>
			<div class="endpoint">
				<strong>GET /api/status</strong> - JSON status response
			</div>
			
			<p>Server is running and ready to handle requests!</p>
		</div>
	</body>
	</html>`
	fmt.Fprint(w, html)
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	uptime := time.Since(startTime).String()
	response := HealthResponse{
		Status: "healthy",
		Uptime: uptime,
	}

	json.NewEncoder(w).Encode(response)
}

func statusHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	response := Response{
		Message:   "Go application is running successfully!",
		Timestamp: time.Now(),
		Version:   "1.0.0",
	}

	json.NewEncoder(w).Encode(response)
}
