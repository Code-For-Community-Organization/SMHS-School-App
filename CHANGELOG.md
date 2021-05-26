# Change Log
All notable changes to this project will be documented in this file.
 
The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).



## Current Stable - May 16, 2021
 ### v1.0.0 (920)
The current stable version of SMHS Schedule on App Store.

### Added
- [`COMMIT 2fc1752`](https://github.com/jevonmao/SMHS-Schedule/commit/2fc1752736b00a7390f7662b4bae112c13629d64) Add context menu with bookmark/unbookmark option to news entries
- [`COMMIT 71caef0`](https://github.com/jevonmao/SMHS-Schedule/commit/71caef0007b867dc1ea81c5881bf85128fc9f524) Added bookmarking button to news articles, and a bookmarked entries view
- [`COMMIT 90cec85`](https://github.com/jevonmao/SMHS-Schedule/commit/90cec8521fcc7dafcacbe5cab17cdb8a2e2de4c9) Made information card categories searchable by the search bar
- [`COMMIT 629d0e9`](https://github.com/jevonmao/SMHS-Schedule/commit/629d0e97e88fad6c47520d92d96b910fb29959a2) Fully implemented a search bar that searches for schedule days and news entries
- [`COMMIT 629d0e9`](https://github.com/jevonmao/SMHS-Schedule/commit/629d0e97e88fad6c47520d92d96b910fb29959a2) A new tab view containing helpful information card buttons that links to an in-app web view
- [`COMMIT c139d09`](https://github.com/jevonmao/SMHS-Schedule/commit/c139d09c110c4c05f818382a98d22149a2a7bc8e) Editable class names for each period

### Fixed
- [`COMMIT 81a4508`](https://github.com/jevonmao/SMHS-Schedule/commit/81a450886d4195e1c80078ac9f1f16936c085924) Fixed a UI bug where countdown text can potentially overflow to cover other elements

## [Unreleased] - May 16, 2021

### Added
- [`ISSUE 31`](https://github.com/jevonmao/SMHS-Schedule/issues/31) Add Social Media and school information page with phone #s, directions.
- Redesigned schedule detail view by further parsing schedule text and formatting it into custom view elements
- Progress count down now support "Office Hours" and "1st/2nd Nutrition" text
- Settings and About SMHS view for settings options, acknowledgement, and various statements
- New app icons and app names!
- Today tab's header title will now show the day of the week
- [`ISSUE 34`](https://github.com/jevonmao/SMHS-Schedule/issues/34) App will occationally prompt for in-app review

### Fixed
- [`COMMIT b37c7f0`](https://github.com/jevonmao/SMHS-Schedule/commit/b37c7f0b7f687c705c4182ccd2e3baf4772e7c76) Improved testability of ScheduleViewModel by dependency injection of URL request function
- [`COMMIT 36e6ef0`](https://github.com/jevonmao/SMHS-Schedule/commit/36e6ef083055d289a7781c4ed968d4fbebb77344) Fixed a bug introduced by new features where ScheduleDetailView periods array is empty for single lunch period days
- Fixed a UI bug where search view's information cards stretch unwantedly on smaller devices
- Improved a UI issue where search view's information cards have different vertical & horizontal spacing
- Increased icon size and tappable area for navigation bar buttons
- Fixed an UI bug where today view's schedule cannot be scrolled all the way down

## [1.0.0 (641)] - May 12, 2021

### Features
- Easily glance at the list of all future dates' schedules
- InClass™ countdown displaying time left for current period
- Ring progress view visualization for InClass™
- 1st nutrition (lunch) and 2nd nutrition (lunch) schedules support
- Reading newest campus news updates in a beautiful native reader
- iOS 14 Widgets displaying today's schedule
- Today screen for quickly accessing today's schedule
- Turbo fast app launching and loading
