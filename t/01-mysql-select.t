#! /usr/bin/env perl6

use v6.c;

use SQL::QueryBuilder::MySQL::Select;
use Test;

constant q = SQL::QueryBuilder::MySQL::Select;

plan 8;

subtest "Simple select query", {
	plan 1;

	my $query = q.new
		.from("test")
		.select("column")
		;

	is ~$query, slurp("t/queries/select.sql")
}

subtest "Select with AS clause", {
	plan 1;

	my $query = q.new
		.from("test")
		.select("column" => "other_name")
		;

	is ~$query, slurp("t/queries/select-as.sql")
}

subtest "Select with multiple select clauses", {
	plan 1;

	my $query = q.new
		.from("test")
		.select("test_column")
		.select("yet_another_column", "foo", "bar")
		.select("column" => "other_name")
		;

	is ~$query, slurp("t/queries/select-multiple.sql")
}

subtest "Select with WHERE clause", {
	plan 1;

	my $query = q.new
		.from("test")
		.where("column", "a")
		;

	is ~$query, slurp("t/queries/select-where.sql")
}

subtest "Select with ORDER BY clause", {
	plan 1;

	my $query = q.new
		.from("test")
		.order-by("created_at")
		;

	is ~$query, slurp("t/queries/select-order-by.sql")
}

subtest "Select with LIMIT to skip results", {
	plan 1;

	my $query = q.new
		.from("test")
		.skip(5)
		;

	is ~$query, slurp("t/queries/select-skip.sql")
}

subtest "Select with LIMIT to grab a limited set of results", {
	plan 1;

	my $query = q.new
		.from("test")
		.take(10)
		;

	is ~$query, slurp("t/queries/select-take.sql")
}

subtest "Select with LIMIT both skipping and limiting the resultselt", {
	plan 1;

	my $query = q.new
		.from("test")
		.skip(5)
		.take(10)
		;

	is ~$query, slurp("t/queries/select-limit.sql")
}

# vim: ft=perl6 noet
