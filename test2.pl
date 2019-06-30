#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;
use Data::Dumper;
use utf8;
use Encode qw/encode decode/;

# my $names = 'Fred Flinstone and Wilma Flinstone';

# if($names =~ m/(?<last_name>\w+) and \w+ \g{last_name}/){
#     say "I saw $+{last_name}";
#     say "$1";
# }

# $_ = "yabba dabba doo   ";
# if(/y(.)(.)\2\1/gs){
#     say "match!".($`).($&).($');
# }


# コマンドライン引数(UTF-8バイト文字列)
my $str1 = shift;

# UTF-8バイト文字列を内部文字列にデコード
say $str1;
$str1 = decode('UTF-8', $str1);


# 文字列リテラル (utf8プラグマが有効なので内部文字列になる)
my $str2 = qr/"日本語"/;
my $strr = "日本語";

# $str2 = decode('utf-8',$str2);
say utf8::is_utf8($str1) ? 'flagged' : 'no flag';
say utf8::is_utf8($strr) ? 'flagged' : 'no flag';
# say $str2;

# 内部文字列に変換すると正しく文字を数えることができる
print length $str2, "\n"; # 3

# 内部文字列どうしであれば正しく正規表現を使用できる
if ($str1 =~ /$strr/) {
  print "Match!\n";
}


say utf8::is_utf8($str1) ? 'flagged' : 'no flag';
say utf8::is_utf8($str2) ? 'flagged' : 'no flag';


# 出力する直前に内部文字列をバイト文字列にエンコード
$str1 = encode('UTF-8', $str1);
$str2 = encode('UTF-8', $str2);

print "'$str1' is match '$str2'\n";
# say encode('UTF-8',($`));
# say encode('UTF-8',($&));
# say encode('UTF-8',($'));

# my $str = "aaaa";
# my %person1;
# %person1 = (name => encode('utf-8',$&),  country => 'Japan', age => 19);
# my %person2 = (name => 'Taro', country => 'USA',   age => 45);
# my @infos;
# push @infos,\%person1;
# print Dumper @infos;


# my @persons = (\%person1, \%person2);

# push @$infos, '01:01' => [3, 2.1, 4.6];

# my $num = 12345;
# my $opt = "sm";
# my $regstr = 'qr/(\\d+)/' . $opt;
# my $regex;
# eval '$regex = ' . $regstr;

# say $regex;