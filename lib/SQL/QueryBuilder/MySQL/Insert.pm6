#! /usr/bin/env false

use v6.c;

use SQL::QueryBuilder::MySQL::Roles::Stringifier;
use SQL::QueryBuilder::Query::Insert;

class SQL::QueryBuilder::MySQL::Insert is SQL::QueryBuilder::Query::Insert
{
	also does SQL::QueryBuilder::MySQL::Roles::Stringifier;

	#| Translate the Insert statement into a usable SQL query.
	method Str
	{
		my $sql = "INSERT INTO {self.table-string} ";

		return $sql ~ self!Str-insert(self.column) if self.values;
		return $sql ~ self!Str-prepare(self.column);
	}

	method !Str-insert(@columns is copy)
	{
		if (!@columns) {
			@columns = self.values[0].keys;
		}

		my @records;

		for self.values -> %record {
			my @record;

			for @columns -> $column {
				@record.push: self.escape-value(%record{$column});
			}

			@records.push: @record.join(',');
		}

		my Str $record-string = @records.map(sub ($r) { "($r)" }).join(',');
		my Str $column-string = @columns.map(sub ($c) { self.escape-column($c) }).join(',');

		"($column-string) VALUES $record-string;";
	}

	method !Str-prepare(@columns is copy)
	{
		die "Need a set of columns to prepare a query" if !@columns;

		my Str $record-string = ('?' xx @columns.elems).join(',');
		my Str $column-string = @columns.map(sub ($c) { self.escape-column($c.key) }).join(',');

		"($column-string) VALUES ($record-string);";
	}
}

# vim: ft=perl6 noet
