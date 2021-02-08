// Application which greets you.
package main

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/jimmidyson/golang-repository-template/pkg/version"
)

func main() {
	fmt.Println(version.Print(filepath.Base(os.Args[0])))
}
