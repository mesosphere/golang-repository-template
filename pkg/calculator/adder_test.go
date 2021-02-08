package calculator_test

import (
	"testing"

	"github.com/jimmidyson/golang-repository-template/pkg/calculator"
)

func TestAdd(t *testing.T) {
	type args struct {
		i int
		j int
	}
	tests := []struct {
		name string
		args args
		want int
	}{{
		name: "1+1=2",
		args: args{1, 1},
		want: 2,
	}}
	for _, tt := range tests {
		//nolint:scopelint // Reusing nested inside subtest is OK.
		t.Run(tt.name, func(t *testing.T) {
			if got := calculator.Add(tt.args.i, tt.args.j); got != tt.want {
				t.Errorf("Add() = %v, want %v", got, tt.want)
			}
		})
	}
}
