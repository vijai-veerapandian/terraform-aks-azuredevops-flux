
# Run the simple Go Container application

```
docker build -t my-go-app .
```

```
docker run -d --name little-go -p 8080:8080 my-go-app
```
```
curl http://localhost:8080
```