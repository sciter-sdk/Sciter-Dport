// Copyright 2015 Ramon F. Mendes
// 
// This file is part of sciter-dport.
// 
// sciter-dport is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// sciter-dport is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License along with sciter-dport. If not, see http://www.gnu.org/licenses/.

module sciter.tiscript;
import sciter.sciter_x_types;


struct tiscript_VM;
alias tiscript_value = UINT64;
alias HVM = tiscript_VM*;
//alias value = tiscript_value;// do not use these, instead use the original names
//alias VM = tiscript_VM;


struct tiscript_pvalue
{
	tiscript_value	val;
	tiscript_VM*	vm;
	void*			d1;
	void*			d2;
}


// to be completed ..
struct tiscript_native_interface;