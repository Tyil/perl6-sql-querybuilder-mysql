#! /usr/bin/env perl6

use v6.c;

use SQL::QueryBuilder;
use Test;

plan 8;

subtest "Simple select query", {
	plan 1;

	my $query = qb("mysql", "select")
		.from("test")
		.select("column")
		;

	is ~$query, slurp("queries/select.sql")
}

subtest "Select with AS clause", {
	my $query = qb("mysql", "select")
		.from("test")
		.select-as("column" => "other_name")
		;

	is ~$query, slurp("queries/select-as.sql")
}

subtest "Select with multiple select clauses", {
	my $query = qb("mysql", "select")
		.from("test")
		.select("test_column")
		.select("yet_another_column", "foo", "bar")
		.select-as("column" => "other_name")
		;

	is ~$query, slurp("queries/select-multiple.sql")
}

subtest "Select with WHERE clause", {
	my $query = qb("mysql", "select")
		.from("test")
		.where("column", "a")
		;

	is ~$query, slurp("queries/select-where.sql")
}

subtest "Select with ORDER BY clause", {
	my $query = qb("mysql", "select")
		.from("test")
		.order-by("created_at")
		;

	is ~$query, slurp("queries/select-order-by.sql")
}

subtest "Select with LIMIT to skip results", {
	my $query = qb("mysql", "select")
		.from("test")
		.skip(5)
		;

	is ~$query, slurp("queries/select-skip.sql")
}

subtest "Select with LIMIT to grab a limited set of results", {
	my $query = qb("mysql", "select")
		.from("test")
		.take(10)
		;

	is ~$query, slurp("queries/select-take.sql")
}

subtest "Select with LIMIT both skipping and limiting the resultselt", {
	my $query = qb("mysql", "select")
		.from("test")
		.skip(5)
		.take(10)
		;

	is ~$query, slurp("queries/select-limit.sql")
}

# vim: ft=perl6 noet
