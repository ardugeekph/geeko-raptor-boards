# Geeko Raptor Boards

Arduino Boards Manager distribution for the **Geeko Raptor (Intermediate)** line follower board.

## Board Installation (Boards Manager)

### Prerequisites

1. Install the [Arduino IDE](https://www.arduino.cc/en/software/).
2. Install the official **Arduino AVR Boards** package from Boards Manager. The Geeko platform uses the standard Arduino AVR core and tools.

### Install via Boards Manager

1. Open **File → Preferences → Additional Boards Manager URLs**.
2. Add this URL:

   ```
   https://raw.githubusercontent.com/ardugeekph/geeko-raptor-boards/main/package/package_geeko_line_follower_index.json
   ```

3. Open **Tools → Board → Boards Manager**, search for `Geeko`, and install **Geeko AVR Boards** by ArduGeek PH.
4. Select **Tools → Board → Geeko AVR Boards → Geeko Raptor (Intermediate)**.

### Verify installation

After installation you should see:

- **Geeko AVR Boards** in Boards Manager
- **Geeko Raptor (Intermediate)** under **Tools → Board → Geeko AVR Boards**

## Alternative: Manual Installation

If you prefer not to use Boards Manager, copy the hardware folder manually:

1. Download or clone this repository.
2. Copy the `hardware` folder to your Arduino sketchbook directory:

   ```
   Documents/Arduino/hardware/
   ```

   The result should look like:

   ```
   Documents/Arduino/hardware/geeko_line_follower/avr/
   ```

3. Restart the Arduino IDE.
4. Select **Tools → Board → Geeko AVR Boards → Geeko Raptor (Intermediate)**.

The companion **geeko_raptor** sketch library lives in the main [geeko-raptor](https://github.com/ardugeekph/geeko-raptor) repository.

## Documentation

Full kit documentation:

https://booming-fedora-c15.notion.site/Geeko-Raptor-Line-Follower-Robot-Learning-Kit-26d1d54c028c814a9a83fe6d5c4e300d

## Maintainer releases

See [`package/RELEASE.md`](package/RELEASE.md) for the release checklist and build script usage.
