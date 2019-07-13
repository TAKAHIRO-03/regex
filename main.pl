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
  my $judge_line = $self->param('judge_line');
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
  $regstr = "qr/$regex/$option";
  eval '$regex_opt = ' . $regstr;

  #エラー処理
  return $self->render(template => 'error', message  => 'Please input regex')
    unless $regex;
  return $self->render(template => 'error', message  => 'Please input text')
    unless $message;
  
  #改行有りの場合、リファレンス作成
  my @msg_ref;
  my @msg_split;
  my $msg_len;
  if($judge_line){
    @msg_split = split (/\x0A/, $message);

    warn "aiueo" . $msg_split[0];

    # warn "BBBBBBBBBB $message";
    # warn "awjivagjirjijaireij"."\t".scalar(@msg_split);
    for my $msg (@msg_split){
      warn "AAAAAAAAAAA" . encode("utf-8",$msg);
      #  if ($msg =~ /$regex_opt/) {
      #     my %matches_msg = (matches => $&,  before => $`, after => $');
      #     push @msg_ref , (\%matches_msg);
      # }
    }
  }else{
    if ($message =~ /$regex_opt/) {
        my %matches_msg = (matches => $&, before => $`, after => $');
        push @msg_ref , \%matches_msg;
        say Dumper @msg_ref;
    }
  }    

   my $msg_refen = \@msg_ref;
   my $msg_splits = \@msg_split;
  
   $self->stash(regex => $regstr);
   $self->stash(judge_line => $judge_line);   
   $self->stash(msg_ref => $msg_refen);
   $self->stash(msg_split => $msg_splits);
   $self->stash(message => $message);
   $self->render(template =>'result');

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
