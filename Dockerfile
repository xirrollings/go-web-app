# Build stage
FROM golang:1.23-alpine AS base

WORKDIR /app

# Copy dependency files
COPY go.mod .

# Download dependencies
RUN go mod download

# Copy application source
COPY . .

# Build a statically linked binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main .

# Final stage
FROM gcr.io/distroless/static-debian12

WORKDIR /app

COPY --from=base /app/main .
COPY --from=base /app/static ./static

EXPOSE 8080

CMD ["./main"]