#!/usr/bin/env perl
use Mojolicious::Lite;
use warnings;
use strict;
use Encode qw/encode decode/;
use utf8;
use Data::Dumper;

# binmode(STDOUT, ":utf8");
# binmode(STDIN, ":utf8");

get '/' => sub{
    my $self = shift;
    $self->render('index');
};

post '/' => sub{
  my $self = shift;
  # パラメーターの取得
  my $private = $self->param('private');
  my $message = $self->param('message');
  my $regex = $self->param('regex');
  my $opt = $self->every_param('opt');
  my $opt_len = scalar(@$opt);
  my $option = "";
  #オプションを連結
  for (my $i = 0; $i < $opt_len; $i++) {
    if (defined ($opt->[$i])){
         $option = "$option" . "$opt->[$i]";
    };
  }

  my $regstr;
  my $regex_opt;

  if ($regex =~ /[\p{Han}\p{Hiragana}\p{Katakana}]/) {
    $regex_opt = $regex;
  }else{
    $regstr = "qr/$regex/$option";
    eval '$regex_opt = ' . $regstr;
  }


  #エラー処理
  return $self->render(template => 'error', message  => 'Please input regex')
    unless $regex;
  return $self->render(template => 'error', message  => 'Please input text')
    unless $message;
  
  #改行有りの場合、リファレンス作成
  my %matches_msg;
  my @msg_ref;
  if($private){
    my @msg_split = split (/\n/, $message);
    for my $msg (@msg_split){
      if ($msg =~ /$regex_opt/) {
          %matches_msg = (matches => encode('UTF-8',$&),  before => encode('UTF-8',$`), 
                                      after => encode('UTF-8',$'));
          push @msg_ref , \%matches_msg;
      }
    }
  }else{
    if ($message =~ /$regex_opt/) {
        push @msg_ref,$&;
        push @msg_ref,$`;
        push @msg_ref,$';
        # say Dumper @msg_ref;
    }
  }

  # フラッシュに保存
  $self->flash(regex => $regstr);
  $self->flash(private => $private);
  $self->flash(message => $message);
  $self->render(template => 'result',regex => $regstr);

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
