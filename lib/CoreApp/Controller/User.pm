package CoreApp::Controller::User;
use Mojo::Base 'Mojolicious::Controller';
# 返回登录页面
sub login {
    my $c = shift;
    $c->render();
}

sub auth {
    my $c = shift;
    my $data = $c->req->params->to_hash;
    if ($c->user->authenticate($data->{username}, $data->{password})) {
        # session 会话
        $c->session(user => $data->{username});
        return $c->redirect_to("/");
    }
    else {
        $c->flash(message => "登录失败，用户名不存在或者密码不对");
        return $c->redirect_to("/login",)
    }
}

sub logout {
    my $c = shift;
    delete $c->session->{'user'};
    return $c->redirect_to("/login");
}

1;