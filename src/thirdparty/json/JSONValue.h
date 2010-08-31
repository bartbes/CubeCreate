/*
 * JSONValue.h
 * Copyright (C) 2010 Mike Anchor <mikea@mjpa.co.uk>
 *
 * Part of the MJPA JSON Library - http://mjpa.co.uk/blog/view/A-simple-C-JSON-library/
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#ifndef _JSONVALUE_H_
#define _JSONVALUE_H_

#include <vector>
#include <string>

#include "JSON.h"

class JSON;

enum JSONType { JSONType_Null, JSONType_String, JSONType_Bool, JSONType_Number, JSONType_Array, JSONType_Object };

class JSONValue
{
	friend class JSON;
	
	public:
		JSONValue();
		JSONValue(const wchar_t *m_char_value);
		JSONValue(std::wstring m_string_value);
		JSONValue(bool m_bool_value);
		JSONValue(double m_number_value);
		JSONValue(JSONArray m_array_value);
		JSONValue(JSONObject m_object_value);
		~JSONValue();
		
		bool IsNull();
		bool IsString();
		bool IsBool();
		bool IsNumber();
		bool IsArray();
		bool IsObject();
		
		std::wstring AsString();
		bool AsBool();
		double AsNumber();
		JSONArray AsArray();
		JSONObject AsObject();
		
		std::wstring Stringify();
		
	protected:
		static JSONValue *Parse(const wchar_t **data);
	
	private:
		static std::wstring StringifyString(std::wstring str);
	
		JSONType type;
		std::wstring string_value;
		bool bool_value;
		double number_value;
		JSONArray array_value;
		JSONObject object_value;
};

#endif
