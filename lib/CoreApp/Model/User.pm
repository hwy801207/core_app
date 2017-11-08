package CoreApp::Model::User;
use Mojo::Base -base;
use SQL::Abstract::More;

has 'pg';
# has 'log' => sub { state $log = Mojo::Log->new};
sub load_user {
	my ($self, $username) = @_;
    my $result = $self->pg->db->select( 
						   -from    => 'blog_user',
						   -columns => ['username', 'password'],
					       -where   => {username => $username }
					   )->hash;	
	return $result;
}

sub authenticate {
	my($self, $username, $password) = @_;

	my $user = $self->load_user($username);
	if ($user->{password} eq $password) {
		return $user;
	}
	else {
		return undef;
	}
}

sub register {
	my ($self, $username, $password) = @_;
	# 用户已经存在
	return undef if $self->load_user($username);
	# 插入用户
	$self->pg->db->insert(
		-into => 'blog_user',
		-values => { username => $username, 
					 password => $password,
					 active   => 1
					}
	);
}

1;