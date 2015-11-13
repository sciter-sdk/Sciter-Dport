// Copyright 2015 Ramon F. Mendes
// 
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

module sciter.interop.sciter_x_value;

// Contents:
// sciter-x-value.h		- ported here
// value.h				- ported here the extern declarations, there is no value.di file, its all located here
//
// This port has no json::value, but rather an equivalent 'struct json_value' at 'sciter.sciter_value'

import sciter.interop.sciter_x_types;


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
		uint     t;// enum VALUE_TYPE
		uint     u;
		long     d;
	}

	alias double FLOAT_VALUE;
	alias LPCBYTE LPCBYTES;


	enum VALUE_TYPE : uint
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
		UT_OBJECT_NATIVE = 3,   // type T_OBJECT of native Type with data slot (void*)
		UT_OBJECT_FUNCTION = 4, // type T_OBJECT of type Function
		UT_OBJECT_ERROR = 5,    // type T_OBJECT of type Error
	}

	// Sciter or TIScript specific
	enum VALUE_UNIT_TYPE_STRING
	{
		UT_STRING_STRING = 0,		// string
		UT_STRING_ERROR  = 1,		// is an error string
		UT_STRING_SECURE = 2,		// secure string ("wiped" on destroy)
		UT_STRING_SYMBOL = 0xffff	// symbol in tiscript sense
	}

	// Native functor
	alias NATIVE_FUNCTOR_INVOKE = void function(void* tag, uint argc, const VALUE* argv, VALUE* retval);// retval may contain error definition
	alias NATIVE_FUNCTOR_RELEASE = void function(void* tag);


	// we should NOT impose here enum types in place of uints cause the above enum's dont defines all the possible values (mainly 0)
	/+EXTERN_C uint VALAPI ValueInit( VALUE* pval );
	EXTERN_C uint VALAPI ValueClear( VALUE* pval );
	EXTERN_C uint VALAPI ValueCompare( const VALUE* pval1, const VALUE* pval2 );
	EXTERN_C uint VALAPI ValueCopy( VALUE* pdst, const VALUE* psrc );
	EXTERN_C uint VALAPI ValueIsolate( VALUE* pdst );
	EXTERN_C uint VALAPI ValueType( const VALUE* pval, uint* pType, uint* pUnits );
	EXTERN_C uint VALAPI ValueStringData( const VALUE* pval, LPCWSTR* pChars, uint* pNumChars );
	EXTERN_C uint VALAPI ValueStringDataSet( VALUE* pval, LPCWSTR chars, uint numChars, uint units );
	EXTERN_C uint VALAPI ValueIntData( const VALUE* pval, INT* pData );
	EXTERN_C uint VALAPI ValueIntDataSet( VALUE* pval, INT data, uint type, uint units );
	EXTERN_C uint VALAPI ValueInt64Data( const VALUE* pval, INT64* pData );
	EXTERN_C uint VALAPI ValueInt64DataSet( VALUE* pval, INT64 data, uint type, uint units );
	EXTERN_C uint VALAPI ValueFloatData( const VALUE* pval, FLOAT_VALUE* pData );
	EXTERN_C uint VALAPI ValueFloatDataSet( VALUE* pval, FLOAT_VALUE data, uint type, uint units );
	EXTERN_C uint VALAPI ValueBinaryData( const VALUE* pval, LPCBYTE* pBytes, uint* pnBytes );
	EXTERN_C uint VALAPI ValueBinaryDataSet( VALUE* pval, LPCBYTE pBytes, uint nBytes, uint type, uint units );
	EXTERN_C uint VALAPI ValueElementsCount( const VALUE* pval, INT* pn);
	EXTERN_C uint VALAPI ValueNthElementValue( const VALUE* pval, INT n, VALUE* pretval);
	EXTERN_C uint VALAPI ValueNthElementValueSet( VALUE* pval, INT n, const VALUE* pval_to_set);+/
	alias BOOL function(void* param, const VALUE* pkey, const VALUE* pval) KeyValueCallback;
	/+EXTERN_C uint VALAPI ValueNthElementKey( const VALUE* pval, INT n, VALUE* pretval);
	EXTERN_C uint VALAPI ValueEnumElements( VALUE* pval, KeyValueCallback* penum, void* param);
	EXTERN_C uint VALAPI ValueSetValueToKey( VALUE* pval, const VALUE* pkey, const VALUE* pval_to_set);
	EXTERN_C uint VALAPI ValueGetValueOfKey( const VALUE* pval, const VALUE* pkey, VALUE* pretval);+/

	enum VALUE_STRING_CVT_TYPE : uint
	{
		CVT_SIMPLE,        ///< simple conversion of terminal values 
		CVT_JSON_LITERAL,  ///< json literal parsing/emission 
		CVT_JSON_MAP,      ///< json parsing/emission, it parses as if token '{' already recognized
		CVT_XJSON_LITERAL, ///< x-json parsing/emission, date is emitted as ISO8601 date literal, currency is emitted in the form DDDD$CCC
	}

	/+EXTERN_C uint VALAPI ValueToString( VALUE* pval, /*VALUE_STRING_CVT_TYPE*/ uint how );
	EXTERN_C uint VALAPI ValueFromString( VALUE* pval, LPCWSTR str, uint strLength, /*VALUE_STRING_CVT_TYPE*/ uint how );
	EXTERN_C uint VALAPI ValueInvoke( VALUE* pval, VALUE* pthis, uint argc, const VALUE* argv, VALUE* pretval, LPCWSTR url);
	EXTERN_C uint VALAPI ValueNativeFunctorSet( VALUE* pval, struct NATIVE_FUNCTOR_VALUE* pnfv);
	EXTERN_C BOOL VALAPI ValueIsNativeFunctor( const VALUE* pval);+/
}
