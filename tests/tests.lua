package.path = package.path .. ';src/?.lua;tests/?.lua'
local flua = require('flua')
local test_runner = require('test_runner')

test('flua.ipairs:iter', function ()
    local n = 0
    for i, v in flua.ipairs({ 5, 6, 7, 8, 9 }):iter() do
        n = n + 1
        assert(n == i, 'invalid index')
        assert(n + 4 == v, 'invalid value')
    end
    assert(n == 5, 'invalid length')
    for _ in flua.ipairs(nil):iter() do
        assert(false, 'unreachable')
    end
end)

test('flua.ivalues:iter', function ()
    local n = 0
    for v in flua.ivalues({ 5, 6, 7, 8, 9 }):iter() do
        n = n + 1
        assert(n + 4 == v, 'invalid value')
    end
    assert(n == 5, 'invalid length')
    for _ in flua.ivalues(nil):iter() do
        assert(false, 'unreachable')
    end
end)

test('flua.pairs:iter', function ()
    local t1, t2 = { hello = 4, [1] = true, [print] = 'print function' }, {}
    for k, v in flua.pairs(t1):iter() do
        t2[k] = v
    end
    assert_equal(t1, t2, 'tables not equal')
    for _ in flua.pairs(nil):iter() do
        assert(false, 'unreachable')
    end
end)

test('flua.values:iter', function ()
    local t1, t2, t3 = { hello = 4, [1] = true, [print] = 'print function' }, {}, {}
    for v in flua.values(t1):iter() do
        t2[v] = true
    end
    for _, v in pairs(t1) do
        t3[v] = true
    end
    assert_equal(t2, t3, 'tables not equal')
    for _ in flua.values(nil):iter() do
        assert(false, 'unreachable')
    end
end)

test('flua.keys:iter', function ()
    local t1, t2, t3 = { hello = 4, [1] = true, [print] = 'print function' }, {}, {}
    for k in flua.keys(t1):iter() do
        t2[k] = true
    end
    for k, _ in pairs(t1) do
        t3[k] = true
    end
    assert_equal(t2, t3, 'tables not equal')
    for _ in flua.keys(nil):iter() do
        assert(false, 'unreachable')
    end
end)

