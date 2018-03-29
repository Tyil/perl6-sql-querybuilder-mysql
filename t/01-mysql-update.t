#! /usr/bin/env perl6

use v6.c;

use SQL::QueryBuilder;
use Test;

plan 1;

subtest "Simple update query" => {
	plan 1;

	my $query = qb("mysql", "update")
		.into("shitty_table")
		.set(
			"bytes_sent" => 512,
		)
		;

	is ~$query, slurp("t/queries/update-simple.sql");
};

subtest "Update query with WHERE" => {
	my $query = qb("mysql", "update")
		.into("shitty_table")
		.set(
			"bytes_sent" => 256,
		)
		.where(
			"id" => 18,
		)
		;

	is ~$query, slurp("t/queries/update-where.sql");
}

subtest "Update query with ORDER BY" => {
	my $query = qb("mysql", "update")
		.into("shitty_table")
		.set(
			"bytes_sent" => 256,
		)
		.order-by(
			"id",
		)
		;

	is ~$query, slurp("t/queries/update-order-by.sql");
}

subtest "Update query with ORDER BY DESC" => {
	my $query = qb("mysql", "update")
		.into("shitty_table")
		.set(
			"bytes_sent" => 256,
		)
		.order-by(
			"id" => "DESC",
		)
		;

	is ~$query, slurp("t/queries/update-order-by-desc.sql");
}

subtest "Update query with LIMIT" => {
	my $query = qb("mysql", "update")
		.into("shitty_table")
		.set(
			"bytes_sent" => 256,
		)
		.limit(9)
		;

	is ~$query, slurp("t/queries/update-limit.sql");
}

# vim: ft=perl6 noet
