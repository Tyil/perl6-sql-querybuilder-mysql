#! /usr/bin/env false

use v6.c;

class SQL::QueryBuilder::MySQL
{
	method type(Str:D $type)
	{
		my Str $lib = "SQL::QueryBuilder::MySQL::$type.tclc()";

		require ::($lib);

		return ::($lib).new;
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
