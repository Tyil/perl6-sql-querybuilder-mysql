#! /usr/bin/env false

use v6.c;

use SQL::QueryBuilder::Clauses::Limit;
use SQL::QueryBuilder::Clauses::OrderBy;
use SQL::QueryBuilder::Clauses::Set;
use SQL::QueryBuilder::Clauses::Where;
use SQL::QueryBuilder::MySQL::Roles::Stringifier;
use SQL::QueryBuilder::Query;

class SQL::QueryBuilder::MySQL::Update is SQL::QueryBuilder::Query
{
	also does SQL::QueryBuilder::Clauses::Set;
	also does SQL::QueryBuilder::Clauses::Where;
	also does SQL::QueryBuilder::Clauses::OrderBy;
	also does SQL::QueryBuilder::Clauses::Limit;

	also does SQL::QueryBuilder::MySQL::Roles::Stringifier;

	method Str
	{
		my $sql = "UPDATE " ~ self.table-string;

		$sql ~= " " ~ self.set-string if self.set;
		$sql ~= " " ~ self.where-string if self.where;
		$sql ~= " " ~ self.order-by-string if self.order-by;
		$sql ~= " " ~ self.limit-string if self.limit;

		$sql ~ ";";
	}
}

# vim: ft=perl6 noet
