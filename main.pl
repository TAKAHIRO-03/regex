#!/usr/bin/env perl
use Mojolicious::Lite;
use Data::Dumper;

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
    @msg_split = split (/\x0D\x0A/, $message);
    for my $msg (@msg_split){
      if ($msg =~ /$regex_opt/) {
          my %matches_msg = (matches => $&,  before => $`, after => $');
          push @msg_ref , (\%matches_msg);
      }
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
  
    $self->stash(regex => $regstr, judge_line => $judge_line, 
                    msg_ref => $msg_refen, msg_split => $msg_splits, message => $message);
    $self->render(template =>'result');

};

app -> start;
