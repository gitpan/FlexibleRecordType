package FlexibleRecordType;

# Copyright (c) 2000 Greg London. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

$VERSION = '0.2';

use strict;
use Data::Dumper;
use FlexibleRecordInstance;


################################################################################



my $instance_list_key = 'RESERVED_FOR_ARRAY_REF_TO_ALL_INSTANCES_OF_THIS_TYPE';

################################################################################
sub New
################################################################################
{

	my $class=shift(@_);
	my $rec_typ_obj = { 
		$instance_list_key => [],
	};
	bless ($rec_typ_obj,$class);

	# do any object initialization here
	$rec_typ_obj->AddElement(@_);

	return $rec_typ_obj;
}


################################################################################
sub Instance
################################################################################
{
	print "INSIDE INSTANCE\n";
	my $record_type=shift(@_);

	# the next thing in the @_ array are hashes to be tied.
 	for(my $i=0; $i<scalar(@_); $i=$i+1)
		{
		print "tying $_[$i] \n";
		tie %{$_[$i]}, 'FlexibleRecordInstance', $record_type;
		$record_type->remember_this_instance($_[$i]);
		}


	# do any object initialization here

	print "AAA\n";

}


################################################################################
sub DeleteInstance
################################################################################
{

	my $record_type=shift(@_);
	my $record_instance;
	while(@_)
		{
		$record_instance = shift(@_);
		$record_type->forget_this_instance($record_instance);
		}
}


################################################################################
sub AddElement
################################################################################
{
	my $rec_typ_obj=shift(@_);

	my @element_array = keys(%$rec_typ_obj);

	while (@_)
		{
		my $element_name = shift(@_);
		if(exists($rec_typ_obj->{$element_name}))
			{
			warn "element to add already exists, \"$element_name\"";
			next;
			}

		$rec_typ_obj->{$element_name} = scalar @element_array;
		push(@element_array, $element_name);
		}
}


################################################################################
sub DeleteElement
################################################################################
{
	my $rec_typ_obj=shift(@_);
print "inside DeleteElement\n";

	my @element_array = keys(%$rec_typ_obj);

	my @deleted_list=();
	while (@_)
		{
		my $element_name = shift(@_);
	print "deleting $element_name\n";
		unless(exists($rec_typ_obj->{$element_name}))
			{
			warn "element to delete does not exist, \"$element_name\"";
			next;
			}

		push(@deleted_list, $element_name );

		my $index=$rec_typ_obj->{$element_name};
		delete($rec_typ_obj->{$element_name});

		######################################################
		######################################################
		# reindex the hash so that all element names 
		# point to new index numbers.
		# First, get the remaining element->index pairs
		my @keys = keys(%$rec_typ_obj);
		my @key_data_pair;
		foreach my $key (@keys)
			{
			next if ($key eq $instance_list_key);
			my $data = $rec_typ_obj->{$key};
			push(@key_data_pair, [$key,$data] );
			}

		# if we delete only one element, then simply sort the
		# elements by order of their indexes. (1,2,3,5,6,7)
		my @sorted_list = sort by_index_order (@key_data_pair);
	
		# then discard the old indexes, and reindex based on the
		# current sort order (1,2,3,4,5,6)
		for (my $i=0; $i<scalar(@sorted_list); $i=$i+1 )
			{
			$rec_typ_obj->{$sorted_list[$i]->[0]} = $i+1;
			}

		######################################################
		######################################################
		# now go through all instances of this object
		# and delete these elements from object array
		my $instance_ref = $rec_typ_obj->{$instance_list_key};
		my $tied_arr;
		foreach my $inst (@$instance_ref)
			{
			$tied_arr = tied($inst);
			splice(@$tied_arr, $index, 1);
			}
		}

	return @deleted_list;
}

	


################################################################################
sub by_index_order
################################################################################
{
	my $aa = $a->[1];
	my $bb = $b->[1];

	return $aa <=> $bb;
}



################################################################################
sub remember_this_instance
################################################################################
{
	my ($rec_typ_obj, $record_instance)=@_;
	print "remembering instance  ($rec_typ_obj, $record_instance)\n";
	push(@{$rec_typ_obj->{$instance_list_key}}, $record_instance);

}

################################################################################
sub forget_this_instance
################################################################################
{
	my ($rec_typ_obj, $record_instance)=@_;
	print "\n\n\nforgetting $record_instance \n";
	$rec_typ_obj->dump_list;
	for (my $i=0; 
		$i<scalar(@{$rec_typ_obj->{$instance_list_key}}); 
		$i=$i+1
	)
		{
		if($record_instance == $rec_typ_obj->{$instance_list_key}->[$i])
			{
			splice(@{$rec_typ_obj->{$instance_list_key}}, $i, 1);
			print "second dump\n";
			$rec_typ_obj->dump_list;
			return;
			}
		}

	#warn "could not find record instance $record_instance in master list";
}


sub dump_list 
{
	my ($rec_typ_obj)=@_;
	print "start dump list \n";
	foreach my $item (@{$rec_typ_obj->{$instance_list_key}})
		{
		next unless(defined($item));
		print "list contains $item \n";
		}
	print "end dump list \n\n";

}
################################################################################
################################################################################

1;
