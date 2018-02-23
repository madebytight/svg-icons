Prepare SVG icons for use on the web. 

# Usage

Place SVG files in `input/` and run `bundle exec rake`.

## Commands

| Command                  | Desctiption                                   |
|:-------------------------|:----------------------------------------------|
| `bundle exec rake`       | Clean up svgs and prints them to the console. |
| `bundle exec rake js`    | Clean up svgs and save JS to output folder.   |
| `bundle exec rake clean` | Removes input and output files.               |

# Prerequisites

- Install svgo with `npm install svgo --global`.
- Install ruby dependencies with `bundle install`.
