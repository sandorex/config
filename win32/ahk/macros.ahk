; requires nircmd from https://www.nirsoft.net/utils/nircmd2.html

DEVICE_SPEAKERS := '"Speakers (Monitor)"'
DEVICE_HEADPHONES := '"Headphones"'

sound_device_toggle := false

; this is only a demo i did not yet finish it
X:: {
    global sound_device_toggle

    if sound_device_toggle {
        RunWait 'nircmdc.exe setdefaultsounddevice ' DEVICE_HEADPHONES
        sound_device_toggle := false
    } else {
        RunWait 'nircmdc.exe setdefaultsounddevice ' DEVICE_SPEAKERS
        sound_device_toggle := true
    }

    SoundBeep 200
}

