![Lovely forks logo](http://musicallyut.xyz/docs/lovely-forks/logo.png)
## Lovely Forks (Fixed)

_A maintained fork of [musically-ut/lovely-forks](https://github.com/musically-ut/lovely-forks), updated to work with modern GitHub's repo header layout. The original repo-title selector stopped matching after GitHub's Turbo-based layout rewrite, leaving the indicator invisible on most pages; upstream appears to be unmaintained. This fork carries the project forward on a best-effort basis._

<p>[AMO listing — pending publication]</p>
<p>[Chrome Web Store listing — pending publication]</p>
<p>[Greasy Fork listing for the userscript — pending publication]</p>

<p>Once published to the Chrome Web Store, the extension can also be installed on Opera through the <a href="https://addons.opera.com/extensions/details/download-chrome-extension-9/"><img src="https://raw.githubusercontent.com/alrra/browser-logos/master/src/opera/opera_48x48.png" width="18" /> Opera Chrome-extension addon</a>.</p>

----

An addon to help you notice **notable** forks of a GitHub project.

Sometimes on GitHub, projects are abandoned by the original authors and the
development continues on a fork. However, the original repository is seldom
updated to inform newcomers of that fact. I have often wasted effort on making
a pull-request or installing old buggy versions of projects when the community
had already moved to a fork.

To make matters worse, the old projects usually have higher search-engine
traffic and a lot more stars than the forks. This makes the forks even harder
to find. This addon tries to remedy that by adding a subscript under the name
of the repository on the GitHub page of the project with a link to the most
notable fork (i.e. the fork with the most stars and at least one star), if such
a fork exists.

Also, if the fork is _more recent_ than the upstream, a flame icon is shown
next to it. These are called [_flamey forks_](https://github.com/musically-ut/lovely-forks/issues/13) 
as suggested by [Mottie](https://github.com/Mottie).

## Use cases

The [tipsy plugin](https://github.com/jaz303/tipsy) hasn't been updated since
2012 and there is a [community supported
fork](https://github.com/CloCkWeRX/tipsy) which has merged in all the PRs.
However, the alternative only has 27 stars versus the 1,888 stars of the
original project (at the time of writing):

<p align="center">
<img alt="Tipsy plugin" src="https://musicallyut.xyz/docs/lovely-forks/tipsy-fork.png" width="80%" />
</p>

Similarly, the project [slate](https://github.com/jigish/slate) was last
updated in 2013 and has about 5,000 stars. The [currently active
fork](https://github.com/mattr-/slate) only has 185 stars (at the time of
writing):

<p align="center">
<img alt="slate" src="https://musicallyut.xyz/docs/lovely-forks/slate-fork.png" width="80%" />
</p>

In some cases, a new flavour of the project might become visible, like an
internationalized fork ([Semantic-UI-pt-br](https://github.com/Semantic-Org/Semantic-UI-pt-br)
is [Semantic-UI](https://github.com/Semantic-Org/Semantic-UI) in a different
language):

<p align="center">
<img alt="semantic-ui" src="https://musicallyut.xyz/docs/lovely-forks/semantic-fork.png" width="80%" />
</p>

Or provides new features ([vim-fugitive](https://github.com/tpope/vim-fugitive) 
provides git integration for vim, 
[vim-mercenary](https://github.com/jlfwong/vim-mercenary) provides Mercurial
integration):

<p align="center">
<img alt="vim-fugitive" src="https://musicallyut.xyz/docs/lovely-forks/fugitive-fork.png" width="80%" />
</p>

## What's different in this fork

  - **Modern repo-header selector.** The original anchor (`main > div > div:not(.repository-content) > div`) no longer matches GitHub's current DOM. This fork uses `#repo-title-component` and walks one level up — a more stable anchor under GitHub's React/Turbo-rendered header.
  - **Turbo soft-navigation handling.** GitHub now uses Turbo for in-page navigation; the original `pjax:end`-only listener did not fire on Turbo soft-navs, so the indicator vanished after clicking between repos. This fork listens to `pjax:end`, `turbo:load`, and `turbo:render`.
  - **Stale-closure fix.** The init logic used to capture `user`/`repo` at script start, so a soft-nav from `foo/bar` to `baz/qux` would re-render the indicator with the *previous* repo's data. The entry block was refactored to re-parse the URL on every event.
  - **Listener registration is unconditional.** Previously, listeners were only attached if the initial page was a repo page; landing on a profile/settings page first and then navigating to a repo meant the indicator never appeared. Listeners are now registered regardless of the initial path.
  - **Best-effort, not bulletproof.** GitHub's DOM will keep evolving. A fully robust solution would add a `MutationObserver` around `data-turbo-replace` wipes; that's out of scope for this set of fixes. Issues and PRs welcome.

## Development

Please install the following before building the extension:

  - [`web-ext`](https://developer.mozilla.org/en-US/Add-ons/WebExtensions/Getting_started_with_web-ext)
  - [`jq`](https://stedolan.github.io/jq/) **Note:** This is not the `jq` on NPM, which is a server-side `jQuery` replacement.

Clone this fork:

```bash
git clone https://github.com/tretuttle/lovely-forks.git
cd lovely-forks
```

The project is supplied with a `Makefile` which can produce final files for both Firefox and Chrome.

```bash
make chrome
make firefox
```

The build is done by selectively copying parts of the source code to the folder `./.tmp` and then archiving it again using either `zip` (for Chrome) or `web-ext` (for Firefox).
The final archives are kept in the `./build` folder.

### Testing

The [`StandardJS` style checker](https://github.com/standard/standard) is used for setting the style guide in the code.

For testing, the extension can be loaded into Chrome by going to [chrome://extensions](chrome://extensions) and clicking on the <kbd>Load Unpacked Extension</kbd> button.
Then navigate to the `.tmp` folder in the source code root which was created by running `make chrome` and load it. An alternate is to run `make manifest` in the root folder and then load the source code root as the unpacked extension. This will allow for a simpler edit-reload cycle, except while editing `manifest.json.template`.

For Firefox, the easiest way to test the packaged extension would be to download the [unbranded build](https://wiki.mozilla.org/Add-ons/Extension_Signing#Latest_Builds) or the [Developer Edition](https://www.mozilla.org/firefox/developer/) and loading the extension there. Otherwise, one would need to _sign_ the extension via your account on their Addon server. Go to [`about:addons`](about:addons), to the _Extensions_ Tab and click the Gear icon (Settings) on the top right to load the packed extension.

If the browser still complains that the package has not been signed, then go to [`about:config`](about:config) and set `xpinstall.signatures.required` to `false`. Note that this setting only takes effect on the Developer Edition and the Unbranded versions of the browser even though it shows up in `about:config` pages of the release channel versions as well.

### Reporting issues

For bugs and feature requests in **this fork**, use [github.com/tretuttle/lovely-forks/issues](https://github.com/tretuttle/lovely-forks/issues). The upstream issue tracker is no longer actively monitored.

## See Also

 - [useful-forks.github.io](https://github.com/useful-forks/useful-forks.github.io) and [their Chrome extension](https://chrome.google.com/webstore/detail/useful-forks/aflbdmaojedofngiigjpnlabhginodbf).

## Fork maintenance

This fork is maintained by [tretuttle](https://github.com/tretuttle). The original project — including the design, implementation, icons, and the entire feature set described above — is the work of [musically-ut](https://github.com/musically-ut) and the contributors credited below. This fork's role is to keep the extension working as GitHub's frontend evolves; all credit for the project itself belongs upstream.

## Acknowledgements

This project uses icons made by
[Freepik](http://www.flaticon.com/authors/freepik) and 
[Dave Gandy](http://www.flaticon.com/authors/dave-gandy) from
[www.flaticon.com](http://www.flaticon.com) is licensed by 
[CC BY 3.0](http://creativecommons.org/licenses/by/3.0/).

[bfred-it](https://github.com/bfred-it) has contributed to improving the look
and feel of the extension considerably. He also brought the extension from the [dark age into the space age](https://github.com/musically-ut/lovely-forks/pull/38) of JavaScript.

[izuzak](https://github.com/izuzak) from GitHub was instrumental in helping me
with bug fixing and suggesting [compare API](https://developer.github.com/v3/repos/commits/#compare-two-commits) 
for improving the heuristic to determine if a fork is more recent than the upstream
repository.

[yfdyh000](https://github.com/yfdyh000) added a [userscript version](https://greasyfork.org/en/scripts/31469-lovely-forks) and made the switch from Firefox Addon SDK to Web-extensions.

[Jackymancs4](https://github.com/Jackymancs4) fixed [a bug](https://github.com/musically-ut/lovely-forks/issues/40) and re-enabled the settings page.

[olso](https://github.com/olso) added an option to set how many days old the last commit on the current repository should be before the forks are shown.

[Jorgen1040](https://github.com/Jorgen1040) helped fix a bug about multiple "also forked" messages appearing.

[francislavoie](https://github.com/francislavoie) implemented a [repo skip list](https://github.com/musically-ut/lovely-forks/pull/74), to not show forks on specific repos.
