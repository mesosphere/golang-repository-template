package calculator_test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/jimmidyson/golang-repository-template/pkg/calculator"
	"github.com/jimmidyson/golang-repository-template/pkg/testutils"
)

func TestAdd(t *testing.T) {
	t.Parallel()
	assert.Equal(t, 2, calculator.Add(1, 1))
}

func TestAddIntegration(t *testing.T) {
	testutils.SkipIfShort(t, "skipping integration tests")
	t.Parallel()
	assert.Equal(t, 3, calculator.Add(1, 2))
}
