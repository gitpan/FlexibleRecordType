package FlexibleRecordInstance;

# Copyright (c) 2000 Greg London. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

use strict;
use Data::Dumper;

$VERSION = '0.1';

###############################################################################
# set record element to value (if value given). return value of element.
###############################################################################
sub Value	
###############################################################################
{
	my $record_instance = shift(@_);
	my $element_name = shift(@_);
	if(@_)
		{
		my $value = shift(@_);
		$record_instance->{$element_name} = $value;
		}
	return $record_instance->{$element_name};
}


################################################################################
sub AddElement
################################################################################
{
	my $record_instance = shift(@_);
	my $record_type = $record_instance->[0];
	return $record_type->AddElement(@_);
}

################################################################################
sub DeleteElement
################################################################################
{
	my $record_instance = shift(@_);
	my $record_type = $record_instance->[0];
	return $record_type->DeleteElement(@_);
}


################################################################################
sub DeleteInstance
################################################################################
{
	my $record_instance = shift(@_);
	my $record_type = $record_instance->[0];
	return $record_type->DeleteInstance($record_instance);
}

###############################################################################
###############################################################################
1;
