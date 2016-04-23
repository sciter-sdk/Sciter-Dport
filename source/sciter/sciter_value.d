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

module sciter.sciter_value;

import std.conv;

import sciter.interop.sciter_x;
import sciter.interop.sciter_x_types;
import sciter.api;
public import sciter.interop.sciter_x_value;


unittest
{
	json_value jv = json_value(3);
	assert(jv.to_json_string()=="3");

	json_value jarr = json_value.from_array([1,2,3]);
	assert(jarr.to_json_string(VALUE_STRING_CVT_TYPE.CVT_JSON_LITERAL)=="[1, 2, 3]");
	assert(jarr.get_item(2).get(0)==3);

	json_value jassoc1 = [
		"key1"w : 1,
		"key2"w : 2,
	];
	json_value jassoc2 = [
		"key1"w : json_value(1),
		"key2"w : json_value(2),
	];
	assert(jassoc1.to_json_string() == jassoc2.to_json_string());
}


/*
Obs:
.ValueXXX() functions return uint type, result code is VALUE_RESULT enumeration
*/

struct json_value
{
private:
	VALUE data;// don't directly access this, instead use the implicit cast operators

public:
    alias toVALUE this;// a.k.a. implicit cast operator to VALUE

	@property VALUE toVALUE()
    {
        // increase ref-count for converting json_value to VALUE
		VALUE vcopy;
		.ValueInit(&vcopy);
		.ValueCopy(&vcopy, &data);
		return vcopy;
    }

	@property const(VALUE*) toVALUEptr()
    {
		return &data;
    }

	this(this)
	{
		VALUE copy = data;
		.ValueInit(&data);
		.ValueCopy(&data, &copy);
	}
	this(json_value* src)	{ .ValueInit(&data); .ValueCopy(&data, &src.data); }
	this(ref json_value src){ .ValueInit(&data); .ValueCopy(&data, &src.data); }
	this(ref VALUE srcv)	{ .ValueInit(&data); .ValueCopy(&data, &srcv); }// move semantics? dont know, so better not even mess with it, cause this is working fine
	this(VALUE srcv)		{ .ValueInit(&data); .ValueCopy(&data, &srcv); }
	~this() { .ValueClear(&data); }

	// TODO: port assignment operator (operation not very fitted for D?)
	//value& operator = (const value& src) { ValueCopy(this,&src); return *this; }
	//value& operator = (const VALUE& src) { ValueCopy(this,&src); return *this; }

	this(bool v)		{ .ValueInit(&data); .ValueIntDataSet(&data, v?1:0, VALUE_TYPE.T_BOOL, 0); }
	this(int v)			{ .ValueInit(&data); .ValueIntDataSet(&data, v, VALUE_TYPE.T_INT, 0); }
	this(double v)		{ .ValueInit(&data); .ValueFloatDataSet(&data, v, VALUE_TYPE.T_FLOAT, 0); }

	this(wstring str)	{ .ValueInit(&data); .ValueStringDataSet(&data, str.ptr, cast(uint) str.length, VALUE_UNIT_TYPE_STRING.UT_STRING_STRING); }
	this(in BYTE[] bs)	{ .ValueInit(&data); .ValueBinaryDataSet(&data, bs.ptr, cast(uint) bs.length, VALUE_TYPE.T_BYTES, 0); }

	this(in json_value[] arr)	{ .ValueInit(&data); foreach(i, ref a; arr) set_item(cast(uint)i, a); }
	this(T)(in T[wstring] assocarr)
	{
		.ValueInit(&data);
		foreach(key; assocarr.keys)
			set_item( make_symbol(key), json_value(assocarr[key]) );
	}
	this(in json_value[wstring] assocarr)
	{
		.ValueInit(&data);
		foreach(key; assocarr.keys)
			set_item( make_symbol(key), assocarr[key] );
	}

