#! /usr/bin/env perl6

use v6.c;

use SQL::QueryBuilder::MySQL::Insert;
use Test;

plan 2;

constant qb = SQL::QueryBuilder::MySQL::Insert;

subtest "Simple insert query" => {
	plan 1;

	my $query = qb.new.into("analytics_access")
		.record(
			"remote_addr" => "127.1",
			"timestamp" => "today",
			"method" => "https",
			"path" => "/",
			"proto" => "HTTP/2.0",
			"status" => "p good",
			"bytes_sent" => 512,
			"referer" => "tyil",
			"user_agent" => "yes",
		);

	is ~$query, slurp("t/queries/insert-values.sql");
};

subtest "Prepared insert query" => {
	plan 1;

	my $query = qb.new.into("analytics_access")
		.columns(
			"remote_addr",
			"timestamp",
			"method",
			"path",
			"proto",
			"status",
			"bytes-sent",
			"referer",
			"user_agent",
		);

	is ~$query, slurp("t/queries/insert-prepared.sql");
};

# vim: ft=perl6 noet
