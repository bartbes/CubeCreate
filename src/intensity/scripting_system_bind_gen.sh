#!/bin/bash
# simple script generating a proper scripting_system_lua_exp.hpp from scripting_system_lua_def.hpp

# variables
# input file
IN="scripting_system_lua_def.hpp"
# output file
OUT="scripting_system_lua_exp.hpp"
# temporary preprocessed input
TMP="tmp_$$.$$"
# output version
VER="$(cat $IN|grep 'scripting_system_lua_def.hpp, version'|sed 's/ \* scripting_system_lua_def.hpp, version //')"
# the preprocessor to use to get rid of additional macros
CPP="cpp -DCLIENT -DSERVER"

$CPP $IN | grep LUA_BIND > $TMP

cat << EOF > $OUT
/*
 * scripting_system_lua_exp.hpp, version $VER
 * Header file for Lua binding definitions
 *
 * author: q66 <quaker66@gmail.com>
 * license: MIT/X11
 *
 * Copyright (c) 2010 q66
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
 *
 */

#define LUAREG(n) CAPI.add((LE_reg){ #n, _bind_##n });
EOF

counter=0
cat $TMP | while read x
do
	if [ $counter -ge 2 ]; then
		name="$(echo $x|sed -e 's/,.*//' -e 's/.*(//')"
		echo -e "LUAREG($name)" >> $OUT
	fi
	let counter++
done

cat << EOF >> $OUT
#undef LUAREG
EOF

echo "-----------------------------------------"
echo "Done processing, removing temporary file."

rm $TMP

exit 0
