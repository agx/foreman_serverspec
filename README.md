# ForemanServerspec

Plugin to store [serverspec][] reports in [the Foreman][]. This is not even alpha
quality software so send patches.

## Installation

See [How_to_Install_a_Plugin](http://projects.theforeman.org/projects/foreman/wiki/How_to_Install_a_Plugin)
for how to install Foreman plugins

## Usage

After installing the plugin have a look at extras/. The send_report there knows
how to run serverspec and then forward the report:

    ./send_report <fqdn>

## Features

* Store, display search and delete reports

## TODO

* Proper roles and authentication
* Dashboard
* Smart Proxy support to run the specs

## Contributing

Fork and send a Pull Request. Thanks!

## Copyright

Copyright (c) 2016 Guido Günther

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

[serverspec]: http://serverspec.org/
[the Foreman]: https://theforeman.org/
