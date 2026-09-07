# Release Checklist

Use this checklist when publishing a new version of **Geeko AVR Boards** to Arduino Boards Manager.

## Before release

1. Update the platform version in [`hardware/geeko_line_follower/avr/platform.txt`](../hardware/geeko_line_follower/avr/platform.txt) if it changed.
2. Confirm [`hardware/geeko_line_follower/avr/boards.txt`](../hardware/geeko_line_follower/avr/boards.txt) still matches the board names listed in the package index.

## Build and publish

1. Run the build script from the repo root:

   ```bash
   ./scripts/build-hardware-package.sh <version>
   ```

   Example for v1.0.0:

   ```bash
   ./scripts/build-hardware-package.sh 1.0.0
   ```

   The zip must contain `boards.txt`, `platform.txt`, and supporting folders at the **archive root**. Do not wrap them in `hardware/geeko_line_follower/avr/`; that layout is for manual sketchbook installs only.

2. Upload the zip to the GitHub Release for `v<version>`:

   ```bash
   gh release upload "v<version>" "dist/geeko_line_follower-avr-<version>.zip" --clobber
   ```

   For a first release:

   ```bash
   gh release create "v<version>" "dist/geeko_line_follower-avr-<version>.zip" \
     --title "Geeko AVR Boards v<version>"
   ```

3. Copy the script output (`checksum`, `size`, `url`) into [`package/package_geeko_line_follower_index.json`](package_geeko_line_follower_index.json):
   - Add a new platform entry for the version, or update the existing one.
   - Keep older platform entries if you want Boards Manager to offer upgrades from previous versions.
   - Leave `toolsDependencies` empty when the platform uses `arduino:arduino` and `arduino:avrdude` from the official Arduino AVR Boards package.

4. Commit the updated package index and push to `main`.

## Verify in Arduino IDE

1. Install **Arduino AVR Boards** from Boards Manager (required toolchain dependency).
2. Add the package index URL in **File → Preferences → Additional Boards Manager URLs**:

   ```
   https://raw.githubusercontent.com/ardugeekph/geeko-raptor-boards/refs/heads/main/package/package_geeko_line_follower_index.json
   ```

3. Open **Tools → Board → Boards Manager**, search for `Geeko`, and install **Geeko AVR Boards**.
4. Confirm files landed here (macOS):

   ```
   ~/Library/Arduino15/packages/geeko_line_follower/hardware/avr/<version>/boards.txt
   ```

5. Select **Tools → Board → Geeko AVR Boards → Geeko Raptor (Intermediate)**.
6. Compile and upload a test sketch over serial at 115200 baud.

## v1.0.0 first release notes

For the initial release, publish the GitHub Release asset first, then fill in `checksum` and `size` in the package index before merging to `main`. Boards Manager reads the index from the raw GitHub URL on `main`, so the index must reference a release asset that already exists.
