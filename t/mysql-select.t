#! /usr/bin/env perl6

use v6.c;
use Test;

plan 8;

use SQL::QueryBuilder::MySQL;

constant qb = SQL::QueryBuilder::MySQL;

subtest "Simple select query", {
	plan 1;

	$query = qb.type("select")
		.from("test")
		.select("column")
		;

	is ~$query, slurp("queries/select.sql")
}

subtest "Select with AS clause", {
	$query = qb.type("select")
		.from("test")
		.select-as("column" => "other_name")
		;

	is ~$query, slurp("queries/select-as.sql")
}

subtest "Select with multiple select clauses", {
	$query = qb.type("select")
		.from("test")
		.select("test_column")
		.select("yet_another_column", "foo", "bar")
		.select-as("column" => "other_name")
		;

	is ~$query, slurp("queries/select-multiple.sql")
}

subtest "Select with WHERE clause", {
	$query = qb.type("select")
		.from("test")
		.where("column", "a")
		;

	is ~$query, slurp("queries/select-where.sql")
}

subtest "Select with ORDER BY clause", {
	$query = qb.type("select")
		.from("test")
		.order-by("created_at")
		;

	is ~$query, slurp("queries/select-order-by.sql")
}

subtest "Select with LIMIT to skip results", {
	$query = qb.type("select")
		.from("test")
		.skip(5)
		;

	is ~$query, slurp("queries/select-skip.sql")
}

subtest "Select with LIMIT to grab a limited set of results", {
	$query = qb.type("select")
		.from("test")
		.take(10)
		;

	is ~$query, slurp("queries/select-take.sql")
}

subtest "Select with LIMIT both skipping and limiting the resultselt", {
	$query = qb.type("select")
		.from("test")
		.skip(5)
		.take(10)
		;

	is ~$query, slurp("queries/select-limit.sql")
}

# vim: ft=perl6 noet
