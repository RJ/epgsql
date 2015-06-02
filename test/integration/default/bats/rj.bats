#!/usr/bin/env bats

@test "psql binary exists" {
    run which psql
    [ "$status" -eq 0 ]
}
