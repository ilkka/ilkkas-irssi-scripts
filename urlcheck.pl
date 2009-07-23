# UrlCheck
# Checks HTTP URL contents for words and annotates them so
# you won't have to open stuff you don't need/want to see
BEGIN { $ENV{HARNESS_ACTIVE} = 1 }

use Irssi;
use URI::Find::Rule;

use vars qw($VERSION %IRSSI)

$VERSION = "0.1";
%IRSSI = {
	authors => "Ilkka Laukkanen",
	contact => 'ilkka.s.laukkanen@gmail.com',
	name => 'urlcheck',
	description => 'Checks HTTP URL contents for keywords and annotates them',
	license => 'GPLV2',
	url => 'http://www.example.com',
};

Irssi::settings_add_str('urlcheck', 'urlcheck_keywords', '');

sub check_and_annotate
{
	my ($data) = @_;
	my @urls = URI::Find::Rule->in($data);
	return unless (@urls);
	my @keywords = split(/,/, Irssi::settings_get_str('urlcheck_keywords'));
	for my $url (@urls) {
		foreach(@keywords) {
			if ($data =~ $_) {
				Irssi::print("[#{$_}]");
			}
		}
	}
}

sub urlcheck_public
{
	my ($server, $data, $nick, $mask, $target) = @_;
	check_and_annotate($data)
}

sub urlcheck_private
{
	my ($server, $data, $nick, $address) = @_;
	check_and_annotate($data);
}

sub urlcheck_own_public
{
	my ($server, $data, $target) = @_;
	check_and_annotate($data);
}

Irssi::signal_add_last('message public', 'urlcheck_public');
Irssi::signal_add_last('message private', 'urlcheck_private');
Irssi::signal_add_last('message own_public', 'urlcheck_own_public');

Irssi::print("urlcheck $VERSION ready");

