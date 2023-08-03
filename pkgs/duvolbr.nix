{ libnotify
, light
, playerctl
, pulseaudio
, wget
, writeShellScriptBin
, ...
}:
let
  vol_step="5"; # how much the volume should step up/down on keypress
  bri_step="5"; # how much the brightness should step up/down on keypress
  max_vol="100"; # what the max volume should be
  notif_timeout="1000"; # the timeout of the notification in ms
  download_album_art="true"; # if this should download the album art in a tmp dir
  show_album_art="true"; # if you want to show an album art / local or tmp dir
  show_music_in_vol_indicator="true"; # if you want to show music in the vol indicator
in
writeShellScriptBin "duvolbr" ''
  # uses regex to get volume from pulseaudio
  function get_vol {
    ${pulseaudio}/bin/pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1
  }

  # uses regex to get mute status from pulseaudio
  function get_mute {
    ${pulseaudio}/bin/pactl get-sink-mute @DEFAULT_SINK@ | grep -Po '(?<=Mute: )(yes|no)'
  }

  # uses regex to get brightness from xbacklight
  function get_bri {
    sudo ${light}/bin/light | grep -Po '[0-9]{1,3}' | head -n 1
  }

  # returns a mute icon, volume low icon or a volume high icon depending on the volume
  function get_vol_icon {
    vol=$(get_vol)
    mute=$(get_mute)
    if [ "$vol" -eq 0 ] || [ "$mute" == "yes" ] ; then
      vol_icon=""
    elif [ "$vol" -lt 50 ]; then
      vol_icon=""
    else
      vol_icon=""
    fi
  }

  # always returns same brightness icon
  function get_bri_icon {
    bri_icon=""
  }

  # gets album art :shrug:
  function get_album_art {
    url=$(${playerctl}/bin/playerctl -f "{{mpris:artUrl}}" metadata)
    if [[ $url == "file://"* ]]; then
      album_art="''${url/file:\/\//}"
    elif [[ $url == "http://"* ]] && [[ "${download_album_art}" == "true" ]]; then
      # identify filename from URL
      filename="$(echo $url | sed "s/.*\///")"
      
      # download file to /tmp if it doesn't already exist
      if [ ! -f "/tmp/$filename" ]; then
        ${wget}/bin/wget -O "/tmp/$filename" "$url"
      fi

      album_art="/tmp/$filename"
    ## TODO - the uh, https/http stuff
    elif [[ $url == "https://"* ]] && [[ "${download_album_art}" == "true" ]]; then
      # identify filename from URL
      filename="$(echo $url | sed "s/.*\///")"

      # download file to /tmp if it doesn't already exist
      if [ ! -f "/tmp/$filename" ]; then
        ${wget}/bin/wget -O "/tmp/$filename" "$url"
      fi

      album_art="/tmp/$filename"
    else
      album_art=""
    fi
  }

  # displays a volume notification
  function show_vol_notif {
    vol=$(get_mute)
    get_vol_icon

    if [[ "${show_music_in_vol_indicator}" == "true" ]]; then
      current_song=$(${playerctl}/bin/playerctl -f "{{title}} - {{artist}}" metadata)

      if [[ "${show_album_art}" == "true" ]]; then
        get_album_art
      fi

      ${libnotify}/bin/notify-send -t ${notif_timeout} -h string:x-dunst-stack-tag:volume_notif -h int:value:$vol -i "$album_art" "$vol_icon $vol%" "$current_song"
    else
      ${libnotify}/bin/notify-send -t ${notif_timeout} -h string:x-dunst-stack-tag:volume_notif -h int:value:$vol "$vol_icon $vol%"
    fi
  }

  # display a music notification
  function show_music_notif {
    song_title=$(${playerctl}/bin/playerctl -f "{{title}}" metadata)
    song_artist=$(${playerctl}/bin/playerctl -f "{{artist}}" metadata)
    song_album=$(${playerctl}/bin/playerctl -f "{{album}}" metadata)

    if [[ ${show_album_art} == "true" ]]; then
      get_album_art
    fi

    ${libnotify}/bin/notify-send -t ${notif_timeout} -h string:x-dunst-stack-tag:music_notif -i "$album_art" "$song_title" "$song_artist - $song_album"
  }

  # displays a brightness notification
  function show_bri_notif {
    bri=$(get_bri)
    echo $bri
    get_bri_icon
    ${libnotify}/bin/notify-send -t ${notif_timeout} -h string:x-dunst-stack-tag:bri_notif -h int:value:$bri "$bri_icon $bri%"
  }

  # main function
  # takes user input: "vol_up" "vol_down" "vol_mute" "bri_up" "bri_down" "next_track" "prev_track" "play_pause" "pause"
  case $1 in
    vol_up)
      # unmutes, increases volume and displays notif
      ${pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ 0
      vol=$(get_vol)
      if [ $(( "$vol" + "${vol_step}" )) -gt ${max_vol} ]; then
        ${pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ ${max_vol}%
      else
        ${pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +${vol_step}%
      fi
      show_vol_notif
      ;;

    vol_down)
      # decreases volume and displays notif
      ${pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -${vol_step}%
      show_vol_notif
      ;;

    vol_mute)
      # toggles mute and displays notif
      ${pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle
      show_vol_notif
      ;;

    bri_up)
      # increases brightness and display notif
      sudo ${light}/bin/light -A ${bri_step}
      show_bri_notif
      ;;

    bri_down)
      # decreases brightness and display notif
      sudo ${light}/bin/light -U ${bri_step}
      show_bri_notif
      ;;

    next_track)
      # skips to next song and displays notif
      ${playerctl}/bin/playerctl next
      sleep 0.5 && show_music_notif
      ;;

    prev_track)
      # skips to previous song and displays notif
      ${playerctl}/bin/playerctl previous
      sleep 0.5 && show_music_notif
      ;;

    play_pause)
      # toggles play/pause and displays notif
      ${playerctl}/bin/playerctl play-pause
      show_music_notif
      ;;

    pause)
      # just pauses and displays notif
      ${playerctl}/bin/playerctl pause
      show_music_notif
      ;;
  esac
''
