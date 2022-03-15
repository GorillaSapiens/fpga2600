#!/usr/bin/perl

## Copyright (c) 2005 Adam Wozniak
##
## Distributed under the Gnu General Public License
##
## maketest.pl ; perl script to create VHDL fomr 2K or 4K ROM image
## Copyright (C) 2005 Adam Wozniak
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
##
## The author may be contacted
## by email: adam@wozniakconsulting.com

## run as
## maketest.pl whatever.bin > whatever.vhdl

@foo = readpipe "od -t x1 -v $ARGV[0]";

$size = pop @foo;
$size =~ s/ //g;
$size = oct($size) - 1;


print "entity cart is \n";
print "   port (A(12 downto 0): in std_logic_vector;\n";
print "         D(7 downto 0) : inout std_logic_vector);\n";
print "end cart;\n";
print "\n";
print "architecture behav of cart is\n";
print "\n";
print "   type MEMTYPE is array (0 to $size) of std_logic_vector(7 downto 0);\n";
print "   constant ROM : MEMTYPE := (\n";

@data = ();

foreach $line (@foo)
{
   chomp $line;

   @bar = split / /, $line;
   shift @bar;

   foreach $bar (@bar)
   {
      push @data, "X\"$bar\"";
   }
}

while (@data > 8)
{
   @foo = ();
   push @foo, (pop @data);
   push @foo, (pop @data);
   push @foo, (pop @data);
   push @foo, (pop @data);
   push @foo, (pop @data);
   push @foo, (pop @data);
   push @foo, (pop @data);
   push @foo, (pop @data);
   print "      ";
   print join(",", @foo);
   print ",\n";
}
print "      ";
print join(",", @data);
print "\n";

print "         );\n";
print "\n";
print "begin\n";
print "\n";
print "   process(A)\n";
print "   begin\n";
print "      if (A(12) = '0') then\n";
print "         D <= \"ZZZZZZZZ\";\n";
print "      else\n";

if ($size == 2047)
{
   print "         D <= ROM(CONV_INTEGER(A(10 downto 0)));\n";
}
else
{
   print "         D <= ROM(CONV_INTEGER(A(11 downto 0)));\n";
}

print "      end if;\n";
print "   end process;\n";
print "\n";
print "end behav;\n";