	static json_value from_array(T)(in T[] arr)// could not make it a this() constructor because of ambiguity - midi
	{
		json_value jv;
		foreach(i, ref a; arr)
			jv.set_item(i, json_value(a));
		return jv;
	}

	// new replacement: toVALUE() + implicity cast operator see line 49
	/*VALUE copy()// added by sciter-dport - midi
	{
	VALUE vcopy;
	.ValueInit(&vcopy);
	.ValueCopy(&vcopy, &data);
	return vcopy;
	}*/

	/*override bool opEquals(Object o) const
	{
	auto cv = cast(const value) o;
	return this==cv.data;
	}

	bool opEquals(VALUE v) const
	{
	switch( .ValueCompare(&data, &v) )
	{
	case VALUE_RESULT.HV_OK: return false;
	case VALUE_RESULT.HV_OK_TRUE: return true;
	default: assert(false);
	}
	return false;
	}*/



	/*static value currency( INT64 v )	{ value t = new value; .ValueInt64DataSet(&t.data, v, VALUE_TYPE.T_CURRENCY, 0); return t; }
	static value date( INT64 v )		{ value t = new value; .ValueInt64DataSet(&t.data, v, VALUE_TYPE.T_DATE, 0); return t; }
	static value date( FILETIME ft )	{ value t = new value; .ValueInt64DataSet(&t.data, *cast(INT64*)&ft, VALUE_TYPE.T_DATE, 0); return t; }
	static value symbol( wstring s )	{ value t = new value; .ValueInit(&t.data); .ValueStringDataSet(&t.data, s.ptr, s.length, VALUE_UNIT_TYPE.UT_SYMBOL); return t; }
	*/

	static json_value secure_string(wstring s)// what is a secure string? - midi
	{
		json_value jv;
		.ValueStringDataSet(&jv.data, s.ptr, cast(uint) s.length, VALUE_UNIT_TYPE_STRING.UT_STRING_SECURE);
		return jv;
	}


	/+
	Returns json_value representing error.
	If such value is used as a return value from native function the script runtime will throw an error in script rather than returning that value.
	+/
	static json_value make_error(wstring s)
	{
        json_value jv;
        if(!s)
			return jv;
		.ValueStringDataSet(&jv.data, s.ptr, cast(uint) s.length, VALUE_UNIT_TYPE_STRING.UT_STRING_ERROR);
        return jv;
	}

	static json_value make_symbol(wstring s)
	{
        json_value jv;
        if(!s)
			return jv;
		.ValueStringDataSet(&jv.data, s.ptr, cast(uint) s.length, VALUE_UNIT_TYPE_STRING.UT_STRING_SYMBOL);
        return jv;
	}

	bool is_undefined() const { return data.t == VALUE_TYPE.T_UNDEFINED; }
	bool is_bool() const { return data.t == VALUE_TYPE.T_BOOL; }
	bool is_int() const { return data.t == VALUE_TYPE.T_INT; }
	bool is_float() const { return data.t == VALUE_TYPE.T_FLOAT; }
	bool is_string() const { return data.t == VALUE_TYPE.T_STRING; }
	bool is_symbol() const { return data.t == VALUE_TYPE.T_STRING && data.u == VALUE_UNIT_TYPE_STRING.UT_STRING_SYMBOL; }
	bool is_error_string() const { return data.t == VALUE_TYPE.T_STRING && data.u == VALUE_UNIT_TYPE_STRING.UT_STRING_ERROR; }
	bool is_date() const { return data.t == VALUE_TYPE.T_DATE; }
	bool is_currency() const { return data.t == VALUE_TYPE.T_CURRENCY; }
	bool is_map() const { return data.t == VALUE_TYPE.T_MAP; }
	bool is_array() const { return data.t == VALUE_TYPE.T_ARRAY; }
	bool is_function() const { return data.t == VALUE_TYPE.T_FUNCTION; }
	bool is_bytes() const { return data.t == VALUE_TYPE.T_BYTES; }
	bool is_object() const { return data.t == VALUE_TYPE.T_OBJECT; }
	bool is_dom_element() const { return data.t == VALUE_TYPE.T_DOM_OBJECT; }
	bool is_native_function() const { return !!ValueIsNativeFunctor(&data); }
	bool is_null() const { return data.t == VALUE_TYPE.T_NULL; }

