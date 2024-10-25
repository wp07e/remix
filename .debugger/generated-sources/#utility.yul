{

    function cleanup_t_uint256(value) -> cleaned {
        cleaned := value
    }

    function abi_encode_t_uint256_to_t_uint256_fromStack(value, pos) {
        mstore(pos, cleanup_t_uint256(value))
    }

    function abi_encode_tuple_t_uint256__to_t_uint256__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 32)

        abi_encode_t_uint256_to_t_uint256_fromStack(value0,  add(headStart, 0))

    }

    function allocate_unbounded() -> memPtr {
        memPtr := mload(64)
    }

    function revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() {
        revert(0, 0)
    }

    function revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() {
        revert(0, 0)
    }

    function validator_revert_t_uint256(value) {
        if iszero(eq(value, cleanup_t_uint256(value))) { revert(0, 0) }
    }

    function abi_decode_t_uint256(offset, end) -> value {
        value := calldataload(offset)
        validator_revert_t_uint256(value)
    }

    function abi_decode_tuple_t_uint256(headStart, dataEnd) -> value0 {
        if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

        {

            let offset := 0

            value0 := abi_decode_t_uint256(add(headStart, offset), dataEnd)
        }

    }

    function array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, length) -> updated_pos {
        mstore(pos, length)
        updated_pos := add(pos, 0x20)
    }

    function store_literal_in_memory_acae47d6d1dbb215c765f2c249bf9a14db36c3c42d7e1fef395232b4b603d4d8(memPtr) {

        mstore(add(memPtr, 0), "Old value:")

    }

    function abi_encode_t_stringliteral_acae47d6d1dbb215c765f2c249bf9a14db36c3c42d7e1fef395232b4b603d4d8_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 10)
        store_literal_in_memory_acae47d6d1dbb215c765f2c249bf9a14db36c3c42d7e1fef395232b4b603d4d8(pos)
        end := add(pos, 32)
    }

    function abi_encode_tuple_t_stringliteral_acae47d6d1dbb215c765f2c249bf9a14db36c3c42d7e1fef395232b4b603d4d8_t_uint256__to_t_string_memory_ptr_t_uint256__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 64)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_acae47d6d1dbb215c765f2c249bf9a14db36c3c42d7e1fef395232b4b603d4d8_to_t_string_memory_ptr_fromStack( tail)

        abi_encode_t_uint256_to_t_uint256_fromStack(value0,  add(headStart, 32))

    }

    function store_literal_in_memory_128e5c1375d3bdeb868e4208bde9fe8092edac92c1f89b0539c5f56a9d6d109c(memPtr) {

        mstore(add(memPtr, 0), "New value set to:")

    }

    function abi_encode_t_stringliteral_128e5c1375d3bdeb868e4208bde9fe8092edac92c1f89b0539c5f56a9d6d109c_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 17)
        store_literal_in_memory_128e5c1375d3bdeb868e4208bde9fe8092edac92c1f89b0539c5f56a9d6d109c(pos)
        end := add(pos, 32)
    }

    function abi_encode_tuple_t_stringliteral_128e5c1375d3bdeb868e4208bde9fe8092edac92c1f89b0539c5f56a9d6d109c_t_uint256__to_t_string_memory_ptr_t_uint256__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 64)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_128e5c1375d3bdeb868e4208bde9fe8092edac92c1f89b0539c5f56a9d6d109c_to_t_string_memory_ptr_fromStack( tail)

        abi_encode_t_uint256_to_t_uint256_fromStack(value0,  add(headStart, 32))

    }

    function store_literal_in_memory_a8bef10c99c16c9f71e79af3a4c6a947cebcc98b7334b8810083a5668b70deb7(memPtr) {

        mstore(add(memPtr, 0), "Input received:")

    }

    function abi_encode_t_stringliteral_a8bef10c99c16c9f71e79af3a4c6a947cebcc98b7334b8810083a5668b70deb7_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 15)
        store_literal_in_memory_a8bef10c99c16c9f71e79af3a4c6a947cebcc98b7334b8810083a5668b70deb7(pos)
        end := add(pos, 32)
    }

    function abi_encode_tuple_t_stringliteral_a8bef10c99c16c9f71e79af3a4c6a947cebcc98b7334b8810083a5668b70deb7_t_uint256__to_t_string_memory_ptr_t_uint256__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 64)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_a8bef10c99c16c9f71e79af3a4c6a947cebcc98b7334b8810083a5668b70deb7_to_t_string_memory_ptr_fromStack( tail)

        abi_encode_t_uint256_to_t_uint256_fromStack(value0,  add(headStart, 32))

    }

    function store_literal_in_memory_b99e77e087f8faf47e61677ef912d8b50caca44dd7d69bcb0a9740f6db72d781(memPtr) {

        mstore(add(memPtr, 0), "Function called by:")

    }

    function abi_encode_t_stringliteral_b99e77e087f8faf47e61677ef912d8b50caca44dd7d69bcb0a9740f6db72d781_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 19)
        store_literal_in_memory_b99e77e087f8faf47e61677ef912d8b50caca44dd7d69bcb0a9740f6db72d781(pos)
        end := add(pos, 32)
    }

    function cleanup_t_uint160(value) -> cleaned {
        cleaned := and(value, 0xffffffffffffffffffffffffffffffffffffffff)
    }

    function cleanup_t_address(value) -> cleaned {
        cleaned := cleanup_t_uint160(value)
    }

    function abi_encode_t_address_to_t_address_fromStack(value, pos) {
        mstore(pos, cleanup_t_address(value))
    }

    function abi_encode_tuple_t_stringliteral_b99e77e087f8faf47e61677ef912d8b50caca44dd7d69bcb0a9740f6db72d781_t_address__to_t_string_memory_ptr_t_address__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 64)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_b99e77e087f8faf47e61677ef912d8b50caca44dd7d69bcb0a9740f6db72d781_to_t_string_memory_ptr_fromStack( tail)

        abi_encode_t_address_to_t_address_fromStack(value0,  add(headStart, 32))

    }

    function panic_error_0x11() {
        mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
        mstore(4, 0x11)
        revert(0, 0x24)
    }

    function checked_mul_t_uint256(x, y) -> product {
        x := cleanup_t_uint256(x)
        y := cleanup_t_uint256(y)
        let product_raw := mul(x, y)
        product := cleanup_t_uint256(product_raw)

        // overflow, if x != 0 and y != product/x
        if iszero(
            or(
                iszero(x),
                eq(y, div(product, x))
            )
        ) { panic_error_0x11() }

    }

    function store_literal_in_memory_d5a97cc90a31fa5caa9c62da3002151844054138b0039fa066c34acb1d21a4e5(memPtr) {

        mstore(add(memPtr, 0), "Calculated value:")

    }

    function abi_encode_t_stringliteral_d5a97cc90a31fa5caa9c62da3002151844054138b0039fa066c34acb1d21a4e5_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 17)
        store_literal_in_memory_d5a97cc90a31fa5caa9c62da3002151844054138b0039fa066c34acb1d21a4e5(pos)
        end := add(pos, 32)
    }

    function abi_encode_tuple_t_stringliteral_d5a97cc90a31fa5caa9c62da3002151844054138b0039fa066c34acb1d21a4e5_t_uint256__to_t_string_memory_ptr_t_uint256__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 64)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_d5a97cc90a31fa5caa9c62da3002151844054138b0039fa066c34acb1d21a4e5_to_t_string_memory_ptr_fromStack( tail)

        abi_encode_t_uint256_to_t_uint256_fromStack(value0,  add(headStart, 32))

    }

    function store_literal_in_memory_ea5a73380cba5b75bc0f740e1e5f3fb764c54611cbb3ced23779db3543471043(memPtr) {

        mstore(add(memPtr, 0), "Calculated value is greater than")

        mstore(add(memPtr, 32), " 100")

    }

    function abi_encode_t_stringliteral_ea5a73380cba5b75bc0f740e1e5f3fb764c54611cbb3ced23779db3543471043_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 36)
        store_literal_in_memory_ea5a73380cba5b75bc0f740e1e5f3fb764c54611cbb3ced23779db3543471043(pos)
        end := add(pos, 64)
    }

    function abi_encode_tuple_t_stringliteral_ea5a73380cba5b75bc0f740e1e5f3fb764c54611cbb3ced23779db3543471043__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_ea5a73380cba5b75bc0f740e1e5f3fb764c54611cbb3ced23779db3543471043_to_t_string_memory_ptr_fromStack( tail)

    }

    function store_literal_in_memory_317f7c998ab5ba324acfc05a54f25f646e2187d61bc1c442f85738b0a1ea8cf1(memPtr) {

        mstore(add(memPtr, 0), "Calculated value is less than or")

        mstore(add(memPtr, 32), " equal to 100")

    }

    function abi_encode_t_stringliteral_317f7c998ab5ba324acfc05a54f25f646e2187d61bc1c442f85738b0a1ea8cf1_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 45)
        store_literal_in_memory_317f7c998ab5ba324acfc05a54f25f646e2187d61bc1c442f85738b0a1ea8cf1(pos)
        end := add(pos, 64)
    }

    function abi_encode_tuple_t_stringliteral_317f7c998ab5ba324acfc05a54f25f646e2187d61bc1c442f85738b0a1ea8cf1__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_317f7c998ab5ba324acfc05a54f25f646e2187d61bc1c442f85738b0a1ea8cf1_to_t_string_memory_ptr_fromStack( tail)

    }

}
