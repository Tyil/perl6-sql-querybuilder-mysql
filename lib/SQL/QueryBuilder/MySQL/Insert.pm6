#! /usr/bin/env false

use v6.c;

use SQL::QueryBuilder::MySQL;

class SQL::QueryBuilder::MySQL::Insert
{
	has $.table;
	has SetHash $.columns;
	has @.records;

	#| Set the table name to insert into.
	method into(
		Str:D $table, #= The table name.
	) {
		$!table = $table;

		self;
	}

	#| Add columns to the query.
	method columns(
		*@columns, #= Any number of columns.
	) {
		for @columns -> $column {
			$!columns{~$column}++;
		}

		self;
	}

	#| Add a record to be inserted.
	method record(
		*@pairs, #= Any number of column => value pairs.
	) {
		my %record;

		for @pairs -> $pair {
			$!columns{~$pair.key}++;

			%record{$pair.key} = $pair.value;
		}

		@!records.push: %record;

		self;
	}

	#| Translate the Insert statement into a usable SQL query.
	method Str()
	{
		my @sorted-columns = $!columns.keys.sort;
		my @values;

		my Str $sql = "INSERT INTO `$!table` ({@sorted-columns.map("`" ~ *.Str ~ "`").join(', ')}) VALUES";

		if (@.records) {
			for @.records -> %record {
				my @record-values;

				for @sorted-columns -> $column {
					@record-values.push: SQL::QueryBuilder::MySQL.escape-value(%record{$column});
				}

				@values.push: @record-values.join(', ');
			}
		} else {
			my @record-values;

			for ^$!columns {
				@record-values.push: '?';
			}

			@values.push: @record-values.join(', ');
		}

		"$sql @values.map("(" ~ *.Str ~ ")").join(', ');";
	}
}

# vim: ft=perl6 noet
