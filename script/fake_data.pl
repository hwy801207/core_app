#!/usr/bin/env perl
use strict;
use warnings;
use v5.10;

use Mojo::Pg;
use SQL::Abstract::More;

my $dsn = 'postgresql://hwy:hwy@127.0.0.1/pblog';

my $pg = Mojo::Pg->new($dsn) or die "init pg failed $!\n";

$pg->abstract(SQL::Abstract::More->new);
#$pg->auto_migrate(1);


# insert tag
$pg->db->delete('blog_tag'); # clear table
map { $pg->db->insert('blog_tag', {name => $_}) } ('Linux', 'Perl', 'Mojo');

# insert user
$pg->db->delete('blog_article');
$pg->db->delete('blog_user');
my $v1_id = $pg->db->insert('blog_user', { username => 'v1', password => 'newpasswd', active => 0}, {returning => 'id'})->hash->{id};
my $v2_id = $pg->db->insert('blog_user', { username => 'v2', password => 'newpasswd', active => 1}, {returning => 'id'})->hash->{id};


# insert article
#
for my $i (1..100) {
my $now = `date '+20%y-%m-%d %H:%M:%S'`;
$pg->db->insert('blog_article', {title => "article_$i", content => "randome content from fake data $i",
				 created_time => $now, is_allow_comment => 1, is_delte => 1, user_id =>  $i%2 == 0 ? $v2_id: $v1_id});
}



