#! /usr/bin/env false

use v6.c;

role SQL::QueryBuilder::MySQL::Roles::Escaper
{
	#| Escape a column name for safe use in a MySQL query.
	method escape-column(Any:D $column)
	{
		"`$column`"
	}

	#| Escape a table name for safe use in a MySQL query.
	method escape-table(Any:D $table)
	{
		"`$table`"
	}

	#| Escape a value to be safe for use in a MySQL query. TODO: Should be
	#| private, but multi-dispatch isn't available for private methods yet.
	multi method escape-value(Any:D $value)
	{
		"\"{~$value}\"";
	}

	#| Escape an Int to be safe for use in a MySQL query.TODO: Should be
	#| private, but multi-dispatch isn't available for private methods yet.
	multi method escape-value(Int:D $value)
	{
		$value;
	}
}

# vim: ft=perl6 noet
