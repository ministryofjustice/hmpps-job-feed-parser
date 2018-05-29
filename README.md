# Fetching jobs from WCN

## RSS

WCN publish an RSS feed of all jobs, at;

```
https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-2/candidate/jobboard/vacancy/3/feed
```

In theory, you can add `?ftq=prison+officer` to filter this, but if you do that then
you only get the first 50.

So, this code leaves off the `ftq` parameter, and filters the list after retrieval.

The RSS feed is very basic, and the code here which parses it is very fragile, depending on
the exact format and string labels that WCN use. e.g;

```
<entry xml:base="https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/9908-201706-Prison-Officer-HMP-YOI-Downview/en-GB">
  <id>https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/9908-201706-Prison-Officer-HMP-YOI-Downview/en-GB</id>
  <link rel="alternate" href="https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/9908-201706-Prison-Officer-HMP-YOI-Downview/en-GB" type="text/html"/>
  <title>201706: Prison Officer - HMP/YOI Downview</title>
  <updated>2017-05-31T23:00:00Z</updated>
  <published>2017-05-31T23:00:00Z</published>
  <content type="xhtml">
    <div xmlns="http://www.w3.org/1999/xhtml">Vacancy Title:201706: Prison Officer - HMP/YOI Downview<br/>
    Vacancy Id:9908<br/>
    Role Type:Operational Delivery,Prison Officer<br/>
    Salary:£31,453<br/>
    Location:Sutton <br/>
    Closing Date:7 Jul 2017 23:55 BST<br/>
    </div>
  </content>
</entry>
```

## HTML

The corresponding HTML page is here;

```
https://justicejobs.tal.net/vx/lang-en-GB/mobile-0/appcentre-1/brand-2/xf-a5f8e63220f3/candidate/jobboard/vacancy/3/adv/?ftq=prison+officer
```

## Output schema

Structured job data will be output in the following format:

```json
{
  "title": "201710: Prison Officer - HMP/YOI Isle of Wight",
  "role": "Prison Officer",
  "salary": "£22,396",
  "closing_date": "31/10/2017",
  "prison_name": "HMP/YOI Isle of Wight",
  "prison_location": {
    "lat": 50.713196,
    "lng": -1.3076464,
    "town": "Newport"
  },
  "url": "https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/13634-201710-Prison-Officer-HMP-YOI-Isle-of-Wight/en-GB"
}
```

| Field name | Type | Description |
| ---------- | ---- | ----------- |
| `title`    | String | The vacancy title. |
| `role`     | String | The job role of this vacancy. This will always be 'Prison Officer', since that's the only role this script currently retrieves data for. |
| `salary`   | String | The vacancy salary. This is untouched and passed through as a string. Do not attempt to treat this as a number, as it's unknown whether this always follows a predictable format. |
| `closing_date` | Date (DD/MM/YYYY) | The vacancy closing date in DD/MM/YYYY format. |
| `prison_name` | String | Name of the prison in which this vacancy exists. |
| `prison_location` | Object | Object with sub-fields: |
| `prison_location.lat` | Float | Latitude of the prison. |
| `prison_location.lng` | Float | Longitude of the prison. |
| `prison_location.town` | String | Name of the town in which the prison exists. |
| `url` | String | URL of the vacancy details page. |

### Vacancies in multiple prisons

Vacancies in multiple prisons (e.g. cluster vacancies), one entry will be output for each prison.

This will result in duplicate vacancy data being surfaced – once for each prison.

If required, vacancies can be re-grouped by matching them against the URL. This will be unique per vacancy.

### JSON file in S3

This structured vacancy data is output to a JSON file in an S3 bucket.

This JSON file contains an array of objects following the aforementioned output schema.

## Docker

A `Dockerfile` is included in this project, meaning the application can be compiled into a docker image and run in a container.

The docker image will execute the ruby script `bin/current-vacancies-to-json.rb`.

### Build the docker image

Run the following Terminal command from the main project directory to build the docker image:

```bash
docker build -t hmpps-job-feed-parser .
```

This will build an image based on the official ruby 2.4 image and install required gems. For more details, see `Dockerfile`.

### Run the docker image

Use the following Terminal command to run the docker image:

```bash
docker run hmpps-job-feed-parser
```

The container will execute the ruby script `bin/current-vacancies-to-json.rb` and then quit.

Prison data which did not match with any prison is added to vacancies-bad-data.json file in s3. The data in json file is surfaced to business users using unidentified-prison-names.html file.

This file needs to be manually copied to S3 bucket "hmpps-feed-parser".

## Slack Notification

The feed uses a Slack webhook for feedback this relies upon two Environment variables:

SLACK_URL for the full url of the webhook.

SLACK_AVATAR for the icon associated with the message sender (to readily indicate status amongst other feeds).

## Geckoboard Updates

We use a Geckoboard for real-time updates on the site. The feed publishes stats of vacancies and the Date/Time at which it has run. To set this up use the environment variable:

DASHBOARD_KEY this allows the Geckoboard to receive data for the dataset widget. 
