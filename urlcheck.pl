# UrlCheck
# Checks HTTP URL contents for words and annotates them so
# you won't have to open stuff you don't need/want to see
BEGIN { $ENV{HARNESS_ACTIVE} = 1 }

use Irssi;
use URI::Find::Rule;
use LWP::Simple;

use vars qw($VERSION %IRSSI);

$VERSION = "0.1";
%IRSSI = {
	authors => "Ilkka Laukkanen",
	contact => 'ilkka.s.laukkanen@gmail.com',
	name => 'urlcheck',
	description => 'Checks HTTP URL contents for keywords and annotates them',
	license => 'GPLV2',
	url => 'http://www.example.com',
};

Irssi::settings_add_bool('urlcheck', 'urlcheck_active', 1);
Irssi::settings_add_str('urlcheck', 'urlcheck_keywords', '');

sub check_and_annotate
{
	my ($target, $data) = @_;
	return unless Irssi::settings_get_bool('urlcheck_active');
	my @urls = URI::Find::Rule->scheme('http')->in($data, 1);
	return unless (@urls);
	my @keywords = split(/,/, Irssi::settings_get_str('urlcheck_keywords'));
	my $witem = Irssi::window_item_find($target);
	foreach my $url (@urls) {
		my $content = get $url;
		return unless defined $content;
		my $matches;
		foreach my $kw (@keywords) {
			if ($content =~ /$kw/i) {
				if (defined $matches) {
					$matches .= ', '.$kw;
				} else {
					$matches = $kw;
				}
			}
		}
		$witem->print("%R>>%n [$matches]", MSGLEVEL_CLIENTCRAP);
	}
}

sub urlcheck_public
{
	my ($server, $data, $nick, $mask, $target) = @_;
	check_and_annotate($target, $data)
}

sub urlcheck_private
{
	my ($server, $data, $nick, $address) = @_;
	check_and_annotate($server->{'nick'}, $data);
}

sub urlcheck_own_public
{
	my ($server, $data, $target) = @_;
	check_and_annotate($target, $data);
}

Irssi::signal_add_last('message public', 'urlcheck_public');
Irssi::signal_add_last('message private', 'urlcheck_private');
Irssi::signal_add_last('message own_public', 'urlcheck_own_public');

Irssi::print("urlcheck $VERSION ready");

