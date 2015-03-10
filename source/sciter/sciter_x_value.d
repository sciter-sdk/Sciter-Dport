// Copyright 2015 Ramon F. Mendes
// 
// This file is part of sciter-dport.
// 
// sciter-dport is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// sciter-dport is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License along with Foobar. If not, see http://www.gnu.org/licenses/.

module sciter.sciter_x_value;

// Contents:
// sciter-x-value.h		- ported here
// value.h				- ported here the extern declarations, there is no value.di file, its all located here
//
// By importing just this file, SCITER_VALUE is aliased to the basic VALUE
// This port has no json::value, but rather an equivalent 'struct json_value' at 'sciter.sciter_value'

alias VALUE SCITER_VALUE;


import sciter.sciter_x_types;


extern(Windows)
{
	enum VALUE_RESULT
	{
		HV_OK_TRUE = -1,
		HV_OK = 0,
		HV_BAD_PARAMETER = 1,
		HV_INCOMPATIBLE_TYPE = 2
	}

	struct VALUE
	{
		UINT     t;// enum VALUE_TYPE
		UINT     u;
		UINT64   d;
	}

	alias double FLOAT_VALUE;
	alias LPCBYTE LPCBYTES;


	enum VALUE_TYPE : UINT
	{
		T_UNDEFINED = 0,
		T_NULL = 1,
		T_BOOL,
		T_INT,
		T_FLOAT,
		T_STRING,
		T_DATE,     // INT64 - contains a 64-bit value representing the number of 100-nanosecond intervals since January 1, 1601 (UTC), a.k.a. FILETIME on Windows
		T_CURRENCY, // INT64 - 14.4 fixed number. E.g. dollars = int64 / 10000; 
		T_LENGTH,   // length units, value is int or float, units are VALUE_UNIT_TYPE
		T_ARRAY,
		T_MAP,
		T_FUNCTION,
		T_BYTES,      // sequence of bytes - e.g. image data
		T_OBJECT,     // scripting object proxy (TISCRIPT/SCITER)
		T_DOM_OBJECT  // DOM object (CSSS!), use get_object_data to get HELEMENT 
	}

	enum VALUE_UNIT_TYPE
	{
		UT_EM = 1, //height of the element's font. 
		UT_EX = 2, //height of letter 'x' 
		UT_PR = 3, //%
		UT_SP = 4, //%% "springs", a.k.a. flex units
		reserved1 = 5, 
		reserved2 = 6, 
		UT_PX = 7, //pixels
		UT_IN = 8, //inches (1 inch = 2.54 centimeters). 
		UT_CM = 9, //centimeters. 
		UT_MM = 10, //millimeters. 
		UT_PT = 11, //points (1 point = 1/72 inches). 
		UT_PC = 12, //picas (1 pica = 12 points). 
		UT_DIP = 13,
		reserved3 = 14, 
		UT_COLOR = 15, // color in int
		UT_URL   = 16,  // url in string
		UT_SYMBOL = 0xFFFF, // for T_STRINGs designates symbol string ( so called NAME_TOKEN - CSS or JS identifier )
	}

	enum VALUE_UNIT_TYPE_DATE
	{
		DT_HAS_DATE         = 0x01, // date contains date portion
		DT_HAS_TIME         = 0x02, // date contains time portion HH:MM
		DT_HAS_SECONDS      = 0x04, // date contains time and seconds HH:MM:SS
		DT_UTC              = 0x10, // T_DATE is known to be UTC. Otherwise it is local date/time
	}

	enum VALUE_UNIT_TYPE_OBJECT
	{
		UT_OBJECT_ARRAY  = 0,   // type T_OBJECT of type Array
		UT_OBJECT_OBJECT = 1,   // type T_OBJECT of type Object
		UT_OBJECT_CLASS  = 2,   // type T_OBJECT of type Type (class or namespace)
		UT_OBJECT_NATIVE = 3,   // type T_OBJECT of native Type with data slot (LPVOID)
		UT_OBJECT_FUNCTION = 4, // type T_OBJECT of type Function
		UT_OBJECT_ERROR = 5,    // type T_OBJECT of type Error
	}

	// we should NOT impose here enum types in place of UINTs cause the above enum's dont defines all the possible values (mainly 0)
	/+EXTERN_C UINT VALAPI ValueInit( VALUE* pval );
	EXTERN_C UINT VALAPI ValueClear( VALUE* pval );
	EXTERN_C UINT VALAPI ValueCompare( const VALUE* pval1, const VALUE* pval2 );
	EXTERN_C UINT VALAPI ValueCopy( VALUE* pdst, const VALUE* psrc );
	EXTERN_C UINT VALAPI ValueIsolate( VALUE* pdst );
	EXTERN_C UINT VALAPI ValueType( const VALUE* pval, UINT* pType, UINT* pUnits );
	EXTERN_C UINT VALAPI ValueStringData( const VALUE* pval, LPCWSTR* pChars, UINT* pNumChars );
	EXTERN_C UINT VALAPI ValueStringDataSet( VALUE* pval, LPCWSTR chars, UINT numChars, UINT units );
	EXTERN_C UINT VALAPI ValueIntData( const VALUE* pval, INT* pData );
	EXTERN_C UINT VALAPI ValueIntDataSet( VALUE* pval, INT data, UINT type, UINT units );
	EXTERN_C UINT VALAPI ValueInt64Data( const VALUE* pval, INT64* pData );
	EXTERN_C UINT VALAPI ValueInt64DataSet( VALUE* pval, INT64 data, UINT type, UINT units );
	EXTERN_C UINT VALAPI ValueFloatData( const VALUE* pval, FLOAT_VALUE* pData );
	EXTERN_C UINT VALAPI ValueFloatDataSet( VALUE* pval, FLOAT_VALUE data, UINT type, UINT units );
	EXTERN_C UINT VALAPI ValueBinaryData( const VALUE* pval, LPCBYTE* pBytes, UINT* pnBytes );
	EXTERN_C UINT VALAPI ValueBinaryDataSet( VALUE* pval, LPCBYTE pBytes, UINT nBytes, UINT type, UINT units );
	EXTERN_C UINT VALAPI ValueElementsCount( const VALUE* pval, INT* pn);
	EXTERN_C UINT VALAPI ValueNthElementValue( const VALUE* pval, INT n, VALUE* pretval);
	EXTERN_C UINT VALAPI ValueNthElementValueSet( VALUE* pval, INT n, const VALUE* pval_to_set);+/
	alias BOOL function(LPVOID param, const VALUE* pkey, const VALUE* pval) KeyValueCallback;
	/+EXTERN_C UINT VALAPI ValueNthElementKey( const VALUE* pval, INT n, VALUE* pretval);
	EXTERN_C UINT VALAPI ValueEnumElements( VALUE* pval, KeyValueCallback* penum, LPVOID param);
	EXTERN_C UINT VALAPI ValueSetValueToKey( VALUE* pval, const VALUE* pkey, const VALUE* pval_to_set);
	EXTERN_C UINT VALAPI ValueGetValueOfKey( const VALUE* pval, const VALUE* pkey, VALUE* pretval);+/

	enum VALUE_STRING_CVT_TYPE : UINT
	{
		CVT_SIMPLE,        ///< simple conversion of terminal values 
		CVT_JSON_LITERAL,  ///< json literal parsing/emission 
		CVT_JSON_MAP,      ///< json parsing/emission, it parses as if token '{' already recognized
		CVT_XJSON_LITERAL, ///< x-json parsing/emission, date is emitted as ISO8601 date literal, currency is emitted in the form DDDD$CCC
	}

	/+EXTERN_C UINT VALAPI ValueToString( VALUE* pval, /*VALUE_STRING_CVT_TYPE*/ UINT how );
	EXTERN_C UINT VALAPI ValueFromString( VALUE* pval, LPCWSTR str, UINT strLength, /*VALUE_STRING_CVT_TYPE*/ UINT how );
	EXTERN_C UINT VALAPI ValueInvoke( VALUE* pval, VALUE* pthis, UINT argc, const VALUE* argv, VALUE* pretval, LPCWSTR url);
	EXTERN_C UINT VALAPI ValueNativeFunctorSet( VALUE* pval, struct NATIVE_FUNCTOR_VALUE* pnfv);
	EXTERN_C BOOL VALAPI ValueIsNativeFunctor( const VALUE* pval);+/
}
