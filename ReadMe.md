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

## Context
The program takes the gelocation data(latitude/longitude coordinates) of the USA states and converts them to cartesian coordinates in order to plot them on an xyz plot using the patch function.

To convert the geolocation to cartesian the Lambert conformal conic projection was used. To read more about this go here: [Lambert Conbformal Conic](https://desktop.arcgis.com/en/arcmap/latest/map/projections/lambert-conformal-conic.htm#:~:text=The%20Lambert%20conformal%20conic%20map,west%20orientation%20at%20mid%2Dlatitudes.) 

To give the illusion of 3d-ness each state is plotted on top of on another in the z-axis with an incrementation of 1 unit so that when viewed at certain angles the state appears to be 3 dimensional.

## Future
- [ ] Fix Alaska
- [ ] Add a degree of transparancy (to 3D aspects) to allow base map to be more visible
- [ ] Clean up the legend
- [ ] Add start/end date buttons to allow the user to easily change the range of data visualized


## Contributing
Anyone is welcome to contribute to this project.
I just wanted to test my mapping visualizations in Matlab so I came up with this project.

## License
This project is licensed under the MIT License - see the LICENSE file for details.