	static json_value nullval() { json_value t; t.data.t = VALUE_TYPE.T_NULL; return t; }	// sciter-dport: null is a reserved D identifier,
	// so I renamed this functions from null() to nullval() - midi

	bool get(bool defv) 
	{
		int v;
		if(.ValueIntData(&data,&v) == VALUE_RESULT.HV_OK) return v != 0; 
		return defv;
	}
	int get(int defv) 
	{
		int v;
		if(.ValueIntData(&data,&v) == VALUE_RESULT.HV_OK) return v;
		return defv;
	}
	double get(double defv) 
	{
		double v;
		if(.ValueFloatData(&data,&v) == VALUE_RESULT.HV_OK) return v; 
		return defv;
	}
	wstring get(wstring defv)
	{
		LPCWSTR ret_pstr;
		uint ret_length;
		if(.ValueStringData(&data, &ret_pstr, &ret_length) == VALUE_RESULT.HV_OK)
			return ret_pstr[0..ret_length].idup;
		return defv;
	}
	wchar[] get_chars()// tested and you do can use this to modify the internal buffer of the string maintained by Sciter
	{
		LPCWSTR ret_pstr;
		uint ret_length;
		.ValueStringData(&data, &ret_pstr, &ret_length) == VALUE_RESULT.HV_OK || assert(false);
		return (cast(LPWSTR)ret_pstr) [0..ret_length];
	}
	const(BYTE[]) get_bytes()// same as get_chars()
	{
		LPCBYTE ret_ptr;
		uint ret_length;
		.ValueBinaryData(&data, &ret_ptr, &ret_length);
		return (ret_ptr)[0..ret_length];
	}

	version(Windows)
	{
		FILETIME get_date()
		{ 
			FILETIME v;
			.ValueInt64Data(&data,cast(long*) &v);
			return v;
		}
	}

	static VALUE from_json_string(wstring s, VALUE_STRING_CVT_TYPE ct = VALUE_STRING_CVT_TYPE.CVT_SIMPLE)
	{
		VALUE v;
		.ValueFromString(&v, s.ptr, cast(uint)s.length, ct);
		return v;
	}

	wstring to_json_string(VALUE_STRING_CVT_TYPE ct_how = VALUE_STRING_CVT_TYPE.CVT_JSON_LITERAL)
	{
		if( ct_how == VALUE_STRING_CVT_TYPE.CVT_SIMPLE && is_string() )
			return get_chars().idup;

		json_value v = data;
		.ValueToString(&v.data, ct_how);// as in SDK: ValueToString converts value to T_STRING inplace
		// trickie thing, grr, who owns this VALUE now? guess me
		return v.get_chars().idup;
	}

	void clear()
	{
		.ValueClear(&data);
	}

	int length() 
	{
		int n;
		.ValueElementsCount(&data, &n);
		return n;
	}


	json_value get_item(int n)
	{
		json_value val;
		.ValueNthElementValue(&data, n, &val.data);
		return val;
	}

	/*
	const value operator[](int n) const { return get_item(n); }
	value_idx_a operator[](int n);

	const value operator[](const value& key) const { return get_item(key); }
	value_key_a operator[](const value& key);
	*/

	/*struct enum_cb
	{
	// return true to continue enumeration
	virtual bool on(const value& key, const value& val) = 0;
	static BOOL CALLBACK _callback( void* param, const VALUE* pkey, const VALUE* pval )
	{
	enum_cb* cb = (enum_cb*)param;
	return cb->on( *(value*)pkey, *(value*)pval );
	}
	};

	// enum
	void enum_elements(enum_cb& cb) const
	{
	ValueEnumElements(const_cast<value*>(this), &enum_cb::_callback, &cb);
	}*/

