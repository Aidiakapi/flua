-- Performs deep equality check (not including metatables)
local function deep_equals(a, b)
    if a == b then
        return true
    end
    if type(a) ~= 'table' or type(b) ~= 'table' then
        return false
    end
    
    for k, v in pairs(a) do
        local o = b[k]
        if not deep_equals(v, o) then
            return false
        end
    end
    for k in pairs(b) do
        if a[k] == nil then
            return false
        end
    end
    return true
end

function assert_equal(expected, result, message)
    assert(deep_equals(expected, result), message or 'unexpected result')
end

local tests = {}
function test(name, func)
    tests[#tests + 1] = { name, func }
end

function run_tests(...)
    local specific_tests = {}
    local specific_test_n = select('#', ...)
    if specific_test_n == 0 then
        for _, test in ipairs(tests) do
            specific_tests[test[1]] = true
        end
    else
        for i = 1, specific_test_n do
            specific_tests[select(i, ...)] = true
        end
    end

    specific_test_n = 0
    for _ in pairs(specific_tests) do
        specific_test_n = specific_test_n + 1
    end

    print(('running %d tests...'):format(specific_test_n))

    local success_count = 0
    for _, test in ipairs(tests) do
        if specific_tests[test[1]] then
            local result = { xpcall(test[2], function (error) return { error, debug.traceback(nil, 2) } end) }
            if result[1] then success_count = success_count + 1 end
            test[3] = result
        end
    end

    local fail_count = specific_test_n - success_count
    print(('success: %d\tfail: %d'):format(success_count, fail_count))
    if fail_count == 0 then
        return
    end

    print()
    for _, test in ipairs(tests) do
        if specific_tests[test[1]] then
            local result = test[3]
            if not result[1] then
                print(('failed %s\t'):format(test[1]), result[2][1])
                print(result[2][2])
            end
        end
    end
end
