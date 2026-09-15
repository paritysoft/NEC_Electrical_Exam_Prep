# Responsive NEC design

The app uses navy headers and navigation, a pale background, white cards, and consistent text sizes. NEC content, store product IDs, and free access (five Easy random questions per attempt, repeatable) are retained.

- Below 700 logical pixels: bottom navigation and a single-column study layout.
- From 700 pixels: a compact navigation rail and adaptive grids.
- From 1000 pixels: a labeled sidebar. Grids use available content width, with up to four columns.
- Quiz content is limited to 980 pixels; secondary pages to 1200 pixels; the home workspace to 1280 pixels.
- Content scrolls when needed. Text respects the operating system's accessibility scaling. Buttons have touch-friendly targets and native keyboard/mouse interaction.

Home, topic selection, mock tests, random/daily/timed quizzes, results, answer review, study guides, records, analysis, settings, legal pages, and onboarding use the shared presentation system. Quiz result persistence runs once when entering results, rather than again on window resize.

## Verification

25 automated tests cover startup, viewport layouts, large text, navigation, purchase/restore behavior with a simulated store, and free quiz rules. The macOS debug build succeeds. Phone and desktop rendered previews are in `build/design-previews`; they use sample questions and counts, not the live question database.

## Platform limits

Windows layout is implemented and viewport-tested, but no Windows executable was built on this Mac. The existing `sqflite_sqlcipher` plugin supports Android, iOS, and macOS, not Windows. Windows requires an encrypted database adapter and a Windows purchase integration before full feature support can be claimed. Payment access is not bypassed on Windows. Firebase configuration is present for the mobile apps; desktop startup does not initialize an unconfigured Firebase app. Native store transactions and notification delivery were not device-tested during this design work.
