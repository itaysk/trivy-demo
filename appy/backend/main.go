package main

import (
	"fmt"

	"github.com/gin-gonic/gin"
)

var serverPort = 8080

func main() {
	router := gin.Default()

	router.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "pong",
		})
	})

	serverAddress := fmt.Sprintf(":%d", serverPort)
	fmt.Println("Server is running on ", serverAddress)
	router.Run(serverAddress)
}
