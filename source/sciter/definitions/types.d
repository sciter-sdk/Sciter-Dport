// Copyright 2015 Ramon F. Mendes
// 
// This file is part of sciter-dport.
// 
// sciter-dport is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// sciter-dport is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License along with Foobar. If not, see http://www.gnu.org/licenses/.

module sciter.definitions.types;

import std.typecons;
version(Linux)
{
	public import sciter.sciter_x_types;
}


alias HELEMENT = Typedef!(size_t, 0, "helement");
alias HNODE = Typedef!(size_t, 0, "hnode");
alias HRANGE = Typedef!(size_t, 0, "hrange");
alias HSARCHIVE = Typedef!(size_t, 0, "hsarchive");