	/*value key(int n)
	{
	value r = new value;
	.ValueNthElementKey(&data, n, &r.data);
	return r;
	}*/

	void set_item(int n, immutable json_value v)
	{
		.ValueNthElementValueSet(&data, n, &v.data);
	}

	void append(immutable json_value v) 
	{
		.ValueNthElementValueSet(&data, length(), &v.data);
	}

	void set_item(immutable json_value key, immutable json_value v)
	{
		.ValueSetValueToKey(&data, &key.data, &v.data);
	}

	VALUE get_item(json_value key)
	{
		VALUE r;
		.ValueGetValueOfKey(&data, &key.data, &r);
		return r;
	}

	void set_object_data(void* pv)
	{
		assert(data.u == VALUE_UNIT_TYPE_OBJECT.UT_OBJECT_NATIVE);
		.ValueBinaryDataSet(&data, cast(LPCBYTES)pv, 1, VALUE_TYPE.T_OBJECT, 0);//shouldnt be dereferencing pv?
	}
	void* get_object_data()
	{
		LPCBYTES pv; uint dummy;
		.ValueBinaryData(&data,&pv,&dummy) == VALUE_RESULT.HV_OK || assert(false);
		return cast(void*)pv;
	}


	bool is_object_native() const   { return data.t == VALUE_TYPE.T_OBJECT && data.u == VALUE_UNIT_TYPE_OBJECT.UT_OBJECT_NATIVE; }
	bool is_object_array() const    { return data.t == VALUE_TYPE.T_OBJECT && data.u == VALUE_UNIT_TYPE_OBJECT.UT_OBJECT_ARRAY; }
	bool is_object_function() const { return data.t == VALUE_TYPE.T_OBJECT && data.u == VALUE_UNIT_TYPE_OBJECT.UT_OBJECT_FUNCTION; }
	bool is_object_object() const   { return data.t == VALUE_TYPE.T_OBJECT && data.u == VALUE_UNIT_TYPE_OBJECT.UT_OBJECT_OBJECT; }
	bool is_object_class() const    { return data.t == VALUE_TYPE.T_OBJECT && data.u == VALUE_UNIT_TYPE_OBJECT.UT_OBJECT_CLASS; }
	bool is_object_error() const    { return data.t == VALUE_TYPE.T_OBJECT && data.u == VALUE_UNIT_TYPE_OBJECT.UT_OBJECT_ERROR; }


	// T_OBJECT/UT_OBJECT_FUNCTION only, call TS function
	// 'self' here is what will be known as 'this' inside the function, can be undefined for invocations of global functions 
	VALUE call(const(VALUE)[] args, json_value self = json_value.init, wstring url_or_script_name = null) const
	{
		assert(is_function() || is_object_function());

		VALUE rv;
		.ValueInvoke(&data /*this VALUE*/, &self.data, cast(uint)args.length, args.ptr, &rv, (url_or_script_name ~ '\0').ptr);
		return rv;
	}
	VALUE call(const(json_value)[] args...) const
	{
		assert(is_function() || is_object_function());
		return call(cast(VALUE[])args);
	}

	void isolate()
	{
		.ValueIsolate(&data);
	}

	/*static bool equal(in value v1, in value v2)
	{
	if( v1 == v2 ) return true; // strict comparison
	switch ( v1.t > v2.t? v1.t: v2.t )
	{
	case T_BOOL:
	{
	bool const r1 = v1.get(false);
	bool const r2 = v2.get(!r1);
	return r1 == r2;
	}
	case T_INT:
	{
	int const r1 = v1.get(0);
	int const r2 = v2.get(-r1);
	return r1 == r2;
	}
	case T_FLOAT:
	{
	double const r1 = v1.get(0.0);
	double const r2 = v2.get(-r1);
	return r1 == r2;
	}
	}
	return false;
	}*/


	// TODO: port proxy acessors classes (what are they for?)
}