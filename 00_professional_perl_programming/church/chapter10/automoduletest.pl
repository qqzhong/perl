#!/usr/bin/perl -w
# @author             :  Copyright (C) Church.ZHONG
# automoduletest.pl
use warnings;
use strict;
use lib '.';
use My::AutoModule;
one;
two;
three;
print(qx(date));
exit 0;
