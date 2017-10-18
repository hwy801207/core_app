package CoreApp::Model::User;
use Mojo::Base -base;
use SQL::Abstract::More;

has 'pg';

sub login {
	my ($self, $username, $password) = @_;
    my ($sql, @bind); 
    ($sql, @bind) = $self->pg->db->select( 
						   -from    => 'blog_user',
						   -columns => ['username', 'password'],
					       -where   => {username => $username }
					   );	
	my $result = $self->pg->db->query($sql, @bind);

	print $result;
}

1;