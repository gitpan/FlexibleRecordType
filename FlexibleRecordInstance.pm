package FlexibleRecordInstance;

# Copyright (c) 2000 Greg London. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

$VERSION = '0.2';

use strict;
use Data::Dumper;

my $instance_list_key = 'RESERVED_FOR_ARRAY_REF_TO_ALL_INSTANCES_OF_THIS_TYPE';

sub TIEHASH
{
	my $self = shift;
	my $type = shift;
	my $obj = [$type];
	bless($obj, 'FlexibleRecordInstance');
	#return $obj;
}


sub FETCH
{
	my ($obj,$key) = @_;
	my $index = 0;
	$index = $obj->[0]->{$key} unless ($key eq $instance_list_key);
	my $value = $obj->[$index];
	return $value;
}

sub STORE
{
	my ($obj,$key,$value) = @_;
	my $index = 0;
	$index = $obj->[0]->{$key} unless ($key eq $instance_list_key);
	$obj->[$index]=$value;
}


sub DELETE
{
	my ($obj,$key) = @_;
	my $record_type = $obj->[0];
	$record_type->DeleteElement($key);
}

sub CLEAR
{
	my ($obj) = @_;
	my $record_type = $obj->[0];
	my @keys = keys(%{$record_type});
	foreach my $key (@keys)
		{
		next if ($key eq $instance_list_key);
		$record_type->DeleteElement($key);
		}
}

sub EXISTS
{
	my ($obj,$key)=@_;
	my $record_type = $obj->[0];
	return exists($record_type->{$key});
}

sub FIRSTKEY
{
	my ($obj)=@_;
	my $record_type = $obj->[0];
	my @keys = keys(%{$record_type});
	return $keys[0];
}

sub NEXTKEY
{
	my ($obj,$key)=@_;
	my $record_type = $obj->[0];
	my @keys = keys(%{$record_type});
	my $temp;
	for (my $i=0; $i<@keys; $i=$i+1)
		{
		$temp = $keys[$i];
		if($key eq $temp)
			{
			if ($i == (scalar(@keys)-1) )
				{
				return undef;
				}
			else
				{
				return $keys[$i+1];
				}
			}
		}
	return undef;
}


sub DESTROY
{
	return;
	my $record_instance = shift(@_);
	print "caught self destruct on instance $record_instance\n";
	$record_instance->DeleteInstance;
}




1;
