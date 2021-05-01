#  Getting Started with the Codebase

SMHS Schedule has a rather simple codebase, following the commonly known SwiftUI MVVM (Model View View Model) design pattern where each view has 1 view file, multiple SwiftUI component view files, multiple model files, and 1 view model file. 

The diagram below gives a high level overview of the software architecture:

<p align="center">
    <img src="../Assets/ArchitectureDiagram.png" style="display: block; margin: auto;"/>
</p>

## Fetching the Data

The first big question is how does SMHS Schedule work. Where do we get our schedule information or data? The answers lies in the calendar feed, or `.ICS` iCalendar files. On the [bell schedule](https://www.smhs.org/other/parents/virtual-bell-schedule) page of the SMHS's website, there is a button that gives the calendar feed.

iCalendar file is a standard media type for exchanging scheduling information, and this means SMHS Schedule can simply periodically download the `.ICS` file as a raw text, to get updated schedule information. 

In fact, you can click on this [link](https://www.smhs.org/calendar/calendar_379.ics) to download the `.ICS` file and right click to open it as a text file on your computer. This resembles the raw text that SMHS Schdeule will parse.

