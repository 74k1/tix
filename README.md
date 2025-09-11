<div align="right">
    <img align="left" src="/.github/assets/tix_colored.png" width="300px"/>
    <br>
    <h3><samp>(t)im's n(ix) flake </samp>❄️</h3>
    <a href="#"><img src="https://img.shields.io/github/repo-size/74k1/tix?color=7089FF&labelColor=323246&style=for-the-badge"></img></a>
    <a href="https://github.com/74k1/tix/stargazers"><img src="https://img.shields.io/github/stars/74k1/tix?color=7089FF&labelColor=323246&style=for-the-badge"></img></a>
    <a href="LICENSE"><img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=MIT&logoColor=7089FF&colorA=323246&colorB=7089FF"/></a>
</div>

<br/>
<br/>
<br/>
<br/>

<div>
    <h2>About</h2>
    <p>
        My very own nix config that I use on a daily basis.
        <br>
        It's always in a continuing circle of improvements. Expect radical changes.
        <br>
        Every single config is set for <ins>my</ins> own preference and is therefore heavily opinionated.
        If you should find issues in my current config, feel free to contact me or create an <a href="https://github.com/74k1/tix/issues">Issue</a> directly. Mistakes are only a helpful learning oportunity.
        <br>
        If you found this repository helpful, I'd very much appreciate a star! ⭐ And if you're using some snippets in your own config, I'd also appreciate some credits, but it's nothing mandatory ofcourse. :)
    </p>
</div>

> [!WARNING]
> This is _hardcoded_ to my daily workflow. Don't just swap out the usernames, hostnames, and hardware configs and expect it to work.\
> Feel free to use it as a reference, not a template. ^-^
> 
> <sub>Psst: My [DMs are open](https://74k1.sh/contact), should you require help. I'm happy to share. :)</sub>

<h2> Screenshots </h2>

| <img src="/.github/assets/1.png"> | <img src="/.github/assets/2.png"> |
| :-------------------------------: | :-------------------------------: |
| <img src="/.github/assets/2.png"> | <img src="/.github/assets/1.png"> |

<div>
    <h2>Details</h2>
    <ul>
        <li><strong>Window Manager</strong> • <a href="https://github.com/YaLTeR/niri/">Niri</a> Scrollable WM!</li>
        <li><strong>Shell</strong> • <a href="https://github.com/fish-shell/fish-shell">fish</a> The user-friendly command line shell</li>
        <li><strong>Terminal</strong> • <a href="https://github.com/ghostty-org/ghostty">Ghostty</a> a fast, feature-rich and _native_ terminal emulator</li>
        <li><strong>Notification Daemon & Panel</strong> • <a href="https://github.com/ErikReider/SwayNotificationCenter">SwayNC</a> A simple GTK based notification daemon.</li>
        <li><strong>Launcher</strong> • <a href="https://github.com/Skxxtz/sherlock-gpui">Sherlock-gpui</a> A versatile application/command launcher for wayland.</li>
        <li><strong>Editor of Choice</strong> • <a href="https://github.com/neovim/neovim">Neovim</a> ❤️</li>
        <li><strong>Overall Theme</strong> • <a href="https://github.com/snqn">Sine qua non</a> My very own Theme!</li>
    </ul>
</div>

<div>
    <h3>Hosts</h3>
    <table>
        <tr>
            <th></th>
            <th>Hostname</th>
            <th>Type</th>
            <th>Purpose</th>
        </tr>
        <tr>
            <td><a href="hosts/nixos/wired"><img alt="desktop" src="https://user-images.githubusercontent.com/49000471/258223152-6c644f95-2fd7-4db3-b266-b387a95f150c.png" style="height: 1em"></img></a></td>
            <td>wired</td>
            <td>GPD Pocket 4<br><sub>AMD Ryzen AI 9 HX 370</sub></td>
            <td>General purpose usage.</td>
        </tr>
        <tr>
            <td><a href="hosts/nixos/eiri"><img alt="server" src="https://user-images.githubusercontent.com/49000471/258223152-6c644f95-2fd7-4db3-b266-b387a95f150c.png" style="height: 1em"></img></a></td>
            <td>eiri</td>
            <td>Custom Server<br><sub>AMD Ryzen 9 3900x<br>Intel Arc A380</sub></td>
            <td>Just for fun. Homelab stuff. :)</td>
        </tr>
        <tr>
            <td><a href="hosts/nixos/eiri"><img alt="server" src="https://user-images.githubusercontent.com/49000471/258223152-6c644f95-2fd7-4db3-b266-b387a95f150c.png" style="height: 1em"></img></a></td>
            <td>arisu</td>
            <td>MacBook as a Server (MaaS)<br><sub>Apple M3 Max</sub></td>
            <td>Just for fun & when I need apps, that aren't on Linux. :)</td>
        </tr>
        <tr>
            <td><a href="hosts/nixos/knights"><img alt="server" src="https://user-images.githubusercontent.com/49000471/258223152-6c644f95-2fd7-4db3-b266-b387a95f150c.png" style="height: 1em"></img></a></td>
            <td>knights</td>
            <td>VPS<br><sub><a href="https://hetzner.cloud/">from Hetzner</a> ❤️</sub></td>
            <td>Proxy / Just for fun.</td>
        </tr>
        <tr>
            <td><a href="hosts/nixos/duvet"><img alt="server" src="https://user-images.githubusercontent.com/49000471/258223152-6c644f95-2fd7-4db3-b266-b387a95f150c.png" style="height: 1em"></img></a></td>
            <td>duvet</td>
            <td>VPS<br><sub><a href="https://hetzner.cloud/">from Hetzner</a> ❤️</sub></td>
            <td>Static Website Hosting</td>
        </tr>
    </table>
</div>

## Flake Structure

```
/
├ hosts/           # all host-specific configurations
│ ├ darwin/
│ ╰ nixos/
├ modules/
│ ├ darwin/        # darwin-wide module configurations
│ ├ flake/         # flake specific configurations
│ ├ home-manager/  # home-manager wide configurations
│ ╰ nixos/         # nixos wide configurations
├ secrets/         # secrets, using agenix-rekey
│ ├ rekeyed/
│ │ ╰ {hosts}/
│ ╰ *.age
├ flake.nix
├ flake.lock
├ README.md        # <- you are here!
╰ LICENSE
```

## Packages

All of my own Packages & Modules are under <a href="https://github.com/74k1/tixpkgs">tixpkgs</a>. Feel free to snoop around and submit PRs / Issues. Contributions are always welcome. :)


## Special Thanks to

| Credit | Reason |
| ---: | --- |
| [Nix & NixOS](https://github.com/NixOS) | being the most goated linux distro. :light_blue_heart: |
| <img src="https://user-images.githubusercontent.com/49000471/258223152-6c644f95-2fd7-4db3-b266-b387a95f150c.png" height="16px" width="16px"/> [reo101](https://github.com/reo101) | for being **the one and only** that introduced me to nix and helping me out a ton. :) |
| [pabloagn](https://github.com/pabloagn/) | Their [overall vibe in the config](https://github.com/pabloagn/rhodium/) inspired me a lot. |
| [linuxmobile](https://github.com/linuxmobile/) | Their [Niri config](https://github.com/linuxmobile/kaku) served as a great reference point. |
