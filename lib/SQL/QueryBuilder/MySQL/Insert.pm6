#! /usr/bin/env false

use v6.c;

use SQL::QueryBuilder::MySQL;

constant base = SQL::QueryBuilder::MySQL;

class SQL::QueryBuilder::MySQL::Insert
{
	has $.table;
	has @.columns;
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
		@!columns.push: |@columns;

		self;
	}

	#| Add a record to be inserted.
	method record(
		*@pairs, #= Any number of column => value pairs.
	) {
		my %record;

		for @pairs -> $pair {
			%record{$pair.key} = $pair.value;
		}

		@!records.push: %record;

		self;
	}

	#| Translate the Insert statement into a usable SQL query.
	method Str()
	{
		return self!Str-insert(@!columns) if @!records;
		return self!Str-prepare(@!columns);
	}

	method !Str-insert(@columns is copy)
	{
		if (!@columns) {
			die "Need at least a set of columns or a set of records" if !@!records;

			@columns = @!records[0].keys;
		}

		my @records;

		for @!records -> %record {
			my @record;

			for @columns -> $column {
				@record.push: SQL::QueryBuilder::MySQL.escape-value(%record{$column});
			}

			@records.push: @record.join(',');
		}

		my Str $record-string = @records.map(sub ($r) { "($r)" }).join(',');
		my Str $column-string = @columns.map(sub ($c) { base.escape-column($c) }).join(',');

		"INSERT INTO `$!table` ($column-string) VALUES $record-string;";
	}

	method !Str-prepare(@columns is copy)
	{
		die "Need a set of columns to prepare a query" if !@columns;
		my Str $record-string = ('?' xx @columns.elems).join(',');
		my Str $column-string = @columns.map(sub ($c) { base.escape-column($c) }).join(',');

		"INSERT INTO `$!table` ($column-string) VALUES ($record-string);";
	}
}

# vim: ft=perl6 noet
