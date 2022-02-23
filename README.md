Prepare SVG icons for use on the web. 

## Commands

### `js`

Clean up SVGs and save JS to output folder.

| Environment | Command                                                                                            |
|:------------|:---------------------------------------------------------------------------------------------------|
| Docker      | `docker run --rm -v [INPUT PATH]:/app/input -v [OUTPUT PATH]:/app/output madebytight/svg-icons js` |
| Ruby        | `bundle exec rake js`                                                                              |

### `json`

Clean up SVGs and save JSON to output folder.

| Environment | Command                                                                                              |
|:------------|:-----------------------------------------------------------------------------------------------------|
| Docker      | `docker run --rm -v [INPUT PATH]:/app/input -v [OUTPUT PATH]:/app/output madebytight/svg-icons json` |
| Ruby        | `bundle exec rake json`                                                                              |

### `preview`

Create a preview in an HTML file saved to the output folder.

| Environment | Command                                                                                                 |
|:------------|:--------------------------------------------------------------------------------------------------------|
| Docker      | `docker run --rm -v [INPUT PATH]:/app/input -v [OUTPUT PATH]:/app/output madebytight/svg-icons preview` |
| Ruby        | `bundle exec rake preview`                                                                              |

----

### Prerequisites

Not needed by Docker.

- Install svgo with `npm install svgo --global`.
- Install ruby dependencies with `bundle install`.
