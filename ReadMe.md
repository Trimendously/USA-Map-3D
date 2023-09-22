# USA 3D Map

The goal of this application is to allow users to visualize data that is divided up by USA States.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Context](#context)
- [Future](#future)
- [Contributing](#contributing)
- [License](#license)

## Installation

Instructions for installing the project:

Install latest version of Matlab


``` bash
$ usa
```

The required add-ons to run this project are the Financial Toolbox and the Mapping Toolbox
## Usage
After running the main 'usa.m' file a figure will pop up allowing the users to get a 3d visualization fo the data.

The users can drag, rotate,etc. to get a better feel for the data in a visdual representation.


## Future
The program takes the gelocation data of the USA states and converts them to cartesian coordinates in order to plot them on an xyz plot.

As you can see the Alaska plot has some major inconsistencies, I have tried using alternitvae conic projections such as albers,mercator,equirectangular,etc. all to no avail. As of now I will eventually manually edit the plot to try and reduce as many incosistencies as possible.

- [] Fix Alaska
- [] Add a degree of transparancy (to 3D aspects) to allow base map to be more visible
- [] Clean up the legend
- [] Add start/end date buttons to allow the user to easily change the range of data visualized


## Contributing
Anyone is welcome to contribute to this project.
I just wanted to test my mapping visualizations in Matlab so I came up with this project.

## License
This project is licensed under the MIT License - see the LICENSE file for details.
