# Build the image
FROM golang:1.22 AS builder
WORKDIR /app
COPY . .
RUN go build -o myapp

# Run the image
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/myapp .
CMD ["./myapp"]