#! /usr/bin/env perl6

use v6.c;

use SQL::QueryBuilder;
use Test;

plan 3;

subtest "Simple insert query" => {
	plan 1;

	my $query = qb("mysql", "insert")
		.into("analytics_access")
		.record(
			"bytes_sent" => 512,
			"method" => "https",
			"path" => "/",
			"proto" => "HTTP/2.0",
			"referer" => "tyil",
			"remote_addr" => "127.1",
			"status" => "p good",
			"timestamp" => "today",
			"user_agent" => "yes",
		);

	is ~$query, slurp("t/queries/insert-values.sql");
};

subtest "Prepared insert query" => {
	plan 1;

	my $query = qb("mysql", "insert")
		.into("analytics_access")
		.columns(
			"bytes-sent",
			"method",
			"path",
			"proto",
			"referer",
			"remote_addr",
			"status",
			"timestamp",
			"user_agent",
		);

	is ~$query, slurp("t/queries/insert-prepared.sql");
};

subtest "Insert multiple records" => {
	plan 1;

	my $query = qb("mysql", "insert")
		.into("analytics_access")
		.record(
			"bytes_sent" => 512,
			"method" => "https",
			"path" => "/",
			"proto" => "HTTP/2.0",
			"referer" => "tyil",
			"remote_addr" => "127.1",
			"status" => "p good",
			"timestamp" => "today",
			"user_agent" => "yes",
		)
		.record(
			"bytes_sent" => 256,
			"method" => "http",
			"path" => "/some-file.html",
			"proto" => "HTTP/2.0",
			"referer" => "blackchaosnl",
			"remote_addr" => "127.1",
			"status" => "p good",
			"timestamp" => "tomorrow",
			"user_agent" => "no",
		);

	is ~$query, slurp("t/queries/insert-multiple-values.sql");
}

# vim: ft=perl6 noet
