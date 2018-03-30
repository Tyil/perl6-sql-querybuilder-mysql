#! /usr/bin/env perl6

use v6.c;

use SQL::QueryBuilder;
use Test;

plan 5;

subtest "Simple update query" => {
	plan 1;

	my $query = qb("mysql", "update")
		.table("shitty_table")
		.set(
			"bytes_sent" => 512,
		)
		;

	is ~$query, slurp("t/queries/update-simple.sql").chomp;
};

subtest "Update query with WHERE" => {
	plan 1;

	my $query = qb("mysql", "update")
		.table("shitty_table")
		.set(
			"bytes_sent" => 256,
		)
		.where(
			"id" => 18,
		)
		;

	is ~$query, slurp("t/queries/update-where.sql").chomp;
}

subtest "Update query with ORDER BY" => {
	plan 1;

	my $query = qb("mysql", "update")
		.table("shitty_table")
		.set(
			"bytes_sent" => 256,
		)
		.order-by(
			"id",
		)
		;

	is ~$query, slurp("t/queries/update-order-by.sql").chomp;
}

subtest "Update query with ORDER BY DESC" => {
	plan 1;

	my $query = qb("mysql", "update")
		.table("shitty_table")
		.set(
			"bytes_sent" => 256,
		)
		.order-by(
			"id" => "DESC",
		)
		;

	is ~$query, slurp("t/queries/update-order-by-desc.sql").chomp;
}

subtest "Update query with LIMIT" => {
	plan 1;

	my $query = qb("mysql", "update")
		.table("shitty_table")
		.set(
			"bytes_sent" => 256,
		)
		.limit(9)
		;

	is ~$query, slurp("t/queries/update-limit.sql").chomp;
}

# vim: ft=perl6 noet
