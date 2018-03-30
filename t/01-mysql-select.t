#! /usr/bin/env perl6

use v6.c;

use SQL::QueryBuilder;
use Test;

plan 8;

is qb("mysql", "select").table("test").column("column").Str,
	slurp("t/queries/select.sql").chomp,
	"Simple select query";

is qb("mysql", "select").from("test").select("column" => "other_name").Str,
	slurp("t/queries/select-as.sql").chomp,
	"Select with AS clause";

is qb("mysql", "select").from("test").select("test_column").select("yet_another_column", "foo", "bar").select("column" => "other_name").Str,
	slurp("t/queries/select-multiple.sql").chomp,
	"Select with multiple select clauses";

is qb("mysql", "select").from("test").where("column", "a").Str,
	slurp("t/queries/select-where.sql").chomp,
	"Select with WHERE clause";

is qb("mysql", "select").from("test").order-by("created_at").Str,
	slurp("t/queries/select-order-by.sql").chomp,
	"Select with ORDER BY clause";

is qb("mysql", "select").from("test").skip(5).Str,
	slurp("t/queries/select-skip.sql").chomp,
	"Select with LIMIT to skip results";

is qb("mysql", "select").from("test").take(10).Str,
	slurp("t/queries/select-take.sql").chomp,
	"Select with LIMIT to grab a limited set of results";

is qb("mysql", "select").from("test").skip(5).take(10).Str,
	slurp("t/queries/select-limit.sql").chomp,
	"Select with LIMIT both skipping and limiting the resultset";

# vim: ft=perl6 noet
