# USA 3D Map

The goal of this application is to allow users to visualize data that is divided up by USA States.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Context](#context)
- [Problems That Arose](#problems)
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

## Problems
The 'patch' function in MATLAB is a great tool to fill in 2D polygons; however, it has become apparent to me that it is not a great tool to fill in discontinuous polygons.

For several states this ended up being an issue, with Alaska being the most notably visible issue.

To resolve this I eneded up manually dividing up the states that I dubbed 'problem states'.
This meant I manually decided the number of veertices to include in each region and I would then plot the state using patch by individually using patch for each of the defined regions.

## Future
- [ ] Continue getting rid of stray edges from discontinuous land masses


## Contributing
Anyone is welcome to contribute to this project.
I just wanted to test my mapping visualizations in Matlab so I came up with this project.

## License
This project is licensed under the MIT License - see the LICENSE file for details.
