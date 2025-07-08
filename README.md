
# Run the simple Go Container application

```
docker build -t simple-go-app .
```
```
docker run -p 8080:8080 simple-go-app
```

# Test the application

```
curl http://localhost:8080
```