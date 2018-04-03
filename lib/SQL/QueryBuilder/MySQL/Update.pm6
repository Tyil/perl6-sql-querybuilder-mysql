#! /usr/bin/env false

use v6.c;

use SQL::QueryBuilder::MySQL::Roles::Stringifier;
use SQL::QueryBuilder::Query::Update;

class SQL::QueryBuilder::MySQL::Update is SQL::QueryBuilder::Query::Update
{
	also does SQL::QueryBuilder::MySQL::Roles::Stringifier;

	method Str
	{
		my Str $sql = "UPDATE " ~ self.table-string;

		$sql ~= " {self.set-string}" if self.set;
		$sql ~= " {self.where-string}" if self.where;
		$sql ~= " {self.order-by-string}" if self.order-by;
		$sql ~= " {self.limit-string}" if self.limit;

		$sql ~ ";";
	}
}

# vim: ft=perl6 noet
