# URlTitles
# a script that fetches URL titles and displays them
use strict;
use Irssi;
use LWP::Simple;

use vars qw($VERSION %IRSSI);

$VERSION = "0.1";
%IRSSI = {
  authors => 'Ilkka Laukkanen',
  contact => 'ilkka.s.laukkanen@gmail.com',
  name => 'urltitles',
  description => 'Output URL titles after messages that contain URLs',
  license => 'GPLv3',
  url => 'http://www.example.com/not-yet'
};

Irssi::settings_add_bool('urltitles', 'urltitles_active', 1);

sub urltitles_annotate
{
  my ($target, $data) = @_;
  return unless Irssi::settings_get_bool('urltitles_active');
  my @urls;
  while ($data =~ m%(http[s]?://\S+)%gsi) {
    push @urls, $1;
  }
  return unless @urls;
  my $win = Irssi::window_item_find($target);
  foreach my $url (@urls) {
    my $content = get $url;
    return unless defined $content;
    while ($content =~ m/<title(?:\s+.*)?>\s*(.+?)\s*<\/title>/gsi) {
      $win->print("%R>>%n ".sprintf("%.30s", $url)." : $1", MSGLEVEL_CLIENTCRAP);
    }
  }
}

sub urltitles_private
{
  my ($server, $data, $nick, $address) = @_;
  urltitles_annotate($server->{'nick'}, $data);
}

sub urltitles_public
{
  my ($server, $data, $nick, $mask, $target) = @_;
  urltitles_annotate($target, $data);
}

sub urltitles_own_public
{
  my ($server, $data, $target) = @_;
  urltitles_annotate($target, $data);
}

Irssi::signal_add_last('message public', 'urltitles_public');
Irssi::signal_add_last('message private', 'urltitles_private');
Irssi::signal_add_last('message own_public', 'urltitles_own_public');

Irssi::print("urltitles v$VERSION ready");

