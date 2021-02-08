package main

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/jimmidyson/golang-repository-template/pkg/calculator"
	"github.com/jimmidyson/golang-repository-template/pkg/version"
)

func main() {
	fmt.Println(version.Print(filepath.Base(os.Args[0])))
	fmt.Printf("1+1=%d\n", calculator.Add(1, 1))
}
