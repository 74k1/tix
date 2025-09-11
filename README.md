<div align="right">
    <img align="left" src="/.github/assets/tix_colored.png" width="300px"/>
    <br>
    <h3><samp>(t)im's n(ix) flake </samp>❄️</h3>
    <a href="#"><img src="https://img.shields.io/github/repo-size/74k1/tix?color=cba6f7&labelColor=303446&style=for-the-badge"></img></a>
    <a href="https://github.com/74k1/tix/stargazers"><img src="https://img.shields.io/github/stars/74k1/tix?color=cba6f7&labelColor=303446&style=for-the-badge"></img></a>
    <a href="LICENSE"><img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=MIT&logoColor=ca9ee6&colorA=313244&colorB=cba6f7"/></a>
    <br>
    <p>TODO: preview<p>
    <!-- <picture> -->
    <!--     <img alt="preview" align="right" width="400px" src="/.github/assets/preview.png"> -->
    <!-- </picture> -->
</div>
<br>
<br>
<br>
<div>
    <ul>
        <li><strong>Window Manager</strong> • <a href="https://github.com/YaLTeR/niri/">Niri</a> Scrollable WM!</li>
        <li><strong>Shell</strong> • <a href="https://github.com/fish-shell/fish-shell">fish</a> The user-friendly command line shell</li>
        <li><strong>Terminal</strong> • <a href="https://github.com/ghostty-org/ghostty">Ghostty</a> a fast, feature-rich and _native_ terminal emulator</li>
        <li><strong>Notification Daemon & Panel</strong> • <a href="https://github.com/ErikReider/SwayNotificationCenter">SwayNC</a> A simple GTK based notification daemon.</li>
        <li><strong>Launcher</strong> • <a href="https://github.com/Skxxtz/sherlock">Sherlock</a> A versatile application/command launcher for wayland.</li>
        <li><strong>TUI File Manager</strong> • <a href="https://github.com/sxyazi/yazi">Yazi</a> Fast terminal file manager.</li>
        <li><strong>Editor of Choice</strong> • <a href="https://github.com/neovim/neovim">Neovim</a> ❤️</li>
        <li><strong>overall Theme</strong> • <a href="https://github.com/74k1/yueye">YuèYè 月夜</a> My very own Theme!</li>
    </ul>
</div>

<h2> Screenshots </h2>

| <img src="/.github/assets/1.png"> | <img src="/.github/assets/2.png"> |
| :-------------------------------: | :-------------------------------: |
| <img src="/.github/assets/3.png"> | <img src="/.github/assets/4.png"> |
| <img src="/.github/assets/5.png"> | <img src="/.github/assets/6.png"> |


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
            <td>Custom Server<br><sub>Ryzen 9 3900x<br>GTX 1080ti</sub></td>
            <td>Just for fun. Homelab stuff. :)</td>
        </tr>
        <tr>
            <td><a href="hosts/nixos/eiri"><img alt="server" src="https://user-images.githubusercontent.com/49000471/258223152-6c644f95-2fd7-4db3-b266-b387a95f150c.png" style="height: 1em"></img></a></td>
            <td>arisu</td>
            <td>MacBook as a Server (MaaS)<br><sub>M3 Max</sub></td>
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
├ hosts/
│ ├ darwin/
│ ╰ nixos/
├ modules/
│ ├ darwin/
│ ├ flake/
│ ├ home-manager/
│ ╰ nixos/
├ secrets/
│ ├ rekeyed/
│ │ ╰ {hosts}/
│ ╰ *.age
├ flake.nix
├ flake.lock
├ README.md
╰ LICENSE
```

## Packages

All of my own Packages are under <a href="https://github.com/74k1/tixpkgs">tixpkgs</a>. Feel free to snoop around and submit PRs / Issues. Contributions are always welcome. :)


## Special Thanks to

| Credit | Reason |
| ---: | --- |
| <img src="https://user-images.githubusercontent.com/49000471/258223152-6c644f95-2fd7-4db3-b266-b387a95f150c.png" height="16px" width="16px"/> [reo101](https://github.com/reo101) | for being **the one and only** that introduced me to nix and helping me out a ton. :) |
| [linuxmobile](https://github.com/linuxmobile/) | Their [Niri config](https://github.com/linuxmobile/kaku) served as a great reference point. |
| [pabloagn](https://github.com/pabloagn/) | Their [overall vibe in the config](https://github.com/pabloagn/rhodium/) inspired me a lot. |
| [Nmoleo](https://gitlab.com/Nmoleo) | Rewrote / packaged their [i3 + dunst indicators](https://gitlab.com/Nmoleo/i3-volume-brightness-indicator) script for Nix in [tixpkgs](https://github.com/74k1/tixpkgs). |
