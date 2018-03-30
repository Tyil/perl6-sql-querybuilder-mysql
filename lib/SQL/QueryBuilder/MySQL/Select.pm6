#! /usr/bin/env false

use v6.c;

use SQL::QueryBuilder::MySQL::Roles::Stringifier;
use SQL::QueryBuilder::Query::Select;

class SQL::QueryBuilder::MySQL::Select is SQL::QueryBuilder::Query::Select
{
	also does SQL::QueryBuilder::MySQL::Roles::Stringifier;

	method Str
	{
		my Str $sql = "SELECT ";

		$sql ~= self.column-string || "*";
		$sql ~= " FROM {self.table-string}";
		$sql ~= " {self.where-string}" if self.where;
		$sql ~= " {self.order-by-string}" if self.order-by;
		$sql ~= " {self.limit-string}" if self.limit;
		$sql ~= " {self.offset-string}" if self.offset;

		$sql ~ ";";
	}
}

# vim: ft=perl6 noet
