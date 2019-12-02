package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func handler(w http.ResponseWriter, r *http.Request) {
	name, err := os.Hostname()
	if err != nil {
		panic(err)
	}
	fmt.Fprintln(w, "Cześć, 🚢 => ", name)
}

func main() {
	http.HandleFunc("/", handler)
	fmt.Println("server started")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
