#! /usr/bin/env false

use v6.c;

use SQL::QueryBuilder::MySQL::Roles::Escaper;

role SQL::QueryBuilder::MySQL::Roles::Stringifier
{
	also does SQL::QueryBuilder::MySQL::Roles::Escaper;

	method column-string
	{
		my @columns;

		for self.column -> $column {
			my Str $column-definition = self.escape-column($column.key);

			if ($column.key ne $column.value) {
				$column-definition ~= ' AS ' ~ self.escape-column($column.value);
			}

			@columns.push: $column-definition;
		}

		@columns.join(',');
	}

	multi method limit-string
	{
		"LIMIT {self.limit}";
	}

	multi method offset-string
	{
		"OFFSET {self.offset}"
	}

	method order-by-string
	{
		my @orders;

		for self.order-by -> $order {
			@orders.push: "{self.escape-column($order.key)} {$order.value}";
		}

		"ORDER BY {@orders.join(',')}";
	}

	method set-string
	{
		my @sets;

		for self.set -> $set {
			@sets.push: "{self.escape-column($set.key)}={self.escape-value($set.value)}";
		}

		"SET {@sets.join(',')}";
	}

	method table-string
	{
		my @tables;

		for self.table -> $table {
			@tables.push: self.escape-table($table);
		}

		@tables.join(',');
	}

	method where-string
	{
		my @wheres;

		for self.where -> %where {
			@wheres.push: self.escape-column(%where<column>) ~ %where<op> ~ self.escape-value(%where<value>);
		}

		"WHERE {@wheres.join(' AND ')}";
	}
}

# vim: ft=perl6 noet
