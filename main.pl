#!/usr/bin/env perl
use Mojolicious::Lite;
use warnings;
use strict;
use Encode qw/encode decode/;
use utf8;
use Data::Dumper;
binmode(STDOUT, ":utf8");
binmode(STDIN, ":utf8");

get '/' => sub{
    my $self = shift;
    $self->render('index');
};

post '/' => sub{
  my $self = shift;

  # パラメーターの取得
  my $regex = $self->param('regex');
  my $private = $self->param('private');
  my $message = $self->param('message');
  my $opt = $self->every_param('opt');
  my $opt_len = scalar(@$opt);
  my $option = "";
  my $regstr;
  my $regex_opt;
  #オプションを連結
  for (my $i = 0; $i < $opt_len; $i++) {
    if (defined ($opt->[$i])){
         $option = "$option" . "$opt->[$i]";
    };
  }
  #１個ずつ条件分岐
  #改行有りだと、空白で区切る
  my @record = split /\s+/, $message if $private;
  my $record_len = @record if $private;

  #エラー処理
  return $self->render(template => 'error', message  => 'Please input regex')
    unless $regex;
  return $self->render(template => 'error', message  => 'Please input text')
    unless $message;

   $regstr = "qr/$regex/$option";
   eval '$regex_opt = ' . $regstr;
   say $regstr;
   say $regex_opt;

  # フラッシュに保存
  $self->flash(regex => $regex);
  $self->flash(private => $private);
  $self->flash(message => $message);
  $self->render(template => 'result');
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
