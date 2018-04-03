#! /usr/bin/env perl6

use v6.c;

use SQL::QueryBuilder;
use Test;

plan 5;

is qb("mysql", "update").table("shitty_table").set("bytes_sent" => 512),
	slurp("t/queries/update-simple.sql").chomp,
	"Simple update query";

is qb("mysql", "update").table("shitty_table").set("bytes_sent" => 256).where("id" => 18),
	slurp("t/queries/update-where.sql").chomp,
	"Update query with WHERE";

is qb("mysql", "update").table("shitty_table").set("bytes_sent" => 256).order-by("id"),
	slurp("t/queries/update-order-by.sql").chomp,
	"Update query with ORDER BY";

is qb("mysql", "update").table("shitty_table").set("bytes_sent" => 256).order-by("id" => "DESC"),
	slurp("t/queries/update-order-by-desc.sql").chomp,
	"Update query with ORDER BY DESC";

is qb("mysql", "update").table("shitty_table").set("bytes_sent" => 256).limit(9),
	slurp("t/queries/update-limit.sql").chomp,
	"Update query with LIMIT";

# vim: ft=perl6 noet
