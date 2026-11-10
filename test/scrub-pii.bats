#!/usr/bin/env bats
# Tests for bin/scrub-pii. Run: bats test/

setup() { BIN="${BATS_TEST_DIRNAME}/../bin/scrub-pii"; }

@test "clean text passes (exit 0)" {
  run bash -c "printf 'just some text\nno secrets here\n' | '$BIN'"
  [ "$status" -eq 0 ]
}

@test "flags an email (exit 1)" {
  run bash -c "printf 'contact a@b.com\n' | '$BIN'"
  [ "$status" -eq 1 ]
  [[ "$output" == *"[email]"* ]]
}

@test "flags an AWS access key id" {
  # split so the test source itself contains no contiguous key
  run bash -c "printf 'AKIA%s\n' 'IOSFODNN7EXAMPLE' | '$BIN'"
  [ "$status" -eq 1 ]
  [[ "$output" == *"aws-akid"* ]]
}

@test "flags a github token" {
  run bash -c "printf 'ghp_%s\n' 'abcdefghij0123456789abcd' | '$BIN'"
  [ "$status" -eq 1 ]
  [[ "$output" == *"github-token"* ]]
}

@test "flags a generic secret assignment" {
  run bash -c "printf 'api_key = %s\n' 'supersecretvalue' | '$BIN'"
  [ "$status" -eq 1 ]
}

@test "scans a file argument" {
  printf 'password: %s\n' 'hunter2hunter2' > "$BATS_TEST_TMPDIR/f.txt"
  run "$BIN" "$BATS_TEST_TMPDIR/f.txt"
  [ "$status" -eq 1 ]
}
