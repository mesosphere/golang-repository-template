package calculator_test

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/jimmidyson/golang-repository-template/pkg/calculator"
	"github.com/jimmidyson/golang-repository-template/pkg/testutils"
)

func TestAdd(t *testing.T) {
	t.Parallel()
	args := []struct {
		i, j, expected int
	}{{
		1, 1, 2,
	}, {
		1, 2, 3,
	}, {
		100, 200, 300,
	}}
	for _, arg := range args {
		t.Run(fmt.Sprintf("%d+%d=%d", arg.i, arg.j, arg.expected), func(t *testing.T) {
			t.Parallel()
			assert.Equal(t, arg.expected, calculator.Add(arg.i, arg.j))
		})
	}
}

func TestAddIntegration(t *testing.T) {
	testutils.SkipIfShort(t, "skipping integration tests")
	t.Parallel()
	assert.Equal(t, 3, calculator.Add(1, 2))
}