test('flua.for_values:iter', function ()
    local input, output = { 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40 }, {}
    local expected = { 34, 30, 26, 22, 18, 14, 10, 6 }
    for i = 17, 3, -2 do
        output[#output + 1] = input[i]
    end
    assert_equal(expected, output)
    output = {}
    for value in flua.for_values(input, 17, 3, -2):iter() do
        output[#output + 1] = value
    end
    assert_equal(expected, output)
    expected = { 30, 32, 34, 36, 38, 40 }
    output = {}
    for i = 15, 20 do
        output[#output + 1] = input[i]
    end
    assert_equal(expected, output)
    output = {}
    for value in flua.for_values(input, 15, 20):iter() do
        output[#output + 1] = value
    end
    assert_equal(expected, output)
end)
test('flua.for_pairs:iter', function ()
    local input, output = { 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40 }, {}
    local expected = { 34, 30, 26, 22, 18, 14, 10, 6 }
    for i = 17, 3, -2 do
        output[#output + 1] = input[i]
    end
    assert_equal(expected, output)
    output = {}
    for index, value in flua.for_pairs(input, 17, 3, -2):iter() do
        assert_equal(index * 2, value)
        assert_equal(index * 2, input[index])
        output[#output + 1] = value
    end
    assert_equal(expected, output)
    expected = { 30, 32, 34, 36, 38, 40 }
    output = {}
    for i = 15, 20 do
        output[#output + 1] = input[i]
    end
    assert_equal(expected, output)
    output = {}
    for index, value in flua.for_pairs(input, 15, 20):iter() do
        assert_equal(index * 2, value)
        assert_equal(index * 2, input[index])
        output[#output + 1] = value
    end
    assert_equal(expected, output)
end)

test('flua.range(upper)', function ()
    local n = 0
    for i in flua.range(10):iter() do
        n = n + 1
        assert(n == i, 'invalid value')
    end
    assert(n == 10, 'invalid length')
end)
test('flua.range(lower, upper)', function ()
    local n = 0
    for i in flua.range(11, 20):iter() do
        n = n + 1
        assert(n + 10 == i, 'invalid value')
    end
    assert(n == 10, 'invalid length')
end)
test('flua.reverse_range(upper)', function ()
    local n = 0
    for i in flua.reverse_range(10):iter() do
        assert(10 - n == i, 'invalid value')
        n = n + 1
    end
    assert(n == 10, 'invalid length')
end)
test('flua.reverse_range(lower, upper)', function ()
    local n = 0
    for i in flua.reverse_range(11, 20):iter() do
        assert(20 - n == i, 'invalid value')
        n = n + 1
    end
    assert(n == 10, 'invalid length')
end)

test('flua.infinite()', function ()
    local n = 0
    for i in flua.infinite():iter() do
        n = n + 1
        assert(n == i, 'invalid value')
        if n == 50 then break end
    end
    assert(n == 50, 'invalid length')
end)

test('flua.duplicate 1d', function ()
    local n = 0
    for v in flua.duplicate(5, 1337):iter() do
        n = n + 1
        assert(v == 1337, 'invalid value')
    end
    assert(n == 5, 'invalid length')
end)
test('flua.dupliate 4d', function ()
    local n = 0
    for x1, x2, y1, y2 in flua.duplicate(5, 21, 69, nil, 1337):iter() do
        n = n + 1
        assert(x1 == 21, 'invalid value for x1')
        assert(x2 == 69, 'invalid value for x2')
        assert(y1 == nil, 'invalid value for y1')
        assert(y2 == 1337, 'invalid value for y2')
    end
    assert(n == 5, 'invalid length')
end)
test('flua.duplicate 3d width', function ()
    local iterator, invariant, control = flua.duplicate(1, nil, nil, nil):iter()
    assert(select('#', iterator(invariant, control)) == 3, 'invalid width')
end)

test('flua.wrap ipairs', function ()
    local n = 0
    for i, v in flua.wrap(2, ipairs({ 5, 6, 7, 8, 9 })):iter() do
        n = n + 1
        assert(n == i, 'invalid index')
        assert(n + 4 == v, 'invalid value')
    end
    assert(n == 5, 'invalid length')
end)
test('flua.wrap gmatch', function ()
    local n = 0
    for k, v in flua.wrap(2,
        string.gmatch('key1=value5 key2=value6 key3=value7 key4=value8 key5=value9', '(%w+)=(%w+)')):iter() do
        n = n + 1
        assert('key' .. tostring(n) == k, 'invalid key')
        assert('value' .. tostring(n + 4) == v, 'invalid value')
    end
    assert(n == 5, 'invalid length')
end)

test('flua.from ipairs', function ()
    local n = 0
    for i, v in flua.from(2, function () return ipairs({ 5, 6, 7, 8, 9 }) end):iter() do
        n = n + 1
        assert(n == i, 'invalid index')
        assert(n + 4 == v, 'invalid value')
    end
    assert(n == 5, 'invalid length')
end)
test('flua.from gmatch', function ()
    local n = 0
    for k, v in flua.from(2, function ()
        return string.gmatch('key1=value5 key2=value6 key3=value7 key4=value8 key5=value9', '(%w+)=(%w+)')
    end):iter() do
        n = n + 1
        assert('key' .. tostring(n) == k, 'invalid key')
        assert('value' .. tostring(n + 4) == v, 'invalid value')
    end
    assert(n == 5, 'invalid length')
end)

test('flua:list', function ()
    assert_equal({ 5, 6, 7, 8, 9 }, flua.range(5):map(function (v) return v + 4 end):list(), 'tables not equal')
end)
test('flua:table', function ()
    assert_equal({
        ['1'] = 5,
        ['2'] = 6,
        ['3'] = 7,
        ['4'] = 8,
        ['5'] = 9
    }, flua.range(5):map(function (v) return tostring(v), v + 4 end, 2):table(), 'tables not equal')
end)
test('flua:group_by(group, value)', function()
    assert_equal({
        t1 = { 3, 6, 11 },
        t2 = { 2, 4, 5, 12 },
        t3 = { 1, 7, 8, 9, 10 },
    }, flua.ipairs({
        { type = 't3', key = 'a' },
        { type = 't2', key = 'b' },
        { type = 't1', key = 'c' },
        { type = 't2', key = 'd' },
        { type = 't2', key = 'e' },
        { type = 't1', key = 'f' },
        { type = 't3', key = 'g' },
        { type = 't3', key = 'h' },
        { type = 't3', key = 'i' },
        { type = 't3', key = 'j' },
        { type = 't1', key = 'k' },
        { type = 't2', key = 'l' },
    }):group_by(
        function (index, value) return value.type end,
        function (index, value) return index end
    ))
end)
test('flua:group_by(group, key, value)', function()
    assert_equal({
        t1 = { c = 3, f = 6, k = 11 },
        t2 = { b = 2, d = 4, e = 5, l = 12 },
        t3 = { a = 1, g = 7, h = 8, i = 9, j = 10 },
    }, flua.ipairs({
        { type = 't3', key = 'a' },
        { type = 't2', key = 'b' },
        { type = 't1', key = 'c' },
        { type = 't2', key = 'd' },
        { type = 't2', key = 'e' },
        { type = 't1', key = 'f' },
        { type = 't3', key = 'g' },
        { type = 't3', key = 'h' },
        { type = 't3', key = 'i' },
        { type = 't3', key = 'j' },
        { type = 't1', key = 'k' },
        { type = 't2', key = 'l' },
    }):group_by(
        function (index, value) return value.type end,
        function (index, value) return value.key end,
        function (index, value) return index end
    ))
end)

test('flua:map 1d', function ()
    local n = 0
    for v in flua.ivalues({ 5, 6, 7, 8, 9 })
        :map(function (v) return v + 5 end)
        :iter() do
        n = n + 1
        assert(n + 9 == v, 'invalid value')
    end
    assert(n == 5, 'invalid length')
end)
test('flua:map 2d', function ()
    local n = 0
    for i, v in flua.ipairs({ 5, 6, 7, 8, 9 })
        :map(function (i, v) return v + 15, i + 10 end)
        :iter() do
        n = n + 1
        assert(n + 19 == i, 'invalid index')
        assert(n + 10 == v, 'invalid value')
    end
    assert(n == 5, 'invalid length')
end)
test('flua:map:map 1d', function ()
    local n = 0
    for v in flua.ivalues({ 5, 6, 7, 8, 9 })
        :map(function (v) return v * 2 end)
        :map(function (v) return v * 3 end)
        :iter() do
        n = n + 1
        assert((n + 4) * 6 == v, 'invalid value')
    end
    assert(n == 5, 'invalid length')
end)
test('flua:map 2d => 4d', function ()
    local n = 0
    for x1, x2, y1, y2 in flua.ipairs({ 5, 6, 7, 8, 9 })
        :map(function (i, v) return i + 10, i + 20, v + 30, v + 40 end, 4)
        :iter()
        do
        n = n + 1
        assert(n + 10 == x1, 'invalid x1')
        assert(n + 20 == x2, 'invalid x2')
        assert(n + 34 == y1, 'invalid y1')
        assert(n + 44 == y2, 'invalid y2')
    end
    assert(n == 5, 'invalid length')
end)

test('flua:flatmap 1d', function ()
    local n = 0
    for v in flua.ivalues({ 1, 2, 3 })
        :flatmap(function (v) return flua.ivalues({ v, v, v }) end)
        :iter() do
        n = n + 1
        assert(math.ceil(n / 3) == v, 'invalid value')
    end
    assert(n == 9, 'invalid length')
end)
test('flua:flatmap 2d', function ()
    local n = 0
    for i, v in flua.ipairs({ 5, 6, 7 })
        :flatmap(function (i, v)
            local r = {}
            for j = 1, i do r[j] = v end
            return flua.ipairs(r)
        end)
        :iter() do
        n = n + 1
        if n <= 1 then
            assert(n == i, 'invalid index')
            assert(5 == v, 'invalid value')
        elseif n <= 3 then
            assert(n - 1 == i, 'invalid index')
            assert(6 == v, 'invalid value')
        elseif n <= 6 then
            assert(n - 3 == i, 'invalid index')
            assert(7 == v, 'invalid value')
        else
            assert(false, 'invalid length')
        end
    end
    assert(n == 6, 'invalid length')
end)
test('flua:flatmap 2d => 1d', function ()
    local n = 0
    for v in flua.ipairs({ 5, 6, 7 })
        :flatmap(function (i, v)
            return flua.duplicate(i, v)
        end, 1)
        :iter() do
        n = n + 1
        if n <= 1 then
            assert(5 == v, 'invalid value')
        elseif n <= 3 then
            assert(6 == v, 'invalid value')
        elseif n <= 6 then
            assert(7 == v, 'invalid value')
        else
            assert(false, 'invalid length')
        end
    end
    assert(n == 6, 'invalid length')
end)
test('flua:map 1d => 4d:filtermap 4d', function ()
    local n = 0
    for x1, x2, y1, y2 in flua.ivalues({ 1, 2, 3, 4, 5 })
        :map(function (i)
            return i * 7, i * 11, i * 13, i * 17
        end, 4)
        :filtermap(function (x1, x2, y1, y2)
            if x1 % 2 == 0 then return end
            return x1 - 1, x2 - 2, y1 - 3, y2 - 4
        end)
        :iter() do
        n = n + 1
        assert(n * 2 *  7 -  7 - 1 == x1, 'invalid value for x1')
        assert(n * 2 * 11 - 11 - 2 == x2, 'invalid value for x2')
        assert(n * 2 * 13 - 13 - 3 == y1, 'invalid value for y1')
        assert(n * 2 * 17 - 17 - 4 == y2, 'invalid value for y2')
    end
    assert(n == 3, 'invalid length')
end)

test('flua:filter 1d', function ()
    local n = 0
    for v in flua.ivalues({ 5, 6, 7, 8, 9 })
        :filter(function (v) return v % 2 == 1 end)
        :iter() do
        n = n + 1
        assert(2 * n + 3 == v, 'invalid value')
    end
    assert(n == 3, 'invalid length')
end)
test('flua:filter 2d', function ()
    local n = 0
    for k, v in flua.ipairs({ 5, 7, 8, 10, 11 })
        :filter(function (k, v) return (k + v) % 2 == 0 end)
        :iter() do
        n = n + 1
        if n == 1 then assert(k == 1 and v == 5, 'invalid value at n == 1') end
        if n == 2 then assert(k == 4 and v == 10, 'invalid value at n == 2') end
        if n == 3 then assert(k == 5 and v == 11, 'invalid value at n == 1') end
    end
    assert(n == 3, 'invalid length')
end)
test('flua:filter:map 1d', function ()
    local n = 0
    for v in flua.ivalues({ 5, 6, 7, 8, 9 })
        :filter(function (v) return v % 2 == 1 end)
        :map(function (v) return (v - 1) / 2 end)
        :iter() do
        n = n + 1
        assert(n + 1 == v, 'invalid value')
    end
    assert(n == 3, 'invalid length')
end)
test('flua:map:filter 1d', function ()
    local n = 0
    for v in flua.ivalues({ 5, 6, 7, 8, 9 })
        :map(function (v) return (v - 1) / 2 end)
        :filter(function (v) return v % 1 == 0 end)
        :iter() do
        n = n + 1
        assert(n + 1 == v, 'invalid value')
    end
    assert(n == 3, 'invalid length')
end)

test('flua:filtermap 2d => 1d', function ()
    local n = 0
    for v in flua.ipairs({ 5, 6, 7, 8, 9 })
        :filtermap(function (i, v)
            if i % 2 == 1 then
                return v * 2
            end
        end, 1):iter() do
        n = n + 1
        assert(n * 4 + 6 == v, 'invalid value')
    end
    assert(n == 3, 'invalid length')
end)
test('flua:filtermap 1d => 2d', function ()
    local n = 0
    for i, v in flua.ivalues({ 1, 2, 3, 4, 5 })
        :filtermap(function (v)
            if v % 2 == 1 then
                return (v + 1) / 2, v * 2
            end
        end, 2):iter() do
        n = n + 1
        assert(n == i, 'invalid index')
        assert(n * 4 - 2 == v, 'invalid value')
    end
    assert(n == 3, 'invalid length')
end)

test('flua:distinct', function ()
    local tbl = { 6, 5, 6, 4, 3, 3, 2, 4, 6, 4, 5, 5, 1, 1, 2, 3, 4, 3, 5, 5, 6 }
    local n = 0
    for v in flua.ivalues(tbl):distinct():iter() do
        n = n + 1
        assert(7 - n == v, 'invalid value')
    end
    assert(n == 6, 'invalid length')
end)

test('flua:memoize', function ()
    local c = 0
    local iter = flua.range(5):map(function (v)
        c = c + 1
        return v * 2, v * 3, nil, v * 5
    end, 4)
    local function test()
        local n = 0
        for x1, x2, y1, y2 in iter:iter() do
            n = n + 1
            assert(n * 2 == x1, 'invalid value for x1')
            assert(n * 3 == x2, 'invalid value for x2')
            assert(nil == y1, 'invalid value for y1')
            assert(n * 5 == y2, 'invalid value for y2')
        end
        assert(n == 5, 'invalid length')
    end
    test()
    assert_equal(5, c)
    test()
    assert_equal(10, c)
    iter = iter:memoize()
    test()
    assert_equal(15, c)
    test()
    assert_equal(15, c)
end)
test('flua:flatmap:memoize', function ()
    local count_1, count_2 = 0, 0
    local in_iter = flua.range(1, 3)
        :map(function (i)
            count_1 = count_1 + 1
            return i * 5 - 4, i * 5
        end, 2)
        :flatmap(function (lower, upper)
            count_2 = count_2 + 1
            return flua.range(lower, upper)
                :map(function (x) return x, nil end, 2)
                :zip(flua.range(lower, upper):map(function (x) return x * 2 end))
        end, 3)
    
    local expected_1 = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 }
    local expected_2 = { 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30 }
    local function test()
        local received_1, received_2 = {}, {}
        for i, j, k in in_iter:iter() do
            received_1[#received_1 + 1] = i
            assert_equal(nil, j)
            received_2[#received_2 + 1] = k
        end
        assert_equal(expected_1, received_1)
    end
    test()
    assert_equal(3, count_1)
    assert_equal(3, count_2)
    test()
    assert_equal(6, count_1)
    assert_equal(6, count_2)
    in_iter = in_iter:memoize()
    test()
    assert_equal(9, count_1)
    assert_equal(9, count_2)
    test()
    assert_equal(9, count_1)
    assert_equal(9, count_2)
end)

test('flua:concat 1d', function ()
    local n = 0
    for v in flua.ivalues({ 5, 6, 7, 8, 9 })
        :concat(flua.ivalues({ 15, 16, 17, 18, 19 }))
        :iter() do
        n = n + 1
        if n <= 5 then
            assert(n + 4 == v, 'invalid value')
        else
            assert(n + 9 == v, 'invalid value')
        end
    end
    assert(n == 10, 'invalid length')
end)
test('flua:concat 2d', function ()
    local n = 0
    for i, v in flua.ipairs({ 5, 6, 7, 8, 9 })
        :concat(flua.ipairs({ 15, 16, 17, 18, 19 }))
        :iter() do
        n = n + 1
        if n <= 5 then
            assert(n == i, 'invalid index')
            assert(n + 4 == v, 'invalid value')
        else
            assert(n - 5 == i, 'invalid index')
            assert(n + 9 == v, 'invalid value')
        end
    end
    assert(n == 10, 'invalid length')
end)

test('flua:zip 1d 2d => 3d', function ()
    local n = 0
    for i, k, v in flua:infinite():zip(
        flua.ipairs({ 5, 6, 7, 8, 9 })
            :map(function (k, v) return k + 4, v + 5 end)
        ):iter() do
        n = n + 1
        assert(n == i, 'invalid index')
        assert(n + 4 == k, 'invalid key')
        assert(n + 9 == v, 'invalid value')
    end
    assert(n == 5, 'invalid length')
end)
test('flua:zip 2d 2d => 4d', function ()
    local n, iter = 0, flua.ipairs({ 5, 6, 7, 8, 9 })
    for x1, x2, y1, y2 in iter:zip(
            iter:map(function (k, v) return k + 9, v + 10 end)
            :concat(iter)
        ):iter() do
        n = n + 1
        assert(n == x1, 'invalid value for x1')
        assert(n + 4 == x2, 'invalid value for x2')
        assert(n + 9 == y1, 'invalid value for y1')
        assert(n + 14 == y2, 'invalid value for y2')
    end
    assert(n == 5, 'invalid length')
end)

test('flua:take 1d', function ()
    local n = 0
    for v in flua.ivalues({ 5, 6, 7, 8, 9 })
        :take(3)
        :iter() do
        n = n + 1
        assert(n + 4 == v, 'invalid value')
    end
    assert(n == 3, 'invalid length')
end)
test('flua:take 2d', function ()
    local n = 0
    for i, v in flua.ipairs({ 5, 6, 7, 8, 9 })
        :take(3)
        :iter() do
        n = n + 1
        assert(n == i, 'invalid index')
        assert(n + 4 == v, 'invalid value')
    end
    assert(n == 3, 'invalid length')
end)

test('flua:skip 1d', function ()
    local n = 2
    for v in flua.ivalues({ 5, 6, 7, 8, 9 })
        :skip(2)
        :iter() do
        n = n + 1
        assert(n + 4 == v, 'invalid value')
    end
    assert(n == 5, 'invalid length')
end)
test('flua:skip 2d', function ()
    local n = 2
    for i, v in flua.ipairs({ 5, 6, 7, 8, 9 })
        :skip(2)
        :iter() do
        n = n + 1
        assert(n == i, 'invalid index')
        assert(n + 4 == v, 'invalid value')
    end
    assert(n == 5, 'invalid length')
end)

test('flua:reduce 2d => 1d', function ()
    assert(flua.ipairs({ 5, 6, 7, 8, 9 }):reduce(function (acc, i, v) return acc + i + v end, 0)
        == 50, 'invalid value')
end)
test('flua:reduce 2d => 2d', function ()
    local s1, s2 = flua.ipairs({ 5, 6, 7, 8, 9 }):reduce(function (s1, s2, i, v) return s1 + i, s2 + v end, 0, 0)
    assert(s1 == 15, 'invalid sum 1')
    assert(s2 == 35, 'invalid sum 2')
end)
test('flua:reduce 1d => 2d average', function ()
    local count, sum = flua.ivalues({ 5, 6, 7, 8, 9 })
        :reduce(function (count, sum, v) return count + 1, sum + v end, 0, 0)
    assert(count == 5, 'invalid count')
    assert(sum == 35, 'invalid sum')
end)

test('flua:count()', function ()
    assert(5 == flua.ipairs({ 5, 6, 7, 8, 9 }):count(), 'invalid count')
    assert(5 == flua.ivalues({ 5, 6, 7, 8, 9 }):count(), 'invalid count')
    assert(5 == flua.pairs({ 5, 6, 7, 8, 9 }):count(), 'invalid count')
    assert(5 == flua.values({ 5, 6, 7, 8, 9 }):count(), 'invalid count')
    assert(5 == flua.range(1, 5):count(), 'invalid count')
    assert(5 == flua.infinite():take(5):count(), 'invalid count')
end)
test('flua:sum()', function ()
    assert(15 == flua.range(1, 5):sum(), 'invalid sum')
    assert(35 == flua.ivalues({ 5, 6, 7, 8, 9}):sum(), 'invalid sum')
    assert(15 == flua.ipairs({ 5, 6, 7, 8, 9 }):map(function (i, v) return i end, 1):sum(), 'invalid sum')
    assert(15 == flua.infinite():take(5):sum(), 'invalid sum')
    assert(35 == flua.infinite():skip(4):take(5):sum(), 'invalid sum')
end)
test('flua:average()', function ()
    assert(3 == flua.range(1, 5):average(), 'invalid average')
    assert(7 == flua.ivalues({ 5, 6, 7, 8, 9}):average(), 'invalid average')
    assert(3 == flua.ipairs({ 5, 6, 7, 8, 9 }):map(function (i, v) return i end, 1):average(), 'invalid average')
    assert(3 == flua.infinite():take(5):average(), 'invalid average')
    assert(7 == flua.infinite():skip(4):take(5):average(), 'invalid average')
end)
test('flua:min()', function ()
    assert(nil == flua.values({}):min(), 'invalid min')
    assert(nil == flua.ivalues({}):min(), 'invalid min')
    assert(3 == flua.values({ 8, 5, 3, 6, 7 }):min(), 'invalid min')
    assert(3 == flua.values({ 5, 8, 6, 7, 3 }):min(), 'invalid min')
end)
test('flua:max()', function ()
    assert(nil == flua.values({}):max(), 'invalid max')
    assert(nil == flua.ivalues({}):max(), 'invalid max')
    assert(8 == flua.values({ 8, 5, 3, 6, 7 }):max(), 'invalid max')
    assert(8 == flua.values({ 5, 8, 6, 7, 3 }):max(), 'invalid max')
end)

test('flua:all', function ()
    local n = 0
    assert(flua.ipairs({ 5, 6, 7, 8, 9 }):all(function (i, v)
        n = n + 1
        return i + 4 == v
    end), 'invalid condition')
    assert(n == 5, 'predicate not ran for all elements')

    n = 0
    assert(not flua.ipairs({ 5, 6, 7, 7, 9 }):all(function (i, v)
        n = n + 1
        return i + 4 == v
    end), 'invalid condition')
    assert(n == 4, 'predicate not ran for the correct elements')
end)

test('flua:any', function ()
    local n = 0
    assert(flua.ipairs({ 4, 5, 6, 8, 9 }):any(function (i, v)
        n = n + 1
        return i + 4 == v
    end), 'invalid condition')
    assert(n == 4, 'predicate not ran for the correct elements')

    n = 0
    assert(not flua.ipairs({ 4, 5, 6, 7, 8 }):any(function (i, v)
        n = n + 1
        return i + 4 == v
    end), 'invalid condition')
    assert(n == 5, 'predicate not ran for the correct elements')
end)

test('flua:contains 2d', function ()
    assert(flua.ipairs({ 5, 6, 7, 8, 9 }):contains(3, 7), 'invalid condition')
    assert(not flua.ipairs({ 5, 6, 7, 8, 9 }):contains(4, 9), 'invalid condition')
end)
test('flua:contains 4d', function ()
    local iter = flua.range(5):map(function (v) return v * 2, v * 3, v * 5, v * 7 end, 4)
    assert(iter:contains(2, 3, 5, 7), 'invalid condition')
    assert(iter:contains(4, 6, 10, 14), 'invalid condition')
    assert(iter:contains(6, 9, 15, 21), 'invalid condition')
    assert(iter:contains(8, 12, 20, 28), 'invalid condition')
    assert(not iter:contains(2, 3, 5, 8), 'invalid condition')
    assert(not iter:contains(4, 6, 11, 14), 'invalid condition')
    assert(not iter:contains(6, 10, 15, 21), 'invalid condition')
    assert(not iter:contains(9, 12, 20, 28), 'invalid condition')
end)

test('flua:first 2d', function ()
    local iter = flua.range(5):zip(flua.duplicate(5, 3))
    local key, value = iter:first(function (k, v)
        assert(v == 3, 'invalid argument')
        return k >= 4
    end)
    assert(key == 4, 'invalid key')
    assert(value == 3, 'invalid value')
    assert(iter:first(function () end) == nil, 'invalid result')
end)
test('flua:first 4d', function ()
    local iter = flua.ipairs({ 5, 6, 7, 8, 9 }):map(function (k, v)
        return k, v, nil, v + 10
    end, 4)
    local x1, x2, y1, y2 = iter:first(function (x1, x2, y1, y2)
        assert(y1 == nil, 'invalid argument')
        return x1 + x2 + y2 >= 30 end
    )
    assert(x1 == 4, 'invalid x1')
    assert(x2 == 8, 'invalid x2')
    assert(y1 == nil, 'invalid y1')
    assert(y2 == 18, 'invalid y2')
    assert(iter:first(function () end) == nil, 'invalid result')
end)

test('flua:single 2d', function ()
    local iter = flua.range(5):zip(flua.duplicate(5, 3))
    local key, value = iter:single(function (k, v)
        assert(v == 3, 'invalid argument')
        return k >= 4
    end)
    assert(key == nil, 'invalid key')
    assert(value == nil, 'invalid value')
    key, value = iter:single(function (k, v)
        assert(v == 3, 'invalid argument')
        return k == 4
    end)
    assert(key == 4, 'invalid key')
    assert(value == 3, 'invalid value')
    
    assert(iter:single(function () end) == nil, 'invalid result')
end)
test('flua:single 4d', function ()
    local iter = flua.ipairs({ 5, 6, 7, 8, 9 }):map(function (k, v)
        return k, v, nil, v + 10
    end, 4)
    local x1, x2, y1, y2 = iter:single(function (x1, x2, y1, y2)
        assert(y1 == nil, 'invalid argument')
        return x1 + x2 + y2 == 30 end
    )
    assert(x1 == 4, 'invalid x1')
    assert(x2 == 8, 'invalid x2')
    assert(y1 == nil, 'invalid y1')
    assert(y2 == 18, 'invalid y2')
    x1, x2, y1, y2 = iter:single(function (x1, x2, y1, y2)
        assert(y1 == nil, 'invalid argument')
        return x1 + x2 + y2 >= 30 end
    )
    assert(x1 == nil, 'invalid x1')
    assert(x2 == nil, 'invalid x2')
    assert(y1 == nil, 'invalid y1')
    assert(y2 == nil, 'invalid y2')
    assert(iter:first(function () end) == nil, 'invalid result')
end)

test('flua:last 2d', function ()
    local iter = flua.range(5):zip(flua.duplicate(5, 3))
    local key, value = iter:last(function (k, v)
        assert(v == 3, 'invalid argument')
        return k >= 4
    end)
    assert(key == 5, 'invalid key')
    assert(value == 3, 'invalid value')
    assert(iter:last(function () end) == nil, 'invalid result')
end)
test('flua:last 4d', function ()
    local iter = flua.ipairs({ 5, 6, 7, 8, 9 }):map(function (k, v)
        return k, v, nil, v + 10
    end, 4)
    local x1, x2, y1, y2 = iter:last(function (x1, x2, y1, y2)
        assert(y1 == nil, 'invalid argument')
        return x2 <= 8 and x2 % 2 == 1 end
    )
    assert(x1 == 3, 'invalid x1')
    assert(x2 == 7, 'invalid x2')
    assert(y1 == nil, 'invalid y1')
    assert(y2 == 17, 'invalid y2')
    assert(iter:last(function () end) == nil, 'invalid result')
end)

run_tests()
