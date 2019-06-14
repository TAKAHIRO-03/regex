#!/usr/bin/env perl
use Mojolicious::Lite;
use warnings;
use strict;
use Encode qw/encode decode/;
use utf8;
binmode(STDOUT, ":utf8");
binmode(STDIN, ":utf8");

get '/' => sub{
    my $self = shift;
    say "aa";
    $self->render('index');
};

post '/' => sub{
  my $self = shift;
     # パラメーターの取得
  my $regex = $self->param('regex');
  my $private = $self->param('private');
  my $message = $self->param('message');
  
  unless($regex eq '' or $message eq ''){
    $self->render('result');
  }else{
    $self->redirect_to('/','error'=>'aaaa');
  }
  
};

# get '/result' => sub{
#     my $self = shift;
#     $self->render('result');
# };

# post '/result' => sub{
#     my $self = shift;
#     $self->render('index');
#     say "result押されたよ";
# };



app -> start;
