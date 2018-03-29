#! /usr/bin/env false

use v6.c;

class SQL::QueryBuilder::MySQL
{
	#| Escape a column name for safe use in a MySQL query.
	method escape-column(Any:D $column)
	{
		"`$column`"
	}

	#| Escape a value to be safe for use in a MySQL query.
	multi method escape-value(Any:D $value)
	{
		"\"{~$value}\"";
	}

	#| Escape an Int to be safe for use in a MySQL query.
	multi method escape-value(Int:D $value)
	{
		$value;
	}
}

# vim: ft=perl6 noet
