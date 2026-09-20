# Fonts Directory

This directory contains font files for the Katib application.

## Required Arabic Fonts

1. **Cairo** - Modern Arabic font
   - Cairo-Regular.ttf
   - Cairo-Bold.ttf (weight: 700)
   - Cairo-SemiBold.ttf (weight: 600)
   - Cairo-Light.ttf (weight: 300)

2. **Tajawal** - Clean Arabic font
   - Tajawal-Regular.ttf
   - Tajawal-Bold.ttf (weight: 700)

3. **Noto Naskh Arabic** - Traditional Arabic font
   - NotoNaskhArabic-Regular.ttf

4. **Almarai** - Modern Arabic font
   - Almarai-Regular.ttf
   - Almarai-Bold.ttf (weight: 700)

5. **IBM Plex Sans Arabic** - Professional Arabic font
   - IBMPlexSansArabic-Regular.ttf
   - IBMPlexSansArabic-Bold.ttf (weight: 700)

## Required English Fonts

1. **Roboto** - Default Material font
   - Roboto-Regular.ttf
   - Roboto-Bold.ttf (weight: 700)
   - Roboto-Italic.ttf (style: italic)

2. **Open Sans** - Clean sans-serif font
   - OpenSans-Regular.ttf
   - OpenSans-Bold.ttf (weight: 700)

## Font Licenses

All fonts used must have licenses that allow:
- Free use in applications
- Redistribution
- Embedding in apps

Recommended sources:
- Google Fonts (https://fonts.google.com/)
- Apache licensed fonts
- SIL Open Font License (OFL) fonts

## How to Add Fonts

1. Download the font files from a trusted source
2. Place them in this directory
3. Update the `pubspec.yaml` file with the font configurations
4. Run `flutter pub get` to update dependencies

## Current Status

⚠️ **Font files are NOT included in this repository**

To complete the setup, you need to:
1. Download the font files listed above
2. Place them in this directory
3. Commit and push the changes

## Notes

- Font files can be large (100KB - 500KB each)
- Consider using only the weights/styles you need
- Test fonts on both Android and iOS
- Ensure proper RTL support for Arabic fonts
