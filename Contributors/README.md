#  Getting Started with the Codebase

SMHS Schedule has a rather simple codebase, following the commonly known SwiftUI MVVM (Model View View Model) design pattern where each view has 1 view file, multiple SwiftUI component view files, multiple model files, and 1 view model file. 

The diagram below gives a high level overview of the software architecture:

<p align="center">
    <img src="../Assets/Architecture Diagram.png" style="display: block; margin: auto;"/>
</p>

## Fetching the Data

The first big question is how does SMHS Schedule work. Where do we get our schedule information or data? For the schedle information (campus news please read following section), the answers lies in the calendar feed, or `.ICS` iCalendar files. On the [bell schedule](https://www.smhs.org/other/parents/virtual-bell-schedule) page of the SMHS's website, there is a button that gives the calendar feed.

iCalendar file is a standard media type for exchanging scheduling information, and this means SMHS Schedule can simply periodically download the `.ICS` file as a raw text, to get updated schedule information. 

In fact, you can click on this [link](https://www.smhs.org/calendar/calendar_379.ics) to download the `.ICS` file and right click to open it as a text file on your computer. This resembles the raw text that SMHS Schdeule will parse.

## Scraping SMHS Website

### XML File
For fetching the campus news, SMHS Schedule uses a 2 step process. First, the app uses networking functions to download an XML file from SMHS website. This XML file is structured similarly to a `json` file while using HTML style tag syntax, and contains important meta information for news article entries. For each of the new article entry contained in the XML file, it records the title, author, date, image url, and article url. The app will parse and extract those information into models for further logics and rendering into SwiftUI views.

### Web Scraping
However, the XML file does not contain any body text, so the 2nd step is to use the article url provided, and scrap the SMHS news website. This scraping feature still has lots of room for improvement, because the SMHS website structure is rather random for different news entries. Although the body content is usually contained in a specific `<div>`, the content inside this `<div>` can include text, images, videos, even tables. Thus when finding all text recursively in the `<div>`, the app HTML parser will sometimes get garbage text that is not part of the article, but instead image captions, website labels.etc. 

## InClass™ View Computations
The most complex and lengthy part of the code base, excluding the networking and ICS parsing methods, is probabaly the code for InClass™. InClass™ is another name for a visualized countdown of time left for the current class period. In order to compute this information, SMHS Schedule takes advantage of built in classes such as `Date`, `DateFormatter`, and `DateComponents`.

First, the app parses the schedule block text, extracting individual periods and their respective start/end times. This can get a little complicated for periods revolving around nutrition due to 1st and 2nd nutrition periods with overlapping times.

Second, the app figures out which period the user is in by getting the current device time and trying to fnd which period's start and end time does the current time falls into. It does so by first "normalizing" the current device time. When calling `Date()` in Swift, it will return a `Date` object reflecting the current device time and date. The app then "normalizes" the date by keeping the time while manually setting the date to 2001-01-01. All the periods are also set to this date because here we only care about time, not the date.

Sometimes with nutrition period or nutrition revolving periods, there can be 2 possibilities depending on 1st or 2nd lunch. THus, the app offers a segmented style control to toggle bewteen 1st nutrition schedule and 2nd nutrition schedule.
