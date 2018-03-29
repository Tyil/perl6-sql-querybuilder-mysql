#! /usr/bin/env false

use v6.c;

use SQL::QueryBuilder::MySQL;

constant base = SQL::QueryBuilder::MySQL;

class SQL::QueryBuilder::MySQL::Select
{
	has Str $.table;
	has Pair @.columns;
	has Hash @.wheres;
	has Pair @.orders;
	has Int $skip;
	has Int $take;

	method from(Str:D $table)
	{
		$!table = $table;

		self;
	}

	multi method order-by(Str:D $column)
	{
		self.order-by($column, "ASC");
	}

	multi method order-by(Str:D $column, Str:D $order)
	{
		@!orders.push: $column => $order;

		self;
	}

	multi method select(Str:D $column)
	{
		self.select($column => $column);
	}

	multi method select(*@columns)
	{
		for @columns -> $column {
			self.select($column);
		}

		self;
	}

	multi method select(Pair:D $select)
	{
		@!columns.push: $select;

		self;
	}

	method skip(Int:D $skip)
	{
		$!skip = $skip;

		self;
	}

	method take(Int:D $take)
	{
		$!take = $take;

		self;
	}

	multi method where(Pair:D $where)
	{
		self.where($where.key, '=', $where.value);
	}

	multi method where(Str:D $column, Any:D $value)
	{
		self.where($column, '=', $value);
	}

	multi method where(Str:D $column, Str:D $op, Any:D $value)
	{
		@!wheres.push: %(
			:$column,
			:$op,
			:$value,
		);

		self;
	}

	method Str()
	{
		my Str $sql = "SELECT ";

		$sql ~= self!column-string;
		$sql ~= " FROM {base.escape-table($!table)}";
		$sql ~= self!where-string if @!wheres;
		$sql ~= self!order-by-string if @!orders;
		$sql ~= self.limit-string($!skip, $!take);

		$sql ~ ";";
	}

	method !column-string()
	{
		if (!@!columns) {
			return "*";
		}

		@!columns.map(sub ($c) {
			if ($c.key eq $c.value) {
				return base.escape-column($c.key)
			}

			base.escape-column($c.key) ~ ' AS ' ~ base.escape-column($c.value)
		}).join(',');
	}

	method !where-string()
	{
		my @wheres;

		for @!wheres -> %where {
			@wheres.push: "{base.escape-column(%where<column>)} %where<op> {base.escape-value(%where<value>)}"
		}

		" WHERE {@wheres.join(' AND ')}";
	}

	method !order-by-string()
	{
		my @orders;

		for @!orders -> $order {
			@orders.push: "{base.escape-column($order.key)} {$order.value}";
		}

		" ORDER BY {@orders.join(',')}";
	}

	#| Private multi methods aren't implemented yet, so these are currently
	#| public. Try not to use them directly from outside the class!
	multi method limit-string(Int:D $skip, Int:D $take)
	{
		" LIMIT $skip, $take";
	}

	multi method limit-string(Int:D $skip, Int:U $take)
	{
		" OFFSET $skip";
	}

	multi method limit-string(Int:U $skip, Int:D $take)
	{
		" LIMIT $take";
	}

	multi method limit-string(Int:U $skip, Int:U $take)
	{
		""
	}
}

# vim: ft=perl6 noet
