# aj-top-25-poll

![Maintained Label](https://img.shields.io/badge/Maintained-No-red?style=for-the-badge)
![Deprecated Label](https://img.shields.io/badge/Deprecated-Yes-lightgray?style=for-the-badge)
![Archived Label](https://img.shields.io/badge/Archived-Yes-lightgray?style=for-the-badge)

### Overview

View the latest AJ Top 25 Poll at [poll.jarombek.io](https://poll.jarombek.io).

The AJ Top 25 Poll is a quarterly survey that aggregates feedback from software engineers, public ranking systems, 
and AI platforms. Drawing inspiration from the renowned [AP Top 25](https://apnews.com/hub/ap-top-25-college-basketball-poll) 
polls for college football and basketball, the AJ Poll offers valuable insights into the popularity of programming 
languages, engineering components, and software companies.

### Commands

**Deploy a new version of the UI to S3**

```bash
cd ui/aj-poll
npm run build

cd -
source ./utils/s3-upload.sh ./ui/aj-poll/dist
```

### Directories

| Directory | Description                                   |
|-----------|-----------------------------------------------|
| `infra`   | Terraform infrastructure for the application. |
| `ui`      | Web UI for the AJ Top 25 Poll.                |

**[v0.1.0](https://github.com/AJarombek/aj-top-25-poll/tree/v0.1.0) - Website MVP**

> Release Date: March 1st, 2024

Website MVP with a responsive design.  Displays the following pages:

* Programming Language Poll
* Engineering Component Poll
* Engineering Company Poll
* About